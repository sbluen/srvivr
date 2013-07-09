#!/usr/bin/env python

import sys
import os

#create folders if nonexistent
try:
    os.mkdir("/tmp")
except OSError:
    #The folder already exists.
    pass

userfile=open("/tmp/userdata.txt", "w")
profilefile=open("/tmp/profiledata.txt", "w")
friendfile=open("/tmp/frienddata.txt", "w")

#remove old files

date="2009-01-23 20:21:13"
usertext=""
profiletext=""
friendtext=""
seed_helper_path = os.path.dirname(os.path.abspath(__file__))+"/seed_helper.rb"
#-1 is for stripping out the newline at the end.
pw=os.popen('ruby '+seed_helper_path, "r").readline()[:-1]
print "pw:", pw
USERS=1000
FRIENDS_PER_USER=20
for i in range(1, USERS+1):
    usertext+=("%s\t"*5+"%s\n") % (str(i), "user"+str(i), pw,
                                            date, date, "member")
    profiletext+=("%s\t"*10+"%s\n") % (str(i), str(i), "21", "",
        "Insert description here.", date, date, "M", "user"+str(i), "0", "0")
    if i<USERS-(FRIENDS_PER_USER+10):
        for j in range(1, FRIENDS_PER_USER):
            if j==1:
                temp="0"
            else:
                temp="1"
            friendtext+=("%s\t"*7+"%s\n") % (str((i-1)*20+j), str(i), str(i+j),
                temp, date, date, str(i), str(i+j))
    userfile.write(usertext)
    profilefile.write(profiletext)
    friendfile.write(friendtext)
    usertext=""
    profiletext=""
    friendtext=""
userfile.close()
profilefile.close()
friendfile.close()
