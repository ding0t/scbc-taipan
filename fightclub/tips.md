# About tips
This section provides some ideas if you get stuck.

# Account
## I am locked out of my account!
1. If your password is correct try:
    1. `su <other admin>` switch to another admin account. You should have their credentials
    1. `sudo pam_tally2 --user=<locked account sid> --reset` unlock your account
    1. `exit` return to your previous user session

# Use the man pages
* `man find` how to use find command for example

# END
