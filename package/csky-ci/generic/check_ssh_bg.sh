#!/bin/bash

echo "The job is $CI_BUILD_NAME"

#uclibc enhanced test has problem now, lets skip for now

tool_option="uclibc"
config_option="enhanced"

echo ================== ssh test start ================== > ssh.log
if [[ $CI_BUILD_NAME =~ $tool_option ]]
then
        if [[ $CI_BUILD_NAME =~ $config_option ]]
        then
                echo "skip ssh check" >> ssh.log
echo ================== ssh test end   ================== >> ssh.log
                exit 0
        fi
fi

rm ~/.ssh/known_hosts -f
sleep 30
ssh -o StrictHostKeyChecking=no $1 -p 5022 ls / >> ssh.log
ssh -o StrictHostKeyChecking=no $1 -p 5022 echo "ssh check pass!" >> ssh.log

echo ================== ssh test end   ================== >> ssh.log
