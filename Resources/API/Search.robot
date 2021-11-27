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
Search box product
	[Arguments]	${KEYWORD}
	${response}  Get On Session    ${mysession}  /web/search	params=keyword=${KEYWORD}    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

#Search box product with filter
#	${response}  Get On Session    mysession  /web/search	params=keyword=${KEYWORD}    headers=${header}
#	Status Should Be 	200		${response}

Search with suggestion
	[Arguments]	${KEYWORD}
	${response}  Get On Session    mysession  /web/search/suggestion	params=keyword=${KEYWORD}    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Search with top keyword
	${response}  Get On Session    mysession  /web/search/top_keywords	params=limit=5    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}





