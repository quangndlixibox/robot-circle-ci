*** Setting ***
Library 	RequestsLibrary
Library    String
Resource 	../variables.robot
Resource	../common_keyword.robot

*** Keywords ***
Get Shipping Fee of ${box_id} for Urban
  ${params}  Create Dictionary  district_id=776  box_id=${box_id}
	${response}=  Get On Session  ${mysession}  web/settings/shipping_fee  params=${params}  headers=${header}
	Status Should Be	200	${response}
	Log  ${response.json()['shipping_fee']}
  Set Suite Variable  ${response}
	[Return]  ${response.json()['shipping_fee']}

Get Shipping Fee of ${box_id} for Suburban 1
  ${params}  Create Dictionary  district_id=761  box_id=${box_id}
	${response}=  Get On Session  ${mysession}  web/settings/shipping_fee  params=${params}  headers=${header}
	Status Should Be	200	${response}
  Log  ${response.json()['shipping_fee']}
  Set Suite Variable  ${response}
	[Return]  ${response.json()['shipping_fee']}

Get Shipping Fee of ${box_id} for Suburban 2
  ${params}  Create Dictionary  district_id=785  box_id=${box_id}
	${response}=  Get On Session  ${mysession}  web/settings/shipping_fee  params=${params}  headers=${header}
	Status Should Be	200	${response}
  Log  ${response.json()['shipping_fee']}
  Set Suite Variable  ${response}
	[Return]  ${response.json()['shipping_fee']}
