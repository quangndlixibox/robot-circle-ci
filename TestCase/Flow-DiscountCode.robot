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
	Login and get access token  ${LOGIN_EMAIL}
	Check item in Cart is Empty
	Add new address to address list of User
	Add Items To Cart  ${DISCOUNTCODE_BOX_ID}  ${QUANTITY}
	Check item quantity in Cart  ${QUANTITY}
	Apply discount code  ${MINIBALM}
  Remove discount code  ${MINIBALM}
  Verify Discount code has been remove  ${MINIBALM}
  Apply discount code  ${MINIBALM}
  Update Items quantity to not qualify the discount code condition
  Verify Discount code has been remove  ${MINIBALM}
  Add Items To Cart  ${DISCOUNTCODE_BOX_ID}  4
  Apply discount code on Suggest Discount List  ${MINIBALM}
  Cart Checkout
  Cart Checkout address
  Cart Payment

Verify Discount code has been working properly with Silver Account
  [Tags]    Discount Code
	Login and get access token  ${LOGIN_EMAIL_SILVER}
	Add new address to address list of User
	Check item in Cart is Empty
	Add Items To Cart  ${DISCOUNTCODE_BOX_ID}  ${QUANTITY}
	Check item quantity in Cart  ${QUANTITY}
  Apply discount code on Suggest Discount List  ${MINIBALM}
  Cart Checkout
  Cart Checkout address
  Cart Payment

Verify Discount code has been working properly with Gold Account
  [Tags]    Discount Code
	Login and get access token  ${LOGIN_EMAIL_GOLD}
	Add new address to address list of User
	Check item in Cart is Empty
	Add Items To Cart  ${DISCOUNTCODE_BOX_ID}  ${QUANTITY}
	Check item quantity in Cart  ${QUANTITY}
  Apply discount code on Suggest Discount List  ${MINIBALM}
  Cart Checkout
  Cart Checkout address
  Cart Payment

Verify Discount code has been working properly with Diamond Account
  [Tags]    Discount Code
	Login and get access token  ${LOGIN_EMAIL_DIAMOND}
  Add new address to address list of User
	Check item in Cart is Empty
	Add Items To Cart  ${DISCOUNTCODE_BOX_ID}  ${QUANTITY}
	Check item quantity in Cart  ${QUANTITY}
  Apply discount code on Suggest Discount List  ${MINIBALM}
  Cart Checkout
  Cart Checkout address
  Cart Payment

