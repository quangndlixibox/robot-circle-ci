*** Settings ***
Documentation    Verify order has been working properly using API
... 			 Run testcase command, store report on Results folder with timestamp: "robot -T -d Results TestCase/"
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Library    OperatingSystem
Library    FakerLibrary   WITH NAME  faker
Resource	../Resources/common_keyword.robot
Resource	../Resources/API/Authentication.robot
Resource	../Resources/API/Cart.robot
Resource	../Resources/API/Address.robot
Resource	../Resources/API/Profile.robot
Resource	../Resources/variables.robot
Suite Setup    Create A Session
Suite Teardown  Logout the current session
Library    DateTime

*** Test Cases ***

TC_PF_20 Verify that user change password successful
	[Tags]    Change password
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Change old password to new password    12345678
	Status Should Be	200	  ${response}

TC_PF_21 Verify that user can change new password same as old password
	[Tags]    Change password
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Change old password to new password    12345678
	Status Should Be	200	  ${response}
TC_PF_22 Verify that user can't change password when password < 8 character
	[Tags]    Change password
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Change old password to new password       12345
	Status Should Be	422	   ${response}
    Should Be Equal As Strings    ${response.json()['errors']['password'][0]}    quá ngắn (tối thiểu 8 ký tự)

TC_PF_23 Verify that user can't change password when empty new password field
    [Tags]    Change password
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Empty new password field
	Status Should Be	422	  ${response}
    Should Be Equal As Strings    ${response.json()['errors']['password'][0]}    không được bỏ trống.

TC_PF_24 Verify that user can edit profile successful
	[Tags]    Update profile
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Edit profile information    hoa    tran    11/03/2003   0111111111    1
    Status Should Be	200	  ${response}

TC_PF_25 Verify that user can update profile successful when empty fist name field
	[Tags]    Update profile
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Edit profile information    ${EMPTY}    tran    11/03/2003   0111111111    1
    Status Should Be	200	  ${response}

TC_PF_26 Verify that user can update profile successful when empty last name field
	[Tags]    Update profile
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Edit profile information    hoa    ${EMPTY}    11/03/2003   0111111111    1
    Status Should Be	200	  ${response}
TC_PF_27 Verify that user can't edit birthday when user is < 10 years old
	[Tags]    Update profile
	Login and get access token    ${LOGIN_EMAIL_11}
	${date} =	Get Current Date    result_format=datetime
	${year}    Evaluate    ${date.year}-10
	${day}    Evaluate   ${date.day}+1
	${response}    Edit profile information    hoa    tran    ${day}/${date.month}/${year}     0111111111    1
    Status Should Be	422	  ${response}
    Should Be Equal As Strings    ${response.json()['error']['birthday'][0]}    không nằm trong giới hạn.

TC_PF_28 Verify that user can't edit birthday when user is > 60 years old
	[Tags]    Update profile
	Login and get access token    ${LOGIN_EMAIL_11}
	${date} =	Get Current Date    result_format=datetime
	${year}    Evaluate    ${date.year}-60
	${day}    Evaluate   ${date.day}-1
	${response}    Edit profile information    hoa    tran    ${day}/${date.month}/${year}     0111111111    1
    Status Should Be	422	  ${response}
    Should Be Equal As Strings    ${response.json()['error']['birthday'][0]}    không nằm trong giới hạn.

TC_PF_29 Verify user can't change phone number when inputing > 10 numbers
	[Tags]    Update profile
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Edit profile information    hoa    tran    11/03/2003     01111111111    1
    Status Should Be	422	  ${response}
    Should Be Equal As Strings    ${response.json()['error']['phone'][0]}    phải là 10 số

TC_PF_30 Verify user can't change phone number when inputing < 10 numbers
	[Tags]    Update profile
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Edit profile information    hoa    tran    11/03/2003     011111111    1
    Status Should Be	422	  ${response}
    Should Be Equal As Strings    ${response.json()['error']['phone'][0]}    phải là 10 số

#TC_PF_31 Verify user can't change phone number when not starting with 0
TC_PF_32 Verify user can't change phone number when inputing characters
	[Tags]    Update profile
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Edit profile information    hoa    tran    11/03/2003     abccccc    1
    Status Should Be	422	  ${response}
    Should Be Equal As Strings    ${response.json()['error']['phone'][0]}    phải là 10 số

TC_PF_33 Verify user can change "Nam" to "Nữ" successful
	[Tags]    Update profile
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Edit profile information    hoa    tran    11/03/2003   0111111111    -1
    Status Should Be	200	  ${response}

#TC_PF_34 Verify user can't leave the emtpy phone number fieldx
TC_PF_35 Verify user can add new address successful
	[Tags]    Adress
	Login and get access token    ${LOGIN_EMAIL_11}
	${response}    Edit profile information    hoa    tran    11/03/2003   0111111111    -1
    Status Should Be	200	  ${response}

TC_PF_64 Upload image - Verify user can upload image < 5MB
    [Tags]    Change avatar
    Login and get access token    ${LOGIN_EMAIL_11}
    ${binary}  Get Binary File  ../Resources/avatar<5mb.jpeg
    ${avatar}=  Evaluate   base64.b64encode($binary)  modules=base64
    ${avatar_jpeg} =   Catenate    data:image/jpeg;base64,    ${avatar}
    ${response}    Change avatar    ${avatar_jpeg}

TC_PF_65 Upload image - Verify user can upload image with JPEG
    [Tags]    Change avatar
    Login and get access token    ${LOGIN_EMAIL_11}
    ${binary}  Get Binary File  ${URL_IMAGE}
    ${avatar}=  Evaluate   base64.b64encode($binary)  modules=base64
    ${avatar_jpeg} =   Catenate    data:image/jpeg;base64,    ${avatar}
    ${response}    Change avatar    ${avatar_jpeg}

