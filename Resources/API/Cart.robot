*** Setting ***
Library 	RequestsLibrary
Library    String
Library    JSONLibrary
Resource 	../variables.robot
Resource	../common_keyword.robot

*** Keywords ***
Check item in Cart is Empty
	${response}=  Get On Session  ${mysession}  /web/cart    headers=${header}
	Status Should Be	200	${response}
  ${quantity_get}  Get Value From Json  ${response.json()['cart']['cart_items']}  $.[0].quantity
  ${box_id_get}  Get Value From Json  ${response.json()['cart']['cart_items']}  $.[0].box.id
  Log  ${quantity_get}
  Run keyword if  ${quantity_get}  Remove item in cart  ${response.json()['cart']['cart_items'][0]['box']['id']}  ${response.json()['cart']['cart_items'][0]['quantity']}

Empty Cart
  ${EMPTY_CART} 	Collections.convert to list 	${EMPTY}
  [Return]  ${EMPTY_CART}

Add Items To Cart
  [Arguments]  ${DISCOUNTCODE_BOX_ID}  ${QUANTITY}
  ${body}  Create Dictionary  csrf_token=wffgjadfbadfbadf     box_id=${DISCOUNTCODE_BOX_ID}	quantity=${QUANTITY}
	${response}=  Post On Session  ${mysession}  /web/cart/add_item    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Log 	CART ID: ${response.json()['cart']['id']}
	Log 	CART QTY: ${response.json()['cart']['cart_items'][0]['quantity']}
  [Return]  ${response}

Add ${QUANTITY} Items ${BOX_ID} To Cart
  ${body}  Create Dictionary  csrf_token=wffgjadfbadfbadf     box_id=${BOX_ID}	quantity=${QUANTITY}
	${response}=  Post On Session  ${mysession}  /web/cart/add_item    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Log 	CART ID: ${response.json()['cart']['id']}
	Log 	CART QTY: ${response.json()['cart']['cart_items'][0]['quantity']}
  [Return]  ${response}

Check item quantity in Cart
  [Arguments]  ${QUANTITY}
  ${QUANTITY} 	Convert To Integer 	${QUANTITY}
	${response}=  Get On Session  ${mysession}  /web/cart    headers=${header}
	Status Should Be	200	${response}
	Log 	Item QTY: ${response.json()['cart']['cart_items'][0]['quantity']}
	Set Suite Variable 	${QUANTITY_AFTER_ADD} 	${response.json()['cart']['cart_items'][0]['quantity']}
	Should Be Equal 	${QUANTITY_AFTER_ADD} 	${QUANTITY}
	${price}  Convert to Integer  ${response.json()['cart']['cart_items'][0]['box']['price']}
	Set Suite Variable 	${price}  ${price}
#	${subtotal_price}  Convert to Integer  ${response.json()['cart']['subtotal_price']}
#	${price_in_cart}  Evaluate  ${price}*${QUANTITY}
#	Should Be Equal 	${subtotal_price}  ${price_in_cart}
  [Return]  ${response}

Check ${QUANTITY} item quantity in Cart
  ${QUANTITY} 	Convert To Integer 	${QUANTITY}
	${response}=  Get On Session  ${mysession}  /web/cart    headers=${header}
	Status Should Be	200	${response}
	Log 	Item QTY: ${response.json()['cart']['cart_items'][0]['quantity']}
	Set Suite Variable 	${QUANTITY_AFTER_ADD} 	${response.json()['cart']['cart_items'][0]['quantity']}
	Should Be Equal 	${QUANTITY_AFTER_ADD} 	${QUANTITY}
	${price}  Convert to Integer  ${response.json()['cart']['cart_items'][0]['box']['price']}
#	Set Suite Variable 	${price}  ${price}
#	${subtotal_price}  Convert to Integer  ${response.json()['cart']['subtotal_price']}
#	${price_in_cart}  Evaluate  ${price}*${QUANTITY}
#	Should Be Equal 	${subtotal_price}  ${price_in_cart}
  [Return]  ${response}

Apply discount code
  [Arguments]  ${discount_code}
  ${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		discount_code=${discount_code}
	${response}=  Post On Session  ${mysession}  /web/cart/add_discount_code    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Should Be Equal  ${response.json()['cart']['discount_code']}  ${discount_code}
#	${product_name}  Convert To String  ${response.json()['cart']['cart_items'][1]['box']['name']}
#	Should Contain  ${product_name}  ${gift_name}
	Should Be Equal  ${response.json()['cart']['cart_items'][1]['linked_gift_type']}  DiscountCodeGift

Remove discount code
  [Arguments]  ${discount_code}
  ${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		discount_code=${discount_code}
	${response}=  Post On Session  ${mysession}  /web/cart/remove_discount_code    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Should Not Be Equal  ${response.json()['cart']['discount_code']}  ${discount_code}

Update Items quantity to not qualify the discount code condition
  ${body}  Create Dictionary  csrf_token=wffgjadfbadfbadf     box_id=${DISCOUNTCODE_BOX_ID}  quantity=4
	${response}=  Post On Session  ${mysession}  /web/cart/remove_item    headers=${header}    json=${body}  expected_status=any
	Status Should Be  422	${response}
	Log 	ITEM QTY: ${response.json()['cart']['cart_items'][0]['quantity']}
	Should Be Equal as Numbers 	${QUANTITY_AFTER_ADD-4} 	${response.json()['cart']['cart_items'][0]['quantity']}
	${qty_after_remove}  convert to integer  ${response.json()['cart']['cart_items'][0]['quantity']}
	${total_price_after_remove}  evaluate  ${qty_after_remove}*${price}
	Should Be Equal as Numbers   ${response.json()['cart']['subtotal_price']}	${total_price_after_remove}

Remove item in cart
  [Arguments]  ${DISCOUNTCODE_BOX_ID}  ${remove_quantity}
  ${body}  Create Dictionary  csrf_token=wffgjadfbadfbadf     box_id=${DISCOUNTCODE_BOX_ID}  quantity=${remove_quantity}
	${response}=  Post On Session  ${mysession}  /web/cart/remove_item    headers=${header}    json=${body}  expected_status=any
	Status Should Be  200	${response}
#	Should Be Equal as Numbers 	${QUANTITY_AFTER_ADD-4} 	${response.json()['cart']['cart_items'][0]['quantity']}
#	${qty_after_remove}  convert to integer  ${response.json()['cart']['cart_items'][0]['quantity']}
#	${total_price_after_remove}  evaluate  ${qty_after_remove}*${price}
#	Should Be Equal as Numbers   ${response.json()['cart']['subtotal_price']}	${total_price_after_remove}

Verify Discount code has been remove
  [Arguments]  ${discount_code}
  ${response}=  Get On Session  ${mysession}  /web/cart    headers=${header}
  Status Should Be	200	${response}
  Should Not Be Equal  ${response.json()['cart']['discount_code']}  ${discount_code}

Apply discount code on Suggest Discount List
  [Arguments]  ${discount_code}
  ${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		discount_code=${discount_code}
	${response}=  Post On Session  ${mysession}  /web/cart/add_discount_code    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Should Be Equal  ${response.json()['cart']['discount_code']}  ${discount_code}
	${product_name}  Convert To String  ${response.json()['cart']['cart_items'][1]['box']['name']}
	Should Contain  ${product_name}  ${GIFT_BOX}
	Should Be Equal  ${response.json()['cart']['cart_items'][1]['linked_gift_type']}  DiscountCodeGift

Cart Checkout

	${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		save_new_address=false 		address_id=${address_id}  cart[shipping_package]=standard
	${response}=  Post On Session  ${mysession}  /web/cart/checkout    headers=${header}    json=${body}
	Status Should Be	200	${response}

Cart Checkout address

	${first_name}	Generate First Name
	${last_name}	Generate Last Name
	${cart_info}  Create Dictionary  first_name=${first_name} 	last_name=${last_name} 	phone=0987654321
  ${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		cart=${cart_info}
	${response}=  Post On Session  ${mysession}  /web/cart/checkout_address    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Set Suite Variable  ${response}  ${response}
	[Return]  ${response}

Cart Payment

	${first_name}	Generate First Name
	${last_name}	Generate Last Name
    ${body}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		payment_method=5
	${response}=  Post On Session  ${mysession}  /web/cart/payment    headers=${header}    json=${body}
	Status Should Be	200	${response}
    Set Suite Variable    ${order_code}      ${response.json()['order']['number']}
#	Cancel COD order after success  ${response.json()['order']['number']}

Verify Shipping fee is ${shipping_fee}
	Run Keyword And Continue On Failure  Should Be Equal As Integers  ${shipping_fee}  ${response.json()['cart']['shipping_price']}

Verify Shipping fee of Box detail is ${shipping_fee}
	Run Keyword And Continue On Failure  Should Be Equal As Integers  ${shipping_fee}  ${response.json()['shipping_fee']}

Verify Subtotal price is under 700k
	Should Be True  ${response.json()['cart']['subtotal_price']} < 700000
	Log  ${response.json()['cart']['subtotal_price']}

Verify Subtotal price is between 700k - 1.5 Mil
  Should Be True  700000 < ${response.json()['cart']['subtotal_price']} < 1500000
  Log  ${response.json()['cart']['subtotal_price']}

Verify Subtotal price is between 1.5 Mil - 3 Mil
  Should Be True  1500000 < ${response.json()['cart']['subtotal_price']} < 3000000
  Log  ${response.json()['cart']['subtotal_price']}

Verify Subtotal price is between 3 Mil - 1 Bil
  Should Be True  3000000 < ${response.json()['cart']['subtotal_price']} < 1000000000
  Log  ${response.json()['cart']['subtotal_price']}


Check the order unpaid exist
    [Arguments]  ${the_order_code}
	${response}=  Get On Session  ${mysession}  /web/orders/${the_order_code}   headers=${header}
	Status Should Be	200	${response}
Check status of the order
    [Arguments]  ${order_code}  ${status}
    ${body}  Create Dictionary   OrderCode=${order_code}
	${response}=  Post On Session  ${mysession}  /web/order_trackings/${order_code}    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Should Be Equal  ${response.json()['order']['status']}  ${status}

Verify the order is cacelled
   [Arguments]  ${order_code}  ${cancel_reason_id}
    ${body}  Create Dictionary   OrderCode=${order_code}    csrf_token=123hfhfhf   cancelReson=${cancel_reason_id}
    ${response}=  Patch On Session  ${mysession}  /web/orders/${order_code}    json=${body}
    Status Should Be	200	${response}
    ${result}   Convert To String  ${response.json()['success']}
    Log  ${result}
    Should Be Equal  ${result}  True

Get reason cancel list
   [Arguments]  ${reason_actual}
   ${response}=  Get On Session  ${mysession}  /web/orders/cancel_reasons    headers=${header}
    ${lenght}  Get Length   ${response.json()['cancel_reasons']}
    FOR  ${i}    IN RANGE    ${lenght}
    ${reason_expected}  convert to string   ${response.json()['cancel_reasons'][${i}]['content']}
   Run Keyword If    '${reason_actual}'== '${reason_expected}'   Set Suite Variable  ${result}      ${response.json()['cancel_reasons'][${i}]['id']}
   ...           ELSE       Set Suite Variable  ${result}   10
  END
    Log   ${result}


Run payment api
   ${body_payment}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		payment_method=5
   ${response_payment}=  Post On Session  ${mysession}  /web/cart/payment    headers=${header}    json=${body_payment}
   Status Should Be	200	${response}
   ${order_code}  Set Suite Variable   ${response_payment.json()['order']['number']}
   Log   full name: ${response_payment.json()['guest_user']['name']}
   Log   phone number: ${response_payment.json()['order']['phone']}
   Log   address:${response_payment.json()['order']['full_address']}
   Log   total money: ${response_payment.json()['order']['subtotal_price']}
   Log   payment method:${response_payment.json()['order']['payment_method']}
   Log   purchase:${response_payment.json()['order']['order_boxes'][0]['purchase_type']}

Run checkout api
#  [Arguments]  ${save_new_address}
  ${body_checkout}  Create Dictionary   csrf_token=1234		save_new_address=false
  ${response_checkout}=  Post On Session  ${mysession}  /web/cart/checkout    headers=${header}    json=${body_checkout}
  Log    ${response_checkout.json()['cart']['first_name']}
  Log   ${response_checkout.json()['cart']['last_name']}
  Log    ${response_checkout.json()['cart']['full_address']}
  Log    ${response_checkout.json()['cart']['phone']}
  Log    ${response_checkout.json()['cart']['total_price']}

Check order code exsit in order page
  [Arguments]   ${number_order}
   ${response}=  Get On Session  ${mysession}  /web/orders/{number_order}    headers=${header}
   Status Should Be	200	${response}
Compare order information
  # Run checkout api
  ${body_checkout}  Create Dictionary   csrf_token=12fsfdds34		save_new_address=false
  ${response_checkout}=  Post On Session  ${mysession}  /web/cart/checkout    headers=${header}    json=${body_checkout}
  Log    ${response_checkout.json()['cart']['first_name']}
  Log    ${response_checkout.json()['cart']['last_name']}
  Log    ${response_checkout.json()['cart']['full_address']}
  Log    ${response_checkout.json()['cart']['phone']}
  Log    ${response_checkout.json()['cart']['total_price']}
  # Run payment api
   ${body_payment}  Create Dictionary  csrf_token=fgsgsfgsjgnodfg 		payment_method=5
   ${response_payment}=  Post On Session  ${mysession}  /web/cart/payment    headers=${header}    json=${body_payment}
   ${order_code}  Set Variable   ${response_payment.json()['order']['number']}
   Log   full name: ${response_payment.json()['guest_user']['name']}
#   Log    ${response_payment.json()['cart']['first_name']}
#   Log    ${response_payment.json()['cart']['last_name']}
   Log   phone number: ${response_payment.json()['order']['phone']}
   Log   address:${response_payment.json()['order']['full_address']}
   Log   total money: ${response_payment.json()['order']['total_price']}
   Log   payment method:${response_payment.json()['order']['payment_method']}
   Log   purchase:${response_payment.json()['order']['order_boxes'][0]['purchase_type']}

  #  Compare
     # Check order code exsit in order page
     ${response_orderpage}=  Get On Session  ${mysession}  /web/orders/${order_code}    headers=${header}
     Status Should Be	200	${response_orderpage}
     # Compare fullname
#     Should Be Equal    ${response_payment.json()['cart']['first_name']}    ${response_checkout.json()['cart']['first_name']}
#     Should Be Equal     ${response_payment.json()['cart']['last_name']}    ${response_checkout.json()['cart']['last_name']}
     # Compare phone number
     Should Be Equal    ${response_payment.json()['order']['phone']}    ${response_checkout.json()['cart']['phone']}
     # Compare address
     Should Be Equal    ${response_payment.json()['order']['full_address']}    ${response_checkout.json()['cart']['full_address']}
     # Compare total money
     Should Be Equal    ${response_payment.json()['order']['total_price']}    ${response_checkout.json()['cart']['total_price']}
     # Compare payment method ['order']['payment_method']
     Should Be Equal    ${response_payment.json()['order']['payment_method']}    ${response_orderpage.json()['order']['payment_method']}
     # Compare purchase
     Should Be Equal    ${response_payment.json()['order']['status']}    ${response_orderpage.json()['order']['status']}






