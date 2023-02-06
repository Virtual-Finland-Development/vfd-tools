#!/usr/bin/env bash
# Starts and stops all the related services
# The script assumes that the services folders are located in the relative parent folder of this script
# The service folders must contain a docker-compose.yml file
#
PROJECT_ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"
VFD_PROJECTS_ROOT=${VFD_PROJECTS_ROOT:-"${PROJECT_ROOT_PATH}/../"}
ARCH=$(uname -m)
DOCKER_COMPOSE_COMMAND=""

# Known services
SERVICES=(
	"authentication-gw"
	"users-api"
	"testbed-api"
	"external-service-demo"
	"access-to-finland-demo-front"
	"status-info-api"
	"status-admin"
	#"tmt-productizer"
	#"JobsInFinland.Api.Productizer"
)

# Argument variables
_argument_services=""
_enable_traefik=0

# parse input arguments
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		start|up)
			DOCKER_COMPOSE_COMMAND="up -d"
			shift
			;;
		stop|down)
			DOCKER_COMPOSE_COMMAND="down"
			shift
			;;
		restart)
			DOCKER_COMPOSE_COMMAND="restart"
			shift
			;;
		status|ps)
			DOCKER_COMPOSE_COMMAND="ps"
			shift
			;;
		--services)
			_argument_services="$2"
			IFS=',' read -ra argument_services_array <<< "$_argument_services"
			SERVICES=("${argument_services_array[@]}")
			shift
			shift
			;;
		--workdir)
			VFD_PROJECTS_ROOT="$2"
			shift
			shift
			;;
		--enable-traefik)
			_enable_traefik=1
			shift
			;;
		--help|-h)
			echo "Usage: runner.sh [start|stop|status]"
			echo "  start|up: Starts the services"
			echo "  stop|down: Stops the services"
			echo "  status|ps: Shows the status of the services"
			echo "  restart: Restarts the services"
			echo "  --services: Comma separated list of services"
			echo "  --workdir: Path to the root of the services folders"
			echo "  --enable-traefik: Enables traefik"
			echo "  --help|-h: Shows this help"
			exit 0
			;;
		*)
			echo "Unknown argument: $key"
			exit 1
			;;
	esac
done

# Check that docker is installed
if ! command -v docker &> /dev/null
then
	echo "Docker could not be found"
	exit 1
fi

# Validate that the services folders exist
for SERVICE in "${SERVICES[@]}"; do
	if [ ! -d "${VFD_PROJECTS_ROOT}/${SERVICE}" ]; then
		echo "Service folder not found: ${VFD_PROJECTS_ROOT}/${SERVICE}"
		exit 1
	fi
	if [ ! -f "${VFD_PROJECTS_ROOT}/${SERVICE}/docker-compose.yml" ]; then
		echo "docker-compose.yml not found in service folder: ${VFD_PROJECTS_ROOT}/${SERVICE}"
		exit 1
	fi
done

# Prep for execution
should_engage_primary_loop=1
should_engage_final_status_check=1

# Check for special case commands
if [ "${DOCKER_COMPOSE_COMMAND}" = "ps" ]; then
	if [ -z ${_argument_services} ]; then
		# If no services were specified, then we don't need to run the primary loop
		should_engage_primary_loop=0
		should_engage_final_status_check=1
	else
		# If services were specified, then we don't need to run the final status check
		should_engage_primary_loop=1
		should_engage_final_status_check=0
	fi
fi

##
# Engage
##
if [ ${should_engage_primary_loop} -eq 1 ]; then

	if [ ${_enable_traefik} -eq 1 ]; then
		# Run traefik
		echo "Running 'docker compose ${DOCKER_COMPOSE_COMMAND}' for traefik"
		docker compose -f ${PROJECT_ROOT_PATH}/docker-compose.traefik.yml ${DOCKER_COMPOSE_COMMAND}
	fi

	# Run docker compose for each service
	for SERVICE in "${SERVICES[@]}"; do
		echo "Running 'docker compose ${DOCKER_COMPOSE_COMMAND}' for ${SERVICE}"
		# Exception for users-api
		if [ ${SERVICE} = "users-api" ]; then
			# If OS architecture is arm64, use the arm64 version of the users-api
			if [ ${ARCH} = "arm64" ] || [ ${ARCH} = "aarch64" ]; then
				export USERAPI_DOCKERFILE="Dockerfile.arm64"
			fi
		fi
		
		# Run docker compose
		docker compose -f ${VFD_PROJECTS_ROOT}/${SERVICE}/docker-compose.yml ${DOCKER_COMPOSE_COMMAND}
	done
fi 

if [ ${should_engage_final_status_check} -eq 1 ]; then
	# Echo the status of the services
	echo ""
	echo "> Status of the services:"
	docker ps
fi