*** Setting ***
Library 	RequestsLibrary
Library 	ImapLibrary
Library    String
Resource 	../variables.robot
Resource	../common_keyword.robot

*** Keywords ***
Read Email
#  open mailbox   host=imap.gmail.com    user=vietdung.nh@gmail.com    password=Vd@@1234   port:993
  Open Mailbox   host=imap.gmail.com    user=vietdung.nh@gmail.com    password=taekwondo9999   port:993
  ${LASTEST}  wait for email  timeout=300
  Log  ${LASTEST}
  Log To Console  ${LASTEST}