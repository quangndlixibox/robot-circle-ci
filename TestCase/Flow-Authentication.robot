*** Settings ***
Documentation    Login account using API
... 			 Run testcase command, store report on Results folder with timestamp: "robot --timestampoutputs -d Results TestCase/"
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Library    FakerLibrary   WITH NAME  faker
Resource	../Resources/common_keyword.robot
Resource	../Resources/API/Authentication.robot
Resource	../Resources/variables.robot
#Library	 	../lib/cusLib.py
Suite Setup    Create A Session

*** Test Cases ***
TC_001 Register account by email
	[Tags]  Register
	${email}    Generate Email
	Set Suite Variable  ${email}  ${email}
	${first_name}  Generate First Name
	${last_name}  Generate Last Name
	${name}  Catenate 	${last_name} 	${first_name}
	Set Suite Variable  ${name}  ${name}
	${response}  Register account by email  ${first_name}  ${last_name}  ${email}
	Status Should Be	200  ${response}
	Should Be Equal 	${response.json()['user']['last_name']} 	${last_name}
	Should Be Equal 	${response.json()['user']['first_name']} 	${first_name}
	Should Be Equal 	${response.json()['user']['email']} 	    ${email}

Get User Info and Verify Submited Info
	[Tags] 	User Profile
	${response}  get on session  ${mysession}  /web/user    headers=${header}
	Status Should Be	200  ${response}
	Should Be Equal 	${response.json()['user']['name']} 	    ${name}
	Should Be Equal 	${response.json()['user']['email']} 	${email}

TC_002 Register account by email fails with invalid info
	[Tags] 	Register
	${json_msg}= 	load json from file 	./Resources/reg_error_msg.json

#	                                    First Name 		Last Name		Email					            Password		Status code 	Error Message
  Register account by email Fails     John			    ${null}			wsdeg					            123				  422				    ${json_msg[0]['authen'][0]['error1']}
  Register account by email Fails     Andrew			  ${none}		  dfdfgvsdg@wereregew.com		123				  422				    ${json_msg[0]['authen'][1]['error2']}
  Register account by email Fails     ${none}			  ${none}			dfvfgsdg@wereertgew.com		123				  422				    ${json_msg[0]['authen'][2]['error3']}
#	Register account by email Fails     ${none}			  ${none}			dfvsfgndg@weregew.com		  12345678		422				    ${json_msg[0]['authen'][3]['error4']}
#	Register account by email Fails     ${null}			  ${null}			dfvsdfgng@weregew.com		  12345678		422				    ${json_msg[0]['authen'][4]['error5']}
	Register account by email Fails     John			    Doe				  dfvfrgtsdg					      12345678		422				    ${json_msg[0]['authen'][5]['error6']}
	Register account by email Fails     John			    Doe				  dfvertsdg@asfateraf.com		123				  422				    ${json_msg[0]['authen'][6]['error7']}

TC_003 Login with valid credential
  [Tags]    Login
  ${response}  Login with valid credential  ${email}  ${PASS_LOGIN}
	Verify User Login success  ${response.json()['user']['id']}

TC_005 Login Fails with Invalid credential
	[Tags]	Login
	[Template]	Login with an invalid credential
#	EMAIL							          PASSWORD		  STATUS CODE 	ERROR MESSAGE
	dung.nguyen						      12345678		  422				    ${LOGIN_ERROR_MESSAGE}
	dung.nguyen						      12345			    422				    ${LOGIN_ERROR_MESSAGE}
	dung.nguyen@lixibox.com			12345			    422				    ${LOGIN_ERROR_MESSAGE}
	dung.nguyen@lixibox.com			12345678901		422				    ${LOGIN_ERROR_MESSAGE}
	${EMPTY}						        12345678		  422				    ${LOGIN_ERROR_MESSAGE}
	dung.nguyen@lixibox.com			${EMPTY}		  422				    ${LOGIN_ERROR_MESSAGE}
	ghnthyjyegrtj@35434.c577om  12345678		  422				    ${LOGIN_ERROR_MESSAGE}

Logout the current account
	[Tags]	Logout
	Logout the account



