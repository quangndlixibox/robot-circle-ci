*** Setting ***
Library 	RequestsLibrary
Library    String
Library    JSONLibrary
Resource 	../variables.robot
Resource	../common_keyword.robot

*** Keywords ***
#Get order page
#    [Arguments]     ${page}    ${per_page}
#    ${body}    Create Dictionary    page=${page}    per_page=${per_page}
#	${response}=  Get On Session  ${mysession}  /web/user/orders    ${body}
#	Status Should Be	200	${response}
#
#Get current profile
#   ${response}=  Get On Session  ${mysession}  /web/user/profile    headers=${header}
#	Status Should Be	200	${response}

Change old password to new password
   [Arguments]     ${new_password}
   ${body}    Create Dictionary     csrf_token=wffadf    password=${new_password}
   ${response}=  Post On Session      ${mysession}      /web/user/change_password     expected_status=any    headers=${header}    json=${body}
   [Return]   ${response}

Empty new password field
   ${body}    Create Dictionary     csrf_token=wffadf    password=${EMPTY}
   ${response}=  Post On Session      ${mysession}      /web/user/change_password     expected_status=any    headers=${header}    json=${body}
   [Return]   ${response}

Edit profile information
   [Arguments]     ${first_name}    ${last_name}    ${birthday}   ${phone_number}   ${gender}
   ${body}    Create Dictionary     csrf_token=wffadf    first_name=${first_name}    last_name=${last_name}    birthday=${birthday}    phone=${phone_number}    gender=${gender}
   ${response}=  Patch On Session      ${mysession}      /web/user/profile     expected_status=any    headers=${header}    json=${body}
   [Return]   ${response}

Change avatar
   [Arguments]    ${avatar_encode}
   ${body}    Create Dictionary    csrf_token=wffadf     avatar=${avatar_encode}
   ${response}=    Post On Session    ${mysession}    /web/user/change_avatar    expected_status=any    headers=${header}    json=${body}
   [Return]    ${response}











