*** Settings ***
Documentation    Login account using API
... 			 Run testcase command, store report on Results folder with timestamp: "robot -v URL:https://api.lxb-qa.cf --timestampoutputs -d Results TestCase/"
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

*** Test Cases ***
Login with valid credential
    [Tags]    Login
    ${body}  Create Dictionary  email=${LOGIN_EMAIL}  password=12345678
	${response}=  Post On Session  ${mysession}  /web/sessions    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Get Access Token after Login success  ${response}

TC_025 Search box product with keyword "Kinh"
	[Tags]	Search
	${response}  Get On Session    ${mysession}  /web/search	params=keyword=kinh    headers=${header}
	Status Should Be 	200		${response}
	${name}  get value from json  ${response.json()}  $.boxes[*].name
	${name}  convert to string  ${name}
	Log  ${name}
	should contain  ${name}  Kính
#	${lst_length}  get length  ${response.json()['boxes']}
#	log  ${lst_length}
#    @{List_name}  create list
#    FOR  ${i}  IN RANGE  ${lst_length}
#        Append To List  @{List_name}  [${i}]  ${response.json()['boxes'][${i}]['name']}
#    END
#    Log Many  @{List_name}

#Search box product with filter
#	[Tags]	Search
#	${response}  Get On Session    mysession  /web/search	params=keyword=${KEYWORD}    headers=${header}
#	Status Should Be 	200		${response}

Search with suggestion
	[Tags]	Search
	${response}  Get On Session    mysession  /web/search/suggestion	params=keyword=kinh    headers=${header}
	Status Should Be 	200		${response}
	Log  ${response.content}

Search with top keyword
	[Tags]	Search
	${response}  Get On Session    mysession  /web/search/top_keywords	params=limit=5    headers=${header}
	Status Should Be 	200		${response}
	Log  ${response.content}

#Search box product with keyword "Kinh" and sort
#	[Tags]	Search
#	${params}  create dictionary  keyword=kính  sort=price-asc
#	${response}  Get On Session    ${mysession}  /web/search	params=${params}    headers=${header}
#	Status Should Be 	200		${response}
#	${name}  get value from json  ${response.json()}  $.boxes[*].name
#	${name}  convert to string  ${name}
#	${short_description}  get value from json  ${response.json()}  $.boxes[*].short_description
#	${short_description}  convert to string  ${short_description}
#	${name_status}=  Run Keyword And Return Status  should contain  ${name}    Kinh
#	${short_description_status}=  Run Keyword And Return Status  should contain  ${short_description}    Kinh
#	should be equal  '${name_status}' == 'true'  OR  '${short_description_status}' == 'true'
##	${str}  Catenate  ${name}  ${short_description}
##	should contain  ${str}  Kính