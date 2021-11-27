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
Get Categories of A Box
  [Arguments]  ${BOX_ID}
	${response}  Get On Session    ${mysession}  /web/boxes/${BOX_ID}/categories    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Get All Store Box
  [Arguments]  ${BOX_ID}
	${response}  Get On Session    ${mysession}  /web/boxes/${BOX_ID}/store_boxes    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Get Boxes of Individual_Box
  [Arguments]  ${BOX_ID}
	${response}  Get On Session    ${mysession}  /web/boxes/${BOX_ID}/saving_sets    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Get Related Boxes
  [Arguments]  ${BOX_ID}
	${response}  Get On Session    ${mysession}  /web/boxes/${BOX_ID}/related_boxes    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Get Related Magazines
  [Arguments]  ${BOX_ID}
	${response}  Get On Session    ${mysession}  /web/boxes/${BOX_ID}/magazines    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Get Box Discussions
  [Arguments]  ${BOX_ID}
	${response}  Get On Session    ${mysession}  /web/boxes/${BOX_ID}/discussions    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Get Feedback Pictures
  [Arguments]  ${BOX_ID}
	${response}  Get On Session    ${mysession}  /web/boxes/${BOX_ID}/feedback_pictures    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Add coins to user's balance for sharing box on social network (Facebook)
  [Arguments]  ${BOX_ID}
  ${body}  Create Dictionary  csrf_token=awgadsfgdhtrtherh  id=${BOX_ID}
	${response}  Patch On Session    ${mysession}  /web/boxes/${BOX_ID}/shares    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Get Feedback
  [Arguments]  ${BOX_ID}
	${response}  Get On Session    ${mysession}  /web/boxes/${BOX_ID}/feedback    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Remove a Box Out of Waitlist
  [Arguments]  ${BOX_ID}
  ${body}  Create Dictionary  csrf_token=awgadsfgdhtrtherh  id=${BOX_ID}
	${response}  Delete On Session    ${mysession}  /web/boxes/${BOX_ID}/waitlist    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Add a Box into Waitlist
  [Arguments]  ${BOX_ID}
  ${body}  Create Dictionary  csrf_token=awgadsfgdhtrtherh  id=${BOX_ID}
	${response}  Post On Session    ${mysession}  /web/boxes/${BOX_ID}/waitlist    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Un-like a Box
  [Arguments]  ${BOX_ID}
  ${body}  Create Dictionary  csrf_token=awgadsfgdhtrtherh  id=${BOX_ID}
	${response}  Delete On Session    ${mysession}  /web/boxes/${BOX_ID}/unlike    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Like a box
  [Arguments]  ${BOX_ID}
  ${body}  Create Dictionary  csrf_token=awgadsfgdhtrtherh  id=${BOX_ID}
	${response}  Delete On Session    ${mysession}  /web/boxes/${BOX_ID}/like    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Get a Box detail
  [Arguments]  ${BOX_ID}
  ${body}  Create Dictionary  csrf_token=awgadsfgdhtrtherh  id=${BOX_ID}
	${response}  Delete On Session    ${mysession}  /web/boxes/${BOX_ID}    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

Get a Redeem Box
	${response}  Delete On Session    ${mysession}  /web/boxes/redeem    headers=${header}
	Status Should Be 	200		${response}
	[Return]  ${response}

