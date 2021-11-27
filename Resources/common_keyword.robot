*** Setting ***
Library 	RequestsLibrary
Library    String
Resource 	./variables.robot

*** Keywords ***
Create A Session
	Create Session    mysession    ${URL}    verify=true
	Set Global Variable    ${mysession}    mysession
	${header}  Create Dictionary   Content-type=application/json
	Set Global Variable 	${header} 	${header}

Generate Email
	${email}    faker.Email
	${random}  generate random string  8  [LOWER]
	${email}    Catenate  SEPARATOR=_  test  ${random}  ${email}
	[Return]  ${email}

Generate First Name
	${first_name}		faker.First Name
	[Return]  ${first_name}

Generate Last Name
	${last_name}		faker.Last Name
	[Return]  ${last_name}

Generate Phone Number
	${random_no}		Generate random string    9    0123456789
	${phone_no}  Catenate  SEPARATOR=  0  ${random_no}
	Log  ${phone_no}
	[Return]  ${phone_no}

Login with an invalid credential
	[Arguments]	${email}	${password}    ${stt_code}	${error_msg}
	${body}  Create Dictionary  email=${email}  password=${password}
	${header}  Create Dictionary   Content-type=application/json
	${response}=  Post On Session  ${mysession}  /web/sessions    headers=${header}    json=${body} 	expected_status=any
	Status Should Be	${stt_code}	${response}
	Should Be Equal 	${response.json()['error']} 	${error_msg}
	Log 	${response.json()['error']}

Get Access Token after Login success
  [Arguments]  ${response}
	${cookie_list}  Split String  ${response.headers['Set-Cookie']}  ;
	${cookie_list}  Split String  ${cookie_list[0]}  =
	Set Global Variable  ${access_token}  ${cookie_list[1]}

Logout the current session
	${params}=  Create Dictionary    csrf_token=fhbs4346hgehret
	${response}=  delete on session 	${mysession}  /web/sessions 	params=${params}    headers=${header}
	Status Should Be	200	${response}

Verify User Login success
  [Arguments]  ${user_id}
  ${response}=  Get On Session  ${mysession}  /web/user/profile    headers=${header}
	Status Should Be	200	${response}
	Should Be Equal  ${user_id}  ${response.json()['user']['id']}

Cancel COD order after success
  [Arguments]  ${order_number}
  ${body}  Create Dictionary	csrf_token=wfadfbadfbadf   number=${order_number}  cancel_reason_id=1
	${header}  Create Dictionary   Content-type=application/json
	${response}  Patch On Session  ${mysession}  /web/orders/${order_number}    headers=${header}    json=${body}
	Status Should Be	200  ${response}
	Log 	response.json(): ${response.json()}


Apply Invalid Discount code and verify
  [Arguments]  ${Discount_code}  ${stt_code}  ${DiscountCode_Error_Msg}
  ${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		discount_code=${Discount_code}
	${response}=  Post On Session  ${mysession}  /web/cart/add_discount_code    headers=${header}    json=${body}  expected_status=any
	Status Should Be	${stt_code}  ${response}
	List should contain value  ${response.json()['errors']}  ${DiscountCode_Error_Msg}

