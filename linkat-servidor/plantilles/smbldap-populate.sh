#!/usr/bin/expect -f

spawn smbldap-populate -g 10000 -u 10000 -r 10000 
expect "New password:"
send -- "__PASSROOT__\r"

expect "Retype new password:"
send -- "__PASSROOT__\r"

expect eof
