#!/usr/bin/env bash

#####################################################################
# Global Environment Variables
#####################################################################
readonly SCRIPT_HOME="$(pushd $(dirname $0)/.. >/dev/null ; echo ${PWD})"

readonly MINIKUBE_PROFILE="${MINIKUBE_PROFILE:-minikube-security-tt}"
readonly MINIKUBE_VM_DRIVER="${MINIKUBE_VM_DRIVER:-virtualbox}"


#####################################################################
function banner() {
#####################################################################
    local message=${1:-Missing message argument in function `$FUNCNAME[0]`}

    echo -e "\n\n*********************************************************************"
    echo -e "*** ${message}"
    echo -e "*********************************************************************\n"
}


#####################################################################
function install_Brew() {
#####################################################################
    local package=${1:-Missing package argument in function `$FUNCNAME[0]`}

    brew list "${package}" || brew install "${package}"
}


#####################################################################
function install_BrewCask() {
#####################################################################
    local package=${1:-Missing package argument in function `$FUNCNAME[0]`}

    brew cask list "${package}" || brew cask install "${package}"
}


#####################################################################
function install_VirtualBox() {
#####################################################################
    banner "Installing VirtualBox"

    install_BrewCask virtualbox || exit 1
    install_BrewCask virtualbox-extension-pack || exit 1
}


#####################################################################
function install_Vagrant() {
#####################################################################
    banner "Installing Vagrant"

    install_BrewCask vagrant || exit 1
    install_Brew install vagrant-completion || exit 1
}


#####################################################################
function install_Kali() {
#####################################################################
    pushd "${SCRIPT_HOME}/Kali_Linux" >/dev/null || exit 1

    banner "Installing Kali Linux"
    echo "WARNING - This may take several hours depending on the speed of your internet connection and your laptop"

    vagrant up

    popd >/dev/null || exit 1
}


#####################################################################
function build_SplunkForwarderImage() {
#####################################################################
    pushd "${SCRIPT_HOME}/SplunkForwarder" >/dev/null || exit 1

    banner "Building Splunk Universal Forwarder Docker image"
    echo "NOTE: This will be updated to have more relevant inputs.conf"

    docker build -t splunk_fwdr . | exit 1

    popd >/dev/null || exit 1
}


#####################################################################
function run_SplunkForwarderContainer() {
#####################################################################
    pushd "${SCRIPT_HOME}/SplunkForwarder" >/dev/null || exit 1

    banner "Running Splunk Universal Forwarder Docker container"
    echo "NOTE: This will be transferred to K8s ASAP"

    docker run --rm --env SPLUNK_START_ARGS="--accept-license" -d splunk_fwdr:latest || exit 1

    popd >/dev/null || exit 1
}


#####################################################################
function createAndRun_Minikube() {
#####################################################################
    local installDir=~/.minikube/machines/${MINIKUBE_PROFILE}/

    banner "Creating and running Minikube (profile: ${MINIKUBE_PROFILE})"

    if [ -d ~/.minikube/machines/${MINIKUBE_PROFILE}/ ]; then
        echo "Minikube has already been set-up previously."
        local choice
        read -p "WARNING - Would you like to DESTROY it? (default: n) " choice
        [[ ! "${choice}" =~ ^[Yy]$ ]] && exit 1

        minikube --profile=${MINIKUBE_PROFILE} stop
        minikube --profile=${MINIKUBE_PROFILE} delete
        rm -rf "${installDir}"
    fi

    minikube --profile=${MINIKUBE_PROFILE} start --cache-images --vm-driver=${MINIKUBE_VM_DRIVER} --memory=8192 --cpus=4 || exit 1
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
install_VirtualBox
install_Vagrant
install_Kali
build_SplunkForwarderImage
run_SplunkForwarderContainer
createAndRun_Minikube
