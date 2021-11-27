*** Settings ***
Documentation    Verify Shipping fee Estimation is working properly using API
... 			 Run testcase command, store report on Results folder with timestamp: "robot --timestampoutputs -d Results TestCase/"
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Library    FakerLibrary   WITH NAME  faker
Resource	../Resources/API/Authentication.robot
Resource	../Resources/API/Cart.robot
Resource	../Resources/API/Address.robot
Resource	../Resources/API/Setting.robot
Resource	../Resources/variables.robot
Suite Setup    Create A Session
Suite Teardown  Logout the current session

*** Test Cases ***
TC_SA_04 Shipping fee estimation on Box Detail with high margin and packing size is set 0
  [Tags]  Shipping fee
  Get Shipping Fee of ${BOX_ID_12132} for Urban
  Verify Shipping fee of Box detail is 13200

  Get Shipping Fee of ${BOX_ID_12132} for Suburban 1
  Verify Shipping fee of Box detail is 20000

  Get Shipping Fee of ${BOX_ID_12132} for Suburban 2
  Verify Shipping fee of Box detail is 22000

TC_SA_05 Shipping fee estimation on ComboBox with high margin and packing size is set 0
  [Tags]  Shipping fee
  Get Shipping Fee of ${BOX_ID_9396} for Urban
  Verify Shipping fee of Box detail is 13200

  Get Shipping Fee of ${BOX_ID_9396} for Suburban 1
  Verify Shipping fee of Box detail is 20000

  Get Shipping Fee of ${BOX_ID_9396} for Suburban 2
  Verify Shipping fee of Box detail is 22000

TC_SA_06 Shipping fee estimation with Item with high margin on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_9396} To Cart
	Check 1 item quantity in Cart
	Add new address to address list of User

  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is under 700k
  Verify Shipping fee is 13200

  Add 6 Items ${BOX_ID_9396} To Cart
	Check 7 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 700k - 1.5 Mil
	Verify Shipping fee is ${FREE_SHIP}

	Add 9 Items ${BOX_ID_9396} To Cart
	Check 16 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is ${FREE_SHIP}

	Add 32 Items ${BOX_ID_9396} To Cart
	Check 48 item quantity in Cart
	Cart Checkout
	Cart Checkout address
  Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is ${FREE_SHIP}

  Remove added address after done  ${address_id}
  Logout the current session

TC_SA_07 Shipping fee estimation with Item with low margin and deliver to Urban on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_12132} To Cart
	Check 1 item quantity in Cart

	Add new address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is under 700k
  Verify Shipping fee is 13200
  Add 15 Items ${BOX_ID_12132} To Cart
	Check 16 item quantity in Cart
	Cart Checkout
	Cart Checkout address
  Verify Subtotal price is between 700k - 1.5 Mil
	Verify Shipping fee is 3200

	Add 32 Items ${BOX_ID_12132} To Cart
	Check 48 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is ${FREE_SHIP}

	Add 48 Items ${BOX_ID_12132} To Cart
	Check 96 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is ${FREE_SHIP}

  Remove added address after done  ${address_id}
  Logout the current session

TC_SA_08 Shipping fee estimation with Item with low margin and deliver to Suburban 1 on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_12132} To Cart
	Check 1 item quantity in Cart

	Add new Suburban 1 address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is under 700k
  Verify Shipping fee is 20000

  Add 15 Items ${BOX_ID_12132} To Cart
	Check 16 item quantity in Cart
	Cart Checkout
	Cart Checkout address
  Verify Subtotal price is between 700k - 1.5 Mil
	Verify Shipping fee is 10000

	Add 32 Items ${BOX_ID_12132} To Cart
	Check 48 item quantity in Cart
	Cart Checkout
	Cart Checkout address
  Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is ${FREE_SHIP}

	Add 48 Items ${BOX_ID_12132} To Cart
	Check 96 item quantity in Cart
	Cart Checkout
	Cart Checkout address
  Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is ${FREE_SHIP}

  Remove added address after done  ${address_id}
  Logout the current session

TC_SA_09 Shipping fee estimation with Item with low margin and deliver to Suburban 2 on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_12132} To Cart
	Check 1 item quantity in Cart
	Add new Suburban 2 address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is under 700k
  Verify Shipping fee is 22000

  Add 15 Items ${BOX_ID_12132} To Cart
	Check 16 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 700k - 1.5 Mil
	Verify Shipping fee is 12000

	Add 32 Items ${BOX_ID_12132} To Cart
	Check 48 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is ${FREE_SHIP}

	Add 48 Items ${BOX_ID_12132} To Cart
	Check 96 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is ${FREE_SHIP}

  Remove added address after done  ${address_id}
  Logout the current session

TC_SA_10 Shipping fee estimation with valid packing size Item with high margin
  [Tags]  Shipping fee
  Get Shipping Fee of ${BOX_ID_10776} for Urban
	Verify Shipping fee of Box detail is 10000
  Get Shipping Fee of ${BOX_ID_10776} for Suburban 1
	Verify Shipping fee of Box detail is 20000
  Get Shipping Fee of ${BOX_ID_10776} for Suburban 2
	Verify Shipping fee of Box detail is 20000

TC_SA_10_1 Shipping fee estimation with valid packing size Item with high margin on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_10776} To Cart
	Check 1 item quantity in Cart

	Add new address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Shipping fee is ${FREE_SHIP}
  Remove added address after done  ${address_id}

TC_SA_10_2 Shipping fee estimation with Item with low margin and valid packing size higher than real weight
  [Tags]  Shipping fee
  Get Shipping Fee of ${BOX_ID_10780} for Urban
  Verify Shipping fee of Box detail is 17730
  Get Shipping Fee of ${BOX_ID_10780} for Suburban 1
  Verify Shipping fee of Box detail is 23730
  Get Shipping Fee of ${BOX_ID_10780} for Suburban 2
  Verify Shipping fee of Box detail is 23730

TC_SA_10_3 Shipping fee estimation with Item with low margin and valid packing size lower than real weight
  [Tags]  Shipping fee
  Get Shipping Fee of ${BOX_ID_10612} for Urban
  Verify Shipping fee of Box detail is 26000
  Get Shipping Fee of ${BOX_ID_10612} for Suburban 1
  Verify Shipping fee of Box detail is 32000
  Get Shipping Fee of ${BOX_ID_10612} for Suburban 2
  Verify Shipping fee of Box detail is 32000

TC_SA_11 Shipping fee estimation on ComboBox with high margin and packing size is set 0
  [Tags]  Shipping fee
  Get Shipping Fee of ${BOX_ID_10213} for Urban
  Verify Shipping fee of Box detail is 10000

  Get Shipping Fee of ${BOX_ID_10213} for Suburban 1
  Verify Shipping fee of Box detail is 20000

  Get Shipping Fee of ${BOX_ID_10213} for Suburban 2
  Verify Shipping fee of Box detail is 20000

TC_SA_12 Shipping fee estimation with Item with low margin and valid packing size higher than real weight and deliver to Urban on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_10780} To Cart
	Check 1 item quantity in Cart

	Add new address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is between 700k - 1.5 Mil
  Verify Shipping fee is 17730

  Add 1 Items ${BOX_ID_10780} To Cart
	Check 2 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is 24460

	Add 2 Items ${BOX_ID_10780} To Cart
	Check 4 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is 37920

#	Add 48 Items ${BOX_ID_10780} To Cart
#	Check 51 item quantity in Cart
#	Cart Checkout
#	Cart Checkout address
#	Verify Subtotal price is between 3 Mil - 1 Bil
#	Verify Shipping fee is ${FREE_SHIP}

  Remove added address after done  ${address_id}
  Logout the current session

TC_SA_13 Shipping fee estimation with Item with low margin and valid packing size higher than real weight and deliver to Suburban 1 on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_10780} To Cart
	Check 1 item quantity in Cart

	Add new Suburban 1 address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is between 700k - 1.5 Mil
  Verify Shipping fee is 23730

  Add 1 Items ${BOX_ID_10780} To Cart
	Check 2 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	And Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is 30460

	Add 2 Items ${BOX_ID_10780} To Cart
	Check 4 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is 43920

  Remove added address after done  ${address_id}
  Logout the current session

TC_SA_14 Shipping fee estimation with Item with low margin and valid packing size higher than real weight and deliver to Suburban 2 on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_10780} To Cart
	Check 1 item quantity in Cart

	Add new Suburban 2 address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is between 700k - 1.5 Mil
  Verify Shipping fee is 23730

  Add 1 Items ${BOX_ID_10780} To Cart
	Check 2 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is 30460

	Add 2 Items ${BOX_ID_10780} To Cart
	Check 4 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is 43920

  Remove added address after done  ${address_id}
  Logout the current session

Shipping fee estimation with Item with low margin and valid packing size lower than real weight and deliver to Urban
  [Tags]  Shipping fee
  Get Shipping Fee of ${BOX_ID_10612} for Urban
  Verify Shipping fee of Box detail is 26000
  Get Shipping Fee of ${BOX_ID_10612} for Suburban 1
  Verify Shipping fee of Box detail is 32000
  Get Shipping Fee of ${BOX_ID_10612} for Suburban 2
  Verify Shipping fee of Box detail is 32000

TC_SA_15 Shipping fee estimation with Item with low margin and valid packing size lower than real weight and deliver to Urban on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_10612} To Cart
	Check 1 item quantity in Cart

	Add new address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is under 700k
  Verify Shipping fee is 26000

  Add 8 Items ${BOX_ID_10612} To Cart
	Check 9 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 700k - 1.5 Mil
	Verify Shipping fee is 216000

	Add 10 Items ${BOX_ID_10612} To Cart
	Check 19 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is 446000

	Add 19 Items ${BOX_ID_10612} To Cart
	Check 38 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is 881000

  Remove added address after done  ${address_id}
  Logout the current session

TC_SA_16 Shipping fee estimation with Item with low margin and valid packing size lower than real weight and deliver to Suburban 1 on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_10612} To Cart
	Check 1 item quantity in Cart

	Add new Suburban 1 address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is under 700k
  Verify Shipping fee is 32000

  Add 8 Items ${BOX_ID_10612} To Cart
	Check 9 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 700k - 1.5 Mil
	Verify Shipping fee is 222000

	Add 10 Items ${BOX_ID_10612} To Cart
	Check 19 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is 452000

	Add 19 Items ${BOX_ID_10612} To Cart
	Check 38 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is 887000

  Remove added address after done  ${address_id}
  Logout the current session

TC_SA_17 Shipping fee estimation with Item with low margin and valid packing size lower than real weight and deliver to Suburban 2 on Checkout flow
  [Tags]  Shipping fee
  Login and get access token  ${LOGIN_EMAIL_6}
	Check item in Cart is Empty
	Add 1 Items ${BOX_ID_10612} To Cart
	Check 1 item quantity in Cart

	Add new Suburban 2 address to address list of User
  Cart Checkout
  Cart Checkout address
  Verify Subtotal price is under 700k
  Verify Shipping fee is 32000

  Add 8 Items ${BOX_ID_10612} To Cart
	Check 9 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 700k - 1.5 Mil
	Verify Shipping fee is 222000

	Add 10 Items ${BOX_ID_10612} To Cart
	Check 19 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 1.5 Mil - 3 Mil
	Verify Shipping fee is 452000

	Add 19 Items ${BOX_ID_10612} To Cart
	Check 38 item quantity in Cart
	Cart Checkout
	Cart Checkout address
	Verify Subtotal price is between 3 Mil - 1 Bil
	Verify Shipping fee is 887000

  Remove added address after done  ${address_id}
  Logout the current session