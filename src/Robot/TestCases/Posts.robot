*** Settings ***
Documentation       Validação automatizada das rotas de postagens -> /posts

Library             FakerLibrary
Library             Zoomba.APILibrary
Resource            ../Resources/Posts.robot
Resource            ../Resources/Comments.robot
Resource            ../Component/Validate_Dict.robot


*** Variables ***
&{headers}=       Content-Type=application/json      charset=UTF-8

*** Keywords ***
Get all posts
    ${RESPONSE}=   Call Get Request     
    ...    headers=${headers}     
    ...    endpoint=${ENVS['BASE_API']}     
    ...    fullstring=/posts

    Should Be Equal As Strings    ${RESPONSE.status_code}    200

    FOR    ${element}    IN    @{RESPONSE.json()}
        Validate Dict    ${element}    ${POSTS}
    END

    Set Suite Variable    ${POST_ID}    ${RESPONSE.json()[0]['id']}

Get one post
    ${RESPONSE}=   Call Get Request     
    ...    headers=${headers}     
    ...    endpoint=${ENVS['BASE_API']}     
    ...    fullstring=/posts/${POST_ID}

    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Validate Dict    ${RESPONSE.json()}    ${POSTS}

Get comments of one post
    ${RESPONSE}=   Call Get Request     
    ...    headers=${headers}     
    ...    endpoint=${ENVS['BASE_API']}     
    ...    fullstring=/posts/${POST_ID}/comments

    Should Be Equal As Strings    ${RESPONSE.status_code}    200

    FOR    ${element}    IN    @{RESPONSE.json()}
        Validate Dict    ${element}    ${COMMENTS_LIST}
    END

Creat post
    ${title}    FakerLibrary.Text
    ${body}    FakerLibrary.Texts

    ${POST_ITEM}    Create Dictionary
    ...    title=${title}
    ...    body=${body}
    ...    userId=1

    ${RESPONSE}=   Call Post Request     
    ...    headers=${headers}     
    ...    endpoint=${ENVS['BASE_API']}     
    ...    fullstring=/posts
    ...    data=${POST_ITEM}

    Should Be Equal As Strings    ${RESPONSE.status_code}    201

    Validate Dict    ${RESPONSE.json()}    ${POSTS}
    Dictionary Should Contain Item    ${RESPONSE.json()}    title    ${title}
    Dictionary Should Contain Item    ${RESPONSE.json()}    body    ${body}
    Dictionary Should Contain Item    ${RESPONSE.json()}    userId    1

Update post completely
    ${title}    FakerLibrary.Text
    ${body}    FakerLibrary.Texts

    ${POST_ITEM}    Create Dictionary
    ...    title=${title}
    ...    body=${body}
    ...    userId=1

    ${RESPONSE}=   Call Put Request     
    ...    headers=${headers}     
    ...    endpoint=${ENVS['BASE_API']}     
    ...    fullstring=/posts/${POST_ID}
    ...    data=${POST_ITEM}

    Should Be Equal As Strings    ${RESPONSE.status_code}    200

    Validate Dict    ${RESPONSE.json()}    ${POSTS}
    Dictionary Should Contain Item    ${RESPONSE.json()}    title    ${title}
    Dictionary Should Contain Item    ${RESPONSE.json()}    body    ${body}
    Dictionary Should Contain Item    ${RESPONSE.json()}    userId    1

Update item in post
    ${title}    FakerLibrary.Text

    ${POST_ITEM}    Create Dictionary
    ...    title=${title}

    ${RESPONSE}=   Call Patch Request     
    ...    headers=${headers}     
    ...    endpoint=${ENVS['BASE_API']}     
    ...    fullstring=/posts/${POST_ID}
    ...    data=${POST_ITEM}

    Should Be Equal As Strings    ${RESPONSE.status_code}    200

    Validate Dict    ${RESPONSE.json()}    ${POSTS}
    Dictionary Should Contain Item    ${RESPONSE.json()}    title    ${title}

Delete post
    ${RESPONSE}=   Call Delete Request     
    ...    headers=${headers}     
    ...    endpoint=${ENVS['BASE_API']}     
    ...    fullstring=/posts/${POST_ID}

    Should Be Equal As Strings    ${RESPONSE.status_code}    200