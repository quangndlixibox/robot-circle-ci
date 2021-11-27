*** Settings ***
Documentation    Add/ Update product from wishlist using API
... 			 Run testcase command, store report on Results folder with timestamp: "robot -v URL:https://api.lxb-qa.cf -T -d Results TestCase/Flow-Wishlist.robot"
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

Check Product Before Add To Wishlist
    [Tags]	Wishlist
	${response}  Get On Session    ${mysession}  /web/user/liked_boxes 	headers=${header}  #json=${body}
	Status Should Be 	200		${response}
    should not contain match  ${response.json()['boxes']}  ${WISHLIST_BOX_ID}

TC_027 Add product to wishlist
	[Tags]	Wishlist
	${body}  Create Dictionary  csrf_token=dvsdgegerhrethrth  id=${WISHLIST_BOX_ID}
	${response}  Post On Session    ${mysession}  /web/boxes/${WISHLIST_BOX_ID}/like 	headers=${header}  json=${body}
	Status Should Be 	200		${response}

Check Product After Add To Wishlist
    [Tags]	Wishlist
	${response}  Get On Session    ${mysession}  /web/user/liked_boxes 	headers=${header}
	Status Should Be 	200		${response}
	Should not Be Equal  ${response.json()['boxes'][0]['id']}  ${WISHLIST_BOX_ID}

Remove Product From Wishlist
    [Tags]	Wishlist
	${body}  Create Dictionary  csrf_token=dvsdgegerhrethrth  id=${WISHLIST_BOX_ID}
	${response}  Delete On Session    ${mysession}  /web/boxes/${WISHLIST_BOX_ID}/unlike 	headers=${header}  json=${body}
	Status Should Be 	200		${response}
	request should be successful  ${response}

Check product on wishlist after remove Wishlist
    [Tags]	Wishlist
	${response}  Get On Session    ${mysession}  /web/user/liked_boxes 	headers=${header}
	Status Should Be 	200		${response}
	should not contain match  ${response.json()['boxes']}  ${WISHLIST_BOX_ID}