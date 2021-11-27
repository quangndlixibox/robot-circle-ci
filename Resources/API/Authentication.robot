*** Setting ***
Library 	RequestsLibrary
Library    String
Resource 	../variables.robot
Resource	../common_keyword.robot

*** Keywords ***
Register account by email
	[Arguments]  ${first_name}  ${last_name}  ${email}
	${body}  Create Dictionary	csrf_token=wfadfbadfbadf   first_name=${first_name}  last_name=${last_name}  email=${email}  password=12345678
	${response}  Post On Session  ${mysession}  /web/registrations    headers=${header}    json=${body}
	[Return]  ${response}

Register account by email Fails
	[Arguments] 	${first_name} 	${last_name} 	${email} 	${password} 	${stt_code} 	${error_msg}
	${body}  Create Dictionary	csrf_token=wfadfbadfbadf   first_name=${first_name}  last_name=${last_name}  email=${email}  password=${password}
	${header}  Create Dictionary   Content-type=application/json
	${response}  Post On Session  ${mysession}  /web/registrations    headers=${header}    json=${body} 	expected_status=any
	Status Should Be	${stt_code}	${response}
	Log 	response.json(): ${response.json()}
	should be equal 	${response.json()} 	${error_msg}

Login with valid credential
  [Arguments]  ${email}  ${PASS_LOGIN}
  ${body}  Create Dictionary  email=${email}  password=${PASS_LOGIN}
	${response}=  Post On Session  ${mysession}  /web/sessions    headers=${header}    json=${body}
	Status Should Be	200	${response}
	[Return]  ${response}

Logout the account
	${params}=  Create Dictionary    csrf_token=fhbs4346hgehret
	${response}=  delete on session 	${mysession}  /web/sessions 	params=${params}    headers=${header}
	Status Should Be	200	${response}

Login and get access token
  [Arguments]  ${email}
  ${body}  Create Dictionary  email=${email}  password=${PASS_LOGIN}
	${response}=  Post On Session  ${mysession}  /web/sessions    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Verify User Login success  ${response.json()['user']['id']}
	Get Access Token after Login success  ${response}

Request to reset password with email ${email}
  ${body}  Create Dictionary  email=${email}  csrf_token=fhbs4346hgehrdvsdvet
	${response}=  Post On Session  ${mysession}  /web/passwords    headers=${header}    json=${body}
	Status Should Be	200	${response}

Click profile