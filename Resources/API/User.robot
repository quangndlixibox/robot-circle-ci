*** Settings ***
Documentation    Login account using API
... 			 Run testcase command, store report on Results folder with timestamp: "robot --timestampoutputs -d Results TestCase/"
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Library    FakerLibrary   WITH NAME  faker
Resource	../Resources/common_keyword.robot
Resource	../Resources/variables.robot
#Library	 	../lib/cusLib.py
Suite Setup    Create A Session
Suite Teardown  Logout the current session

*** Keywords ***
Get Current User Membership
	${response}  Get On Session    ${mysession}  /web/user/membership	headers=${header}
	Status Should Be 	200		${response}

Get Recently Searched Keywords
	${response}  Get On Session    ${mysession}  /web/user/keywords	 headers=${header}
	Status Should Be 	200		${response}

Get All Account Transactions
	${params}  Create Dictionary  page=1  per_page=15
	${response}  Get On Session    ${mysession}  /web/user/transactions  params=${params}	 headers=${header}
	Status Should Be 	200		${response}

Change Password
  ${body}  Create Dictionary  csrf_token=qwwdgbefhrtnrmnrymn  password=87654321
	${response}=  Post On Session  ${mysession}  /web/user/change_password    headers=${header}    json=${body}
	Status Should Be	200	${response}

Link Current Account to Social Account
  #provider: facebook, apple, google
  ${body}  Create Dictionary  token=${token}  provider=facebook
	${response}=  Post On Session  ${mysession}  /web/user/link    headers=${header}    json=${body}
	Status Should Be	200	${response}

Unlink Current Account to Social Account
  #provider: facebook, apple, google
  [Arguments]  ${provider}
  ${body}  Create Dictionary  provider=${provider}
	${response}=  Post On Session  ${mysession}  /web/user/unlink    headers=${header}    json=${body}
	Status Should Be	200	${response}

Subscribe Notification Channel
  #channel:sms, push_notification, email ; enabled: true, false
  [Arguments]  ${channel}
  ${body}  Create Dictionary  channel=${channel}  enabled=true
	${response}=  Post On Session  ${mysession}  /web/user/subscribe    headers=${header}    json=${body}
	Status Should Be	200	${response}

Set Birthday
  #format: DD/MM/YYYY
  [Arguments]  ${birthday}
  ${body}  Create Dictionary  birthday=${birthday}
	${response}=  Patch On Session  ${mysession}  /web/user/set_birthday    headers=${header}    json=${body}
	Status Should Be	200	${response}

Update Current User Profile
  #format: DD/MM/YYYY ; gender: 1:male, -1:female
  [Arguments]  ${first_name}  ${last_name}  ${birthday}  ${phone}  ${gender}
  ${first_name}  Generate First Name
  ${last_name}  Generate Last Name
  ${body}  Create Dictionary  csrf_token=wdgedhrthrth  first_name=${first_name}  last_name=${last_name}  birthday=${birthday}  phone=${phone}  gender=${gender}
	${response}=  Patch On Session  ${mysession}  /web/user/set_birthday    headers=${header}    json=${body}
	Status Should Be	200	${response}

Add Coin After User Sharing Box to Social
  ${body}  Create Dictionary  csrf_token=wefwefwegewrher  box_id=${box_id}
	${response}=  Patch On Session  ${mysession}  /web/user/add_coins_on_sharing_review    headers=${header}    json=${body}
	Status Should Be	200	${response}
