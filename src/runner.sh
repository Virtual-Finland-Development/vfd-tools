#!/usr/bin/env bash
# Starts and stops all the related services
# The script assumes that the services folders are located in the relative parent folder of this script
# The service folders must contain a docker-compose.yml file
#
PROJECT_ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"
VFD_PROJECTS_ROOT=${VFD_PROJECTS_ROOT:-"${PROJECT_ROOT_PATH}/../"}
ARCH=$(uname -m)
source ${PROJECT_ROOT_PATH}/env.config.sh

# Commandline/input argument variables
_argument_primary_services=""
_argument_secondary_services=""
_use_traefik=${VFD_USE_TRAEFIK:-true}
_argument_command=""
_argument_command_spec=""
_argument_command_extra_args_array=()

###
# Helper functions
###
function print_traefik_hosts_info() {
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
	else
		echo "> Install jq and curl to see the traefik hosts"
	fi
}

function ensure_docker_network() {
	docker network create vfd-network &> /dev/null
}

###
# Main
###

# parse input arguments
while [[ $# -gt 0 ]]; do
	key=${1}
	value=${2}
	value_specified=false

	# If key is an option and includes an equal sign, then split it into key and value
	if [[ ${key} == *"--"* ]]; then
		if [[ ${key} == *"="* ]]; then
			value_specified=true
			value=${key#*=}
			key=${key%%=*}
		else
			shift # move to next argument
		fi
	fi 
	shift

	case ${key} in
		init|git-clone)
			_argument_command="git-clone"
			;;
		git-pull)
			_argument_command="git-pull"
			;;
		git-status)
			_argument_command="git-status"
			;;
		start|up)
			_argument_command="docker-compose"
			_argument_command_spec="up -d"
			;;
		stop|down)
			_argument_command="docker-compose"
			_argument_command_spec="down"
			;;
		restart)
			_argument_command="docker-compose"
			_argument_command_spec="restart"
			;;
		status|ps)
			_argument_command="docker-compose"
			_argument_command_spec="ps"
			;;
		logs)
			_argument_command="docker-compose"
			_argument_command_spec='logs --tail=20'
			;;
		list|list-services)
			_argument_command="list-services"
			;;
		list-hosts|list-traefik-hosts)
			_argument_command="list-traefik-hosts"
			;;
		--services)
			_argument_primary_services="${value}"
			;;
		--secondary-services)
			_argument_secondary_services="${value}"
			;;
		--all)
			_argument_primary_services=$(IFS=, ; echo "${VFD_SERVICES[*]}")
			_argument_secondary_services=$(IFS=, ; echo "${VFD_EXTRA_SERVICES[*]}")
			;;
		--workdir)
			VFD_PROJECTS_ROOT="${value}"
			;;
		--no-traefik)
			_use_traefik=false
			;;
		--no-detach)
			if [ "${_argument_command_spec}" == "up -d" ]; then
				_argument_command_spec="up"
			else
				echo "Invalid option: --no-detach"
				exit 1
			fi
			;;
		--help|-h)
			echo "Usage: runner.sh <command> [--services service1,service2] [--workdir path/to/services] ..."
			echo "  init|git-clone: git clone the project folders if they don't exist"
			echo "  git-pull: git pull the project folders"
			echo "  git-status: git status the project folders"
			echo "  start|up [--no-detach]: Starts the services"
			echo "  stop|down: Stops the services"
			echo "  status|ps: Shows the status of the services"
			echo "  logs: Shows part of the logs of the services"
			echo "  restart: Restarts the services"
			echo "  list|list-services: Lists the known services"
			echo "  list-hosts|list-traefik-hosts: Lists traeffik hosts (if service up)"
			echo "  --services: Comma separated list of services to start/stop/status/restart"
			echo "  --secondary-services: Comma separated list of extra services to start/stop/status/restart"
			echo "  --all: Starts primary and secondary services"
			echo "  --workdir: Path to the root of the services folders"
			echo "  --no-traefik: Disables traefik"
			echo "  --help|-h: Shows this help"
			exit 0
			;;
		*)
			if [ value_specified = true ]; then
				_argument_command_extra_args_array+=("${key}=${value}")
			else
				_argument_command_extra_args_array+=("${key}")
			fi
			;;
	esac
done

if [ -z ${_argument_command} ]; then
	echo "No command specified"
	echo "Use --help for usage"
	exit 1
fi

# Check that docker is installed
if ! command -v docker &> /dev/null
then
	echo "Docker could not be found"
	exit 1
fi

# Prepare the services array
if [ -z ${_argument_primary_services} ]; then
	if [ -z ${VFD_SERVICES} ]; then
		echo "VFD_SERVICES is not set in env.services.sh"
		exit 1
	fi
else
	IFS=',' read -ra argument_services_array <<< "$_argument_primary_services"
	VFD_SERVICES=("${argument_services_array[@]}")

	if [ ${#VFD_SERVICES[@]} -eq 0 ]; then
		echo "No services specified"
		exit 1
	fi
fi

# Append extra services
if [ ! -z ${_argument_secondary_services} ]; then
	IFS=',' read -ra argument_extra_services_array <<< "$_argument_secondary_services"
	VFD_SERVICES+=("${argument_extra_services_array[@]}")
fi

if [ "${_argument_command}" = "git-clone" ]; then
	echo "Initializing service folders.."

	if [ -z "${VFD_GIT_URL}" ]; then
		echo "VFD_GIT_URL is not set in env.services.sh"
		exit 1
	fi

	for SERVICE in "${VFD_SERVICES[@]}"; do
		if [ ! -d "${VFD_PROJECTS_ROOT}/${SERVICE}" ]; then
			echo "Trying to git clone: ${VFD_PROJECTS_ROOT}/${SERVICE}"
			git clone "${VFD_GIT_URL}/${SERVICE}.git" "${VFD_PROJECTS_ROOT}/${SERVICE}"
		fi
	done

	echo "Done"
	exit 0
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

if [ "${_argument_command}" = "list-traefik-hosts" ]; then
	print_traefik_hosts_info
	exit 0
fi

if [ "${_argument_command}" = "git-pull" ]; then
	echo "Git pulling service folders.."
	for SERVICE in "${VFD_SERVICES[@]}"; do
		echo "> Pulling: ${SERVICE}.."
		git -C "${VFD_PROJECTS_ROOT}/${SERVICE}" pull
	done
	exit 0
fi

if [ "${_argument_command}" = "git-status" ]; then
	echo "Git checking service folder statuses.."
	for SERVICE in "${VFD_SERVICES[@]}"; do
		echo "> Checking: ${SERVICE}.."
		git -C "${VFD_PROJECTS_ROOT}/${SERVICE}" status
	done
	exit 0
fi

##
# Run docker commands
##
if [ "${_argument_command}" != "docker-compose" ]; then
	echo "Unknown argument command: ${_argument_command}"
	exit 1
fi

# Prep for execution
should_engage_primary_loop=1
should_engage_final_status_check=1
docker_compose_command=${_argument_command_spec}

# Check for special case commands
if [ "${docker_compose_command}" = "ps" ]; then
	if [ -z ${_argument_primary_services} ]; then
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

	# ensure docker net
	ensure_docker_network

	if [ "${_use_traefik}" = true ]; then
		# Run traefik on ups or downs
		if [[ "${docker_compose_command}" == "up"* ]]; then
			echo "Bringing traefik up.."
			docker compose -f ${PROJECT_ROOT_PATH}/docker-compose.traefik.yml up -d
		elif [[ "${docker_compose_command}" == "down"* ]]; then
			echo "Bringing traefik down.."
			docker compose -f ${PROJECT_ROOT_PATH}/docker-compose.traefik.yml down
		fi
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
		docker compose -f ${VFD_PROJECTS_ROOT}/${SERVICE}/docker-compose.yml ${docker_compose_command} ${_argument_command_extra_args_array[@]}
	done
fi 

if [ ${should_engage_final_status_check} -eq 1 ]; then
	# Echo the status of the services
	echo ""
	echo "> Status of the services:"
	docker ps

	if [[ "${docker_compose_command}" == "up"* ]]; then
		if [ "${_use_traefik}" = true ]; then
			sleep 2 # Give services a moment to start
			print_traefik_hosts_info
		fi
	fi
fi