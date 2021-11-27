*** Settings ***
Documentation    Verify Discount Code has been working properly using API
... 			 Run testcase command, store report on Results folder with timestamp: "robot -T -d Results TestCase/"
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Library    FakerLibrary   WITH NAME  faker
Resource	../Resources/common_keyword.robot
Resource	../Resources/API/Authentication.robot
Resource	../Resources/API/Cart.robot
Resource	../Resources/API/Address.robot
Resource	../Resources/variables.robot
#Library	 	../lib/cusLib.py
Suite Setup    Create A Session
Suite Teardown  Logout the current session

*** Test Cases ***
Verify Discount code has been working properly with Member Account
  [Tags]  Discount Code
  ${response}  Login with valid credential  ${LOGIN_EMAIL_5}  ${PASS_LOGIN}
	Verify User Login success  ${response.json()['user']['id']}
	Get Access Token after Login success  ${response}
	Check item in Cart is Empty
	Add Items To Cart  ${DISCOUNTCODE_BOX_ID}  ${QUANTITY}
	Check item quantity in Cart  ${QUANTITY}
  Add new address to address list of User
  ${json_msg}= 	load json from file 	./Resources/reg_error_msg.json
#                                           Discount Code                                                   Status code   Error Message
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_gold']['code']}        422           ${json_msg[1]['discount_code']['code_for_gold']['error_msg']}
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_silver']['code']}      422           ${json_msg[1]['discount_code']['code_for_silver']['error_msg']}
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_diamond']['code']}     422           ${json_msg[1]['discount_code']['code_for_diamond']['error_msg']}
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_expired']['code']}     422           ${json_msg[1]['discount_code']['code_for_expired']['error_msg']}
  Cart Checkout
  Cart Checkout address
  Cart Payment

Verify Discount code has been working properly with Silver Account
  [Tags]    Discount Code
  ${body}  Create Dictionary  email=${LOGIN_EMAIL_SILVER_2}  password=${PASS_LOGIN}
	${response}=  Post On Session  ${mysession}  /web/sessions    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Verify User Login success  ${response.json()['user']['id']}
	Get Access Token after Login success  ${response}
	Check item in Cart is Empty
	Add Items To Cart  ${DISCOUNTCODE_BOX_ID}  ${QUANTITY}
	Check item quantity in Cart  ${QUANTITY}
  Add new address to address list of User
  ${json_msg}= 	load json from file 	./Resources/reg_error_msg.json
#                                           Discount Code                                                   Status code   Error Message
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_gold']['code']}        422           ${json_msg[1]['discount_code']['code_for_gold']['error_msg']}
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_diamond']['code']}     422           ${json_msg[1]['discount_code']['code_for_diamond']['error_msg']}
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_expired']['code']}     422           ${json_msg[1]['discount_code']['code_for_expired']['error_msg']}

  Cart Checkout
  Cart Checkout address
  Cart Payment

Verify Discount code has been working properly with Gold Account
  [Tags]    Discount Code
  ${body}  Create Dictionary  email=${LOGIN_EMAIL_GOLD_2}  password=${PASS_LOGIN}
	${response}=  Post On Session  ${mysession}  /web/sessions    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Verify User Login success  ${response.json()['user']['id']}
	Get Access Token after Login success  ${response}
	Check item in Cart is Empty
	Add Items To Cart  ${DISCOUNTCODE_BOX_ID}  ${QUANTITY}
	Check item quantity in Cart  ${QUANTITY}
  Add new address to address list of User
  ${json_msg}= 	load json from file 	./Resources/reg_error_msg.json
#                                           Discount Code                                                   Status code   Error Message
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_silver']['code']}      422           ${json_msg[1]['discount_code']['code_for_silver']['error_msg']}
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_diamond']['code']}     422           ${json_msg[1]['discount_code']['code_for_diamond']['error_msg']}
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_expired']['code']}     422           ${json_msg[1]['discount_code']['code_for_expired']['error_msg']}

  Cart Checkout
  Cart Checkout address
  Cart Payment

Verify Discount code has been working properly with Diamond Account
  [Tags]    Discount Code
  ${body}  Create Dictionary  email=${LOGIN_EMAIL_DIAMOND_2}  password=${PASS_LOGIN}
	${response}=  Post On Session  ${mysession}  /web/sessions    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Verify User Login success  ${response.json()['user']['id']}
	Get Access Token after Login success  ${response}
	Check item in Cart is Empty
	Add Items To Cart  ${DISCOUNTCODE_BOX_ID}  ${QUANTITY}
	Check item quantity in Cart  ${QUANTITY}
  Add new address to address list of User
  ${json_msg}= 	load json from file 	./Resources/reg_error_msg.json
#                                           Discount Code                                                   Status code   Error Message
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_silver']['code']}      422           ${json_msg[1]['discount_code']['code_for_silver']['error_msg']}
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_gold']['code']}        422           ${json_msg[1]['discount_code']['code_for_gold']['error_msg']}
  Apply Invalid Discount code and verify    ${json_msg[1]['discount_code']['code_for_expired']['code']}     422           ${json_msg[1]['discount_code']['code_for_expired']['error_msg']}

  Cart Checkout
  Cart Checkout address
  Cart Payment