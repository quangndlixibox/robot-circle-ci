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
Resource	../Resources/API/Address.robot

*** Test Cases ***
TC_019 Check item in Cart is empty
    [Tags]    Add to cart
    ${EMPTY_CART} 	Collections.convert to list 	${EMPTY}
	${response}=  Get On Session  ${mysession}  /web/cart    headers=${header}
	Status Should Be	200	${response}
	Should Be Equal 	${response.json()['cart']['cart_items']} 	${EMPTY_CART}

Add Items To Cart
    [Tags]    Add to cart
    ${body}  Create Dictionary  csrf_token=wffgjadfbadfbadf     box_id=${BOX_ID}	quantity=${QUANTITY}
	${response}=  Post On Session  ${mysession}  /web/cart/add_item    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Log 	CART ID: ${response.json()['cart']['id']}
	Log 	CART QTY: ${response.json()['cart']['cart_items'][0]['quantity']}

Check item in Cart after add
    [Tags]    Add to cart
    ${QUANTITY} 	Convert To Integer 	${QUANTITY}
	${response}=  Get On Session  ${mysession}  /web/cart    headers=${header}
	Status Should Be	200	${response}
	Log 	CART QTY: ${response.json()['cart']['cart_items'][0]['quantity']}
	Set Suite Variable 	${QUANTITY_AFTER_ADD} 	${response.json()['cart']['cart_items'][0]['quantity']}
	Should Be Equal 	${QUANTITY_AFTER_ADD} 	${QUANTITY}
	${price}  Convert to Integer  ${response.json()['cart']['cart_items'][0]['box']['price']}
	Set Suite Variable 	${price}  ${price}
	${subtotal_price}  Convert to Integer  ${response.json()['cart']['subtotal_price']}
	${price_in_cart}  Evaluate  ${price}*${QUANTITY}
	Should Be Equal 	${subtotal_price}  ${price_in_cart}

Remove Items From Cart
  [Tags]    Add to cart
  ${body}  Create Dictionary  csrf_token=wffgjadfbadfbadf     box_id=${BOX_ID}	quantity=1
	${response}=  Post On Session  ${mysession}  /web/cart/remove_item    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Log 	ITEM QTY: ${response.json()['cart']['cart_items'][0]['quantity']}
	Should Be Equal as Numbers 	${QUANTITY_AFTER_ADD-1} 	${response.json()['cart']['cart_items'][0]['quantity']}
	${qty_after_remove}  convert to integer  ${response.json()['cart']['cart_items'][0]['quantity']}
	${total_price_after_remove}  evaluate  ${qty_after_remove}*${price}
	Should Be Equal as Numbers   ${response.json()['cart']['subtotal_price']}	${total_price_after_remove}

#Check the address list of current User
#    [Tags]    Address
#	${response}=  Get On Session  ${mysession}  /web/addresses    headers=${header}
#	Status Should Be	200	${response}
#	Log 	CART ID: ${response.json()['addresses']}
#	${EMPTY_ADD} 	Collections.convert to list 	${EMPTY}
#	Should Be Equal 	${response.json()['addresses']} 	${EMPTY_ADD}

#Check the address list of current User after add new Address
#    [Tags]    Address
#	${response}=  Get On Session  ${mysession}  /web/addresses    headers=${header}
#	Status Should Be	200	${response}
#	Log 	CART ID: ${response.json()['addresses']}
#	${EMPTY_ADD} 	Convert To List 	${EMPTY}
#	Should Not Be Equal 	${response.json()['addresses']} 	${EMPTY_ADD}

Cart Checkout
	[Tags]    Cart
    ${cart_info}  Create Dictionary  first_name=first_name 	last_name=last_name 	phone=0987654321  address=12/3/45  province_id=79 	district_id=776 	ward_id=9303  shipping_package=standard
    ${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		save_new_address=false  cart=${cart_info}
	${response}=  Post On Session  ${mysession}  /web/cart/checkout    headers=${header}    json=${body}
	Status Should Be	200	${response}

Cart Checkout address
	[Tags]    Cart
	${first_name}	Generate First Name
	${last_name}	Generate Last Name
	${cart_info}  Create Dictionary  first_name=${first_name} 	last_name=${last_name} 	phone=0987654321
  ${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		cart=${cart_info}
	${response}=  Post On Session  ${mysession}  /web/cart/checkout_address    headers=${header}    json=${body}
	Log  ${response.content}
	Log To Console  ${response.content}
	Status Should Be	200	${response}

Login with valid credential
  [Tags]    Login
  ${body}  Create Dictionary  email=${LOGIN_EMAIL_2}  password=12345678
	${response}=  Post On Session  ${mysession}  /web/sessions    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Get Access Token after Login success  ${response}

Add new address to address list of User
  [Tags]    Address
  ${first_name}	Generate First Name
	${last_name}	Generate Last Name
	${phone_no} 	Generate Phone Number
  ${body}  Create Dictionary  csrf_token=dfebfgnfggerg 	first_name=${first_name} 	last_name=${last_name} 	phone=0987654321 	address=12345 	province_id=79 	district_id=776 	ward_id=9303
	${response}=  Post On Session  ${mysession}  /web/addresses    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Set Global Variable 	${address_id}    ${response.json()['address']['id']}

Cart Payment
	[Tags]    Cart
	${first_name}	Generate First Name
	${last_name}	Generate Last Name
  ${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		payment_method=5
	${response}=  Post On Session  ${mysession}  /web/cart/payment    headers=${header}    json=${body}
	Status Should Be	200	 ${response}
	Remove added address after done  ${address_id}
	Cancel COD order after success  ${response.json()['order']['number']}