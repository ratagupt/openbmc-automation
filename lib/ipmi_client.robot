*** Settings ***
Documentation           This module is for IPMI client for copying ipmitool to
...                     openbmc box and execute ipmitool commands.

Resource        ../lib/resource.txt

Library                SSHLibrary

*** Keywords ***
Open Connection And Log In
    Open connection     ${OPENBMC_HOST}
    Login   ${OPENBMC_USERNAME}    ${OPENBMC_PASSWORD}
    Copy ipmitool

Run IPMI Command
    [arguments]    ${args}
    ${output}=  Execute Command    /tmp/ipmitool -I dbus raw ${args}
    set test variable    ${OUTPUT}     "${output}"

Copy ipmitool
    Import Library      SCPLibrary      WITH NAME       scp
    scp.Open connection     ${OPENBMC_HOST}     username=${OPENBMC_USERNAME}      password=${OPENBMC_PASSWORD}
    scp.Put File    tools/ipmitool   /tmp
    SSHLibrary.Open Connection     ${OPENBMC_HOST}
    Login   ${OPENBMC_USERNAME}    ${OPENBMC_PASSWORD}
    Execute Command     chmod +x /tmp/ipmitool
