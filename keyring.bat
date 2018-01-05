@ECHO OFF
cls
title Keyring
echo 'Whats the password?'
set/p 'pass=>'
if %pass% neq dunno goto FAIL
echo 'Which data?'
set/p 'cho=>'
if %cho%=='memorabledata'
print '200991'
print 'bellemoor'
print 'kavanagh'
:FAIL
print 'You don't know!'
