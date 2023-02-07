#!/usr/bin/env bash
# Starts and stops all the related services
# The script assumes that the services folders are located in the relative parent folder of this script
# The service folders must contain a docker-compose.yml file
#
PROJECT_ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"
VFD_PROJECTS_ROOT=${VFD_PROJECTS_ROOT:-"${PROJECT_ROOT_PATH}/../"}
ARCH=$(uname -m)

# Commandline/input argument variables
_argument_services=""
_use_traefik=${VFD_USE_TRAEFIK:-true}
_argument_command="docker-compose"
_argument_command_spec=""


# parse input arguments
while [[ $# -gt 0 ]]; do
	key=${1}
	value=${2}

	# If key is an option and includes an equal sign, then split it into key and value
	if [[ ${key} == *"--"* ]] && [[ ${key} == *"="* ]]; then
		value=${key#*=}
		key=${key%%=*}
	fi 

	case ${key} in
		start|up)
			_argument_command_spec="up -d"
			shift
			;;
		stop|down)
			_argument_command_spec="down"
			shift
			;;
		restart)
			_argument_command_spec="restart"
			shift
			;;
		status|ps)
			_argument_command_spec="ps"
			shift
			;;
		logs)
			_argument_command_spec='logs --tail=20'
			shift
			;;
		list|list-services)
			_argument_command="list-services"
			shift
			;;
		--services)
			_argument_services="${value}"
			shift
			shift
			;;
		--workdir)
			VFD_PROJECTS_ROOT="${value}"
			shift
			shift
			;;
		--no-traefik)
			_use_traefik=false
			shift
			;;
		--help|-h)
			echo "Usage: runner.sh <command> [--services service1,service2] [--workdir path/to/services] ..."
			echo "  start|up: Starts the services"
			echo "  stop|down: Stops the services"
			echo "  status|ps: Shows the status of the services"
			echo "  logs: Shows part of the logs of the services"
			echo "  restart: Restarts the services"
			echo "  list|list-services: Lists the known services"
			echo "  --services: Comma separated list of services to start/stop/status/restart"
			echo "  --workdir: Path to the root of the services folders"
			echo "  --no-traefik: Disables traefik"
			echo "  --help|-h: Shows this help"
			exit 0
			;;
		*)
			echo "Unknown argument: ${key}"
			echo "Use --help for usage"
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


# Prepare the services array
if [ -z ${_argument_services} ]; then
	source ${PROJECT_ROOT_PATH}/env.services.sh
	if [ -z ${VFD_SERVICES} ]; then
		echo "VFD_SERVICES is not set in env.services.sh"
		exit 1
	fi
else
	IFS=',' read -ra argument_services_array <<< "$_argument_services"
	VFD_SERVICES=("${argument_services_array[@]}")

	if [ ${#VFD_SERVICES[@]} -eq 0 ]; then
		echo "No services specified"
		exit 1
	fi
fi


# Validate that the services folders exist
for SERVICE in "${VFD_SERVICES[@]}"; do
	if [ ! -d "${VFD_PROJECTS_ROOT}/${SERVICE}" ]; then
		echo "Service folder not found: ${VFD_PROJECTS_ROOT}/${SERVICE}"
		exit 1
	fi
	if [ ! -f "${VFD_PROJECTS_ROOT}/${SERVICE}/docker-compose.yml" ]; then
		echo "docker-compose.yml not found in service folder: ${VFD_PROJECTS_ROOT}/${SERVICE}"
		exit 1
	fi
done

##
# Run argument commands
##
if [ "${_argument_command}" = "list-services" ]; then
	echo "Known services:"
	for SERVICE in "${VFD_SERVICES[@]}"; do
		echo "  ${SERVICE}"
	done
	exit 0
fi

if [ "${_argument_command}" != "docker-compose" ]; then
	echo "Unknown argument command: ${_argument_command}"
	exit 1
fi

##
# Run docker commands
##

# Prep for execution
should_engage_primary_loop=1
should_engage_final_status_check=1
docker_compose_command=${_argument_command_spec}

# Check for special case commands
if [ "${docker_compose_command}" = "ps" ]; then
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

# If command starts with "logs", then we don't need to run the final status check
if [[ "${docker_compose_command}" == "logs"* ]]; then
	should_engage_final_status_check=0
	_use_traefik=false
fi

##
# Engage
##
if [ ${should_engage_primary_loop} -eq 1 ]; then

	if [ "${_use_traefik}" = true ]; then
		# Run traefik
		echo "Running 'docker compose ${docker_compose_command}' for traefik"
		docker compose -f ${PROJECT_ROOT_PATH}/docker-compose.traefik.yml ${docker_compose_command}
	fi

	# Run docker compose for each service
	for SERVICE in "${VFD_SERVICES[@]}"; do
		echo "Running 'docker compose ${docker_compose_command}' for ${SERVICE}"
		# Exception for users-api
		if [ ${SERVICE} = "users-api" ]; then
			# If OS architecture is arm64, use the arm64 version of the users-api
			if [ ${ARCH} = "arm64" ] || [ ${ARCH} = "aarch64" ]; then
				export USERAPI_DOCKERFILE="Dockerfile.arm64"
			fi
		fi
		
		# Run docker compose
		docker compose -f ${VFD_PROJECTS_ROOT}/${SERVICE}/docker-compose.yml ${docker_compose_command}
	done
fi 

if [ ${should_engage_final_status_check} -eq 1 ]; then
	# Echo the status of the services
	echo ""
	echo "> Status of the services:"
	docker ps

	if [[ "${docker_compose_command}" == "up"* ]]; then
		if [ "${_use_traefik}" = true ]; then
			echo ""
			echo "> Traefik dashboard: http://localhost:8081"

			# If jq and curl installed
			if command -v jq &> /dev/null && command -v curl &> /dev/null; then
				# Fetch the hosts from traefik
				trafick_hosts=$(curl -s http://localhost:8081/api/rawdata | jq -r '.routers[].rule | select(. | contains("Host(")) | split("Host(`") | .[1] | split("`") | .[0]')
				if [ ! -z "${trafick_hosts}" ]; then
					echo "> Hosts:"
					echo "${trafick_hosts}" | while read -r line; do
						echo "  http://${line}"
					done
				fi
			fi
		fi
	fi
fi