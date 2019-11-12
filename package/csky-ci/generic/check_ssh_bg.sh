rm ~/.ssh/known_hosts -f
sleep 30
echo ================== ssh test start ================== > ssh.log
ssh -o StrictHostKeyChecking=no $1 -p 5022 ls / >> ssh.log
ssh -o StrictHostKeyChecking=no $1 -p 5022 echo "ssh check pass!" >> ssh.log
echo ================== ssh test end ================== >> ssh.log
