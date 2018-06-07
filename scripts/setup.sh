#!/usr/bin/env bash

#####################################################################
# Global Environment Variables
#####################################################################
readonly SCRIPT_HOME="$(pushd $(dirname $0)/.. >/dev/null ; echo ${PWD})"
readonly VM_DRIVER="fusion"
readonly MINIKUBE_PROFILE="minikube-security-tt"


#####################################################################
function banner() {
#####################################################################
    local message=${1:-Missing message in function `$FUNCNAME[0]`}
    echo -e "\n*** ${message}\n"
}


#####################################################################
function build_SplunkForwarderImage() {
#####################################################################
    pushd SplunkForwarder >/dev/null

    banner "Building Splunk Universal Forwarder Docker image"
    echo "NOTE: This will be updated to have more relevant inputs.conf"

    docker build -t splunk_fwdr . | exit 1

    popd SplunkForwarder >/dev/null
}


#####################################################################
function run_SplunkForwarderContainer() {
#####################################################################
    pushd SplunkForwarder >/dev/null

    banner "Running Splunk Universal Forwarder Docker container"
    echo "NOTE: This will be transferred to K8s ASAP"

    docker run --rm --env SPLUNK_START_ARGS="--accept-license" -d splunk_fwdr:latest || exit 1

    popd SplunkForwarder >/dev/null
}


#####################################################################
function createAndRun_Minikube() {
#####################################################################
    local installDir=~/.minikube/machines/${MINIKUBE_PROFILE}/

    banner "Creating and running Minikube (profile: ${MINIKUBE_PROFILE})"

    if [ -d ~/.minikube/machines/${MINIKUBE_PROFILE}/ ]; then
        echo "Minikube has already been set-up previously."
        local choice
        read -p "Would you like to DESTROY it? (default: n) " choice
        [[ ! "${choice}" =~ ^[Yy]$ ]] && exit 1

        minikube --profile=${MINIKUBE_PROFILE} stop
        minikube --profile=${MINIKUBE_PROFILE} delete
        rm -rf "${installDir}"
    fi

    minikube --profile=${MINIKUBE_PROFILE} start --vm-driver=${VM_DRIVER} --memory=8192 --cpus=4 || exit 1
}

#####################################################################
function deploy_PackagesToMinikube() {
#####################################################################
    banner "Deploying packages to Minikube (profile: ${MINIKUBE_PROFILE})"

    helm --context=${MINIKUBE_PROFILE} init || exit 1

    local wordpressPassword
    local mariadbRootPassword
    local mariadbPassword

    read -s -p "Enter value for 'wordpressPassword': " wordpressPassword
    read -s -p "Enter value for 'mariadbRootPassword': " mariadbRootPassword
    read -s -p "Enter value for 'mariadbPassword': " mariadbPassword

    helm --context=${MINIKUBE_PROFILE} install \
         -f WordPress/values-stable-wordpress-topicteam.yaml \
         stable/wordpress \
         --set-string wordpressPassword="${wordpressPassword}" \
         --set-string mariadbRootPassword="${mariadbRootPassword}" \
         --set-string mariadbPassword="${mariadbPassword}" || exit 1
}


#####################################################################
# Main Programme Entry
#####################################################################
build_SplunkForwarderImage
run_SplunkForwarderContainer
createAndRun_Minikube
