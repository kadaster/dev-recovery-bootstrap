# Development Services recovery bootstrap

Start here to recover Development Services if required. 

⚠👇🏼👇🏼👇🏼👇🏼⚠

This repository is mirrored to https://github.com/kadaster/dev-recovery-bootstrap and necessary in case of a complete disaster and nothing is left. 

IN THAT CASE: START READING THERE !

## Description

To recover from a disaster you need the latest uncompromised Gitea recovery backup. This backup contains the Git source code repositories (mirror clones) of all Development Services. The recovery bootstrap encompasses:

1. Unzipping the Gitea recovery backup.
1. Cloning of the dev-recovery repository which is part of the backup.
1. Execution of the recovery script. 

## Prerequisites

- A `laptop` running WSL2 (Windows Subsystem for Linux 2).
- `Git client` software
- The `latest umcompromised Gitea Recovery backup` from Continuity management.

## Execution

1. Open a WSL `Bash shell`, you will enter your `homedirectory`.
1. Get the **latest, uncompromised Gitea recovery backup** file named `recovery-repos-YYYYMMDDhhmm.zip`, from the **Continuity management tooling**, and **place it in directory /tmp**. Currently, there's no description how to obtain such a backup.
1. Unzip the Gitea recovery backup: `unzip /tmp/recovery-repos-YYYYMMDDhhmm.zip -d /tmp`
1. Clone the recovery script sources: `git clone file://tmp/recovery/dev/dev-recovery.git ~/recovery`
1. `cd ~/recovery
1. Start the recovery: `./recovery.sh | tee -a recovery.log`

## Note
- The recovery process encompasses several steps. 
- After the recovery script is started it displays a menu describing the steps of the recovery process. 
- The script can be stopped if necessary and restarted again, skipping steps that have been executed already. 
- Please log the recovery script output by using `tee` and append logging to an existing logfile, especially when you restart the recovery script.