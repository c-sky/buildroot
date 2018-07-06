#!/bin/bash
TOPDIR=`pwd`
FS_OVERLAY_DIR="$TOPDIR/board/csky-qa/fs-overlay"
TARGET_DIR=$TOPDIR/output/target/lib
cd $TARGET_DIR
for i in `ls -l |awk '/^d/ {print $NF}'`
do
	if [ "$i" = "big" ] || [ "$i" = "hard-fp" ] || [ "$i" = "stm" ] || [[ "$i" =~ "ck" ]];then
		echo "Delete $i ..."
		rm -rf $i
	fi
done
#******************
# copy id_rsa.pub 
#
mkdir -p $FS_OVERLAY_DIR/root/.ssh
cat /home/$USER/.ssh/id_rsa.pub > $FS_OVERLAY_DIR/root/.ssh/authorized_keys
mkdir -p $FS_OVERLAY_DIR/home/$USER/.ssh
cat /home/$USER/.ssh/id_rsa.pub > $FS_OVERLAY_DIR/home/$USER/.ssh/authorized_keys

#*******************
# creat S70sshd
#
uid=`id -u`
gid=`id -g`
user="$USER"
group=`id|awk '{print $2}'|awk -F '(' '{print $2}'|awk -F ')' '{print $1}'`

echo "$user $uid $group $gid"
[ ! -d $FS_OVERLAY_DIR/etc/init.d/ ] && mkdir -p $FS_OVERLAY_DIR/etc/init.d/
echo "#!/bin/sh
echo \"start sshd ......\"
chown root:root -R /var/empty/
chown root:root -R /root/
chmod 755 -R /root
chown root:root /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chmod 755 /var/empty/

addgroup -g $gid $group
id $user > /dev/null
[ \$? != 0 ] && adduser -D -u $uid -G $group $user
#addgroup $user $group
chown $user:$group -R /home/$user/
#chown $user:$user /home/$user/.ssh/authorized_keys
chmod 600 /home/$user/.ssh/authorized_keys
echo \"sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin\" >>/etc/passwd
chmod 600 /usr/local/etc/*
chmod 600 etc/ssh/ssh_host_*
/usr/sbin/sshd
echo \"Finishd sshd !\"
" > $FS_OVERLAY_DIR/etc/init.d/S50sshd
chmod +x $FS_OVERLAY_DIR/etc/init.d/S50sshd
