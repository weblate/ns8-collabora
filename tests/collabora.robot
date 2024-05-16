*** Settings ***
Library    SSHLibrary

*** Test Cases ***
Check if collabora is installed correctly
    ${output}  ${rc} =    Execute Command    add-module ${IMAGE_URL} 1
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    &{output} =    Evaluate    ${output}
    Set Suite Variable    ${module_id}    ${output.module_id}

Check if collabora can be configured
    ${rc} =    Execute Command    api-cli run module/${module_id}/configure-module --data '{
            "host": "collabora.nethserver.org",
            "http2https": true,
            "lets_encrypt": true,
            "admin_password": "password"}'
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0

Check if collabora is removed correctly
    ${rc} =    Execute Command    remove-module --no-preserve ${module_id}
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0
