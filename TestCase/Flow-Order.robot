*** Settings ***
Documentation    Verify order has been working properly using API
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
Suite Setup    Create A Session
Suite Teardown  Logout the current session

*** Test Cases ***

#TC_ORDER_01 Verify Order has been displayed correctly after checkout success with cash payment
#	[Tags]    Order
#	Login and get access token    hoa.nguyen@lixibox.com
#	Check item in Cart is Empty
#	Add 1 Items ${BOX_ID_9396} To Cart
#	Check 1 item quantity in Cart
#	Add new address to address list of User
#	Cart Checkout
#	Compare order information

TC_ORDER_02 Verify whether Cancel Order after Checkout successful
   [Tags]    Order
	Login and get access token    hoa.nguyen@lixibox.com
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_9396} To Cart
	Check 1 item quantity in Cart
	Add new address to address list of User
	Cart Checkout
	Cart Payment
    Check status of the order    ${order_code}  unpaid
    Get reason cancel list    Không có nhu cầu mua nữa
    Log   ${result}
    Verify the order is cacelled   ${order_code}   ${result}
    ${response}    Remove added address after done    ${address_id}
    Status Should Be	200	  ${response}
#
#TC_ORDER_03 Verify Order has been displayed correctly after checkout success with new address
#    [Tags]    Order
#	Login and get access token    hoa.nguyen@lixibox.com
#	Check item in Cart is Empty
#	Add 1 Items ${BOX_ID_9396} To Cart
#	Check 1 item quantity in Cart
#	Add new address to address list of User
#	Cart Checkout
#	Cart Payment
#
#TC_ORDER_04 Verify Order has been displayed correctly after checkout success after updating checkout information
#   [Tags]    Order
#	Login and get access token    hoa.nguyen@lixibox.com
#	Check item in Cart is Empty
#	Add 1 Items ${BOX_ID_9396} To Cart
#	Check 1 item quantity in Cart
#	Add new address to address list of User
#	Cart Checkout
#	Cart Checkout address
#	Cart Payment







