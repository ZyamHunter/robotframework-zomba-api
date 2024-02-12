*** Settings ***
Documentation       Validação automatizada das rotas de postagens -> /posts

Library             Zoomba.APILibrary
Resource            ../Resources/Comments.robot
Resource            ../Component/Validate_Dict.robot

*** Variables ***
&{headers}=       Content-Type=application/json      charset=UTF-8

*** Keywords ***
Get all comments
    ${params}    Create Dictionary
    ...    postId=${POST_ID}

    ${RESPONSE}    Call Get Request    
    ...    headers=${headers}     
    ...    endpoint=${ENVS['BASE_API']} 
    ...    fullstring=/comments
    ...    params=${params}    

    Should Be Equal As Strings    ${RESPONSE.status_code}    200

    FOR    ${element}    IN    @{RESPONSE.json()}
        Validate Dict    ${element}    ${COMMENTS_LIST}
    END