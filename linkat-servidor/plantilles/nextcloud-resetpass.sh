#!/usr/bin/expect -f

spawn nextcloud.occ user:resetpassword lnadmin
expect "Enter a new password:"
send -- "__PASSLNADMIN__\r"

expect "Confirm the new password:"
send -- "__PASSLNADMIN__\r"

expect eof
