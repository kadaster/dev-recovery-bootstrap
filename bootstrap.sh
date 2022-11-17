#!/usr/bin/env bash

# -----------------------------------------------------
# Bootstrap script for recovery of Development Services
# -----------------------------------------------------

# Set some colors for output
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m' #No Color

# Colored 
info ()
{
    echo "${GREEN}INFO: ${@}${NC}"
}

fatal ()
{
    echo "${RED}FATAL: ${@}${NC}"
    exit
}

warning ()
{
    echo "${YELLOW}WARNING: ${@}${NC}"
}

text ()
{
    N=${1}
    if [ "${N}" = "-n" ]; then shift; else N=""; fi
    echo ${N} "${NC}${@}${NC}"
}

print-header ()
{
    text ""
    text "--------------------------------------------------------------------------"
    text "--> ${GREEN}${@}${NC}"
    text "--------------------------------------------------------------------------"
    text ""
}

azure-login ()
{
    text ""
    text "Obtain the PAM password from Secret Server."
    text -n "--> PAM account : "; AZ_ACCOUNT=${1}; text "${AZ_ACCOUNT}"
    text -n "--> Password    : "; read -s AZ_PASSWORD; text ""
    return 0
}

azure-logout ()
{
    text ""
    text "Logged out !!"
    text ""
    return 0
}

# Determine whether the next Gitea recovery step should be executed
execute-step ()
{
    while :
    do
        text -n "Execute this step ? Type y(es), s(kip) or q(uit script) ? "; read EXECUTE_STEP
        case ${EXECUTE_STEP} in
            y)
                info "Executing step !"
                text ""
                return 0
                ;;

            s)
                warning "Step is skipped ! Going to next step."
                text ""
                return 1
                ;;

            q)  
                warning "Quitting script .....!"
                exit
                ;;
        
            *)
                warning "Unknown option. Try again !"
        esac
    done
}

# Determine whether steps should be skipped or not
start-with-step ()
{
    while :
    do
        declare -i S=1
        text "Bootstrap steps for recovery of Development Services:"
        text ""
        text "   $((S++)): Obtain the backup file of the Development Services repositories"
        text "   $((S++)): Extract Git Repositories"
        text "   $((S++)): Recover Development Services"
        text "   ${S}: EXIT"
        text ""
        text -n "Start with step ? "; read START_STEP
        if [[ ${START_STEP} -ge 1 ]] && [[ ${START_STEP} -le ${S} ]]; then return; fi
        text ""
    done
}

step-get-repositories-backup-file ()
{
    print-header "STEP: Get the backup of the Development Services Git repositories"
    text "A current backup of the Development Services Git repositories is required "
    text "to continue. Obtain this backup first and copy it to your local laptop harddrive."
    text ""
    execute-step
}

step-recover-gitea-repositories ()
{
    print-header "STEP: Extract bootstrap Gitea recovery repositories from backup file."

    execute-step &&
    (
        # Determine the name of the Gitea recovery backup file
        while :
        do
            text -n "Filename of the Gitea recovery backup: "; read BACKUP_FILE
            GITEA_REPO_BACKUP=${PWD}/${BACKUP_FILE}
            if [[ -f ${GITEA_REPO_BACKUP} ]]
            then
                break
            else
                warning "File \"${GITEA_REPO_BACKUP}\" does not exist ! Try again !"
            fi
        done

        # Clean the current content of the repository mirror directory and the workspaces directory
        MIRROR_DIR=mirrors
        WORKSPACE_DIR=workspaces
        ZIP_DIR=recovery
        rm -rf ${MIRROR_DIR}
        rm -rf ${WORKSPACE_DIR}
        rm -rf ${ZIP_DIR}
        info "Extracting Git repositories from backup file \"${GITEA_REPO_BACKUP}\" ...."
        unzip ${GITEA_REPO_BACKUP} || fatal "Extraction of files from backup file \"${GITEA_REPO_BACKUP}\" failed !"
        mv recovery ${MIRROR_DIR}
        info "Git repositories extracted to directory \"${MIRROR_DIR}\"."
        for MIRROR_REPO in ${PWD}/${MIRROR_DIR}/*/*
        do
            ORGANIZATION_DIR=${WORKSPACE_DIR}/$(basename $(dirname ${MIRROR_REPO}))
            mkdir -p ${ORGANIZATION_DIR}
            cd ${ORGANIZATION_DIR}
            info "Cloning repository ${MIRROR_REPO} into directory ${ORGANIZATION_DIR} ...."
            git clone file://${MIRROR_REPO} || warning "Could not clone repository ${MIRROR_REPO}"
            info "Repository cloned successfully !!"
            text ""
            cd ..
        done
        info "The following repositories were cloned:"
        ls -ld ${WORKSPACE_DIR}/*
        info "Gitea recovery repositories CLONED into directory \"${WORKSPACE_DIR}\"."
    )
}

step-recover-development-services ()
{
    print-header "STEP: Recover development services"
    execute-step && 
    (
        text "Start recovering Development Services" 
    )
}

main ()
{
    declare -i STEP_NUMBER=1

    # Determine the step to start recovery with (variable START_STEP)
    start-with-step

    # Execute required recovery steps only 
    [ ${START_STEP} -le $((STEP_NUMBER++)) ] && step-get-repositories-backup-file
    [ ${START_STEP} -le $((STEP_NUMBER++)) ] && step-recover-gitea-repositories
    [ ${START_STEP} -le $((STEP_NUMBER++)) ] && step-recover-development-services
    [ ${START_STEP} -le $((STEP_NUMBER++)) ] && text ""
}

# This script starts here ...
main
