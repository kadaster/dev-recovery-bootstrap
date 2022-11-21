# Development Services recovery bootstrap

Start here to recover Development Services if required. 

## Prerequisites

- A laptop running WSL2 (Windows Subsystem for Linux 2).
- Git client software
- Gitea Recovery Backup from Continuity management.

## How to bootstrap the recovery

1. Open a WSL `Bash shell`, you will enter your `homedirectory`.
1. Get the **latest, uncompromised Gitea recovery backup** file named `recovery-repos-YYYYMMDDhhmm.zip`, from the **Continuity management tooling**, and **place it in directory /tmp**.

Execute the following steps:

1. Unzip the Gitea recovery backup: `unzip /tmp/recovery-repos-YYYYMMDDhhmm.zip -d /tmp`
1. Clone the recovery script sources: `git clone file://tmp/recovery/dev/dev-recovery.git recovery`
1. Start the recovery: `cd recovery; ./recovery.sh`