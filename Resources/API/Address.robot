*** Setting ***
Library 	RequestsLibrary
Library    String
Resource 	../variables.robot
Resource	../common_keyword.robot

*** Keywords ***
Add new address to address list of User
  ${first_name}	Generate First Name
	${last_name}	Generate Last Name
	${phone_no} 	Generate Phone Number
  ${body}  Create Dictionary  csrf_token=dfebfgnfggerg 	first_name=${first_name} 	last_name=${last_name} 	phone=${phone_no} 	address=12345 	province_id=79 	district_id=776 	ward_id=9303
	${response}=  Post On Session  ${mysession}  /web/addresses    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Set Suite Variable 	${address_id}    ${response.json()['address']['id']}


Remove added address after done
  [Arguments]   ${address_id}
   ${response}=    Delete On Session    ${mysession}    /web/addresses/${address_id}  params=csrf_token=dfebfgnfggerg
  [Return]   ${response}


Add new Suburban 1 address to address list of User
  ${first_name}	Generate First Name
	${last_name}	Generate Last Name
	${phone_no} 	Generate Phone Number
  ${body}  Create Dictionary  csrf_token=dfebfgnfggerg 	first_name=${first_name} 	last_name=${last_name} 	phone=${phone_no} 	address=12345 	province_id=79 	district_id=761 	ward_id=9097
	${response}=  Post On Session  ${mysession}  /web/addresses    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Set Suite Variable 	${address_id}    ${response.json()['address']['id']}

Add new Suburban 2 address to address list of User
  ${first_name}	Generate First Name
	${last_name}	Generate Last Name
	${phone_no} 	Generate Phone Number
  ${body}  Create Dictionary  csrf_token=dfebfgnfggerg 	first_name=${first_name} 	last_name=${last_name} 	phone=${phone_no} 	address=12345 	province_id=79 	district_id=785 	ward_id=9380
	${response}=  Post On Session  ${mysession}  /web/addresses    headers=${header}    json=${body}
	Status Should Be	200	${response}
	Set Suite Variable 	${address_id}    ${response.json()['address']['id']}