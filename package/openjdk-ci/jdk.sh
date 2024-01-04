#!/bin/bash 
        
if [ -f "/root/jdk.tar" ] ; then 
	cd /root  
	tar xvf jdk.tar
	rm jdk.tar
	cd -
	export JAVA_HOME=/root/jdk
	export CLASSPATH=.:${JAVA_HOME}/lib 
	export PATH=$JAVA_HOME/bin:$PATH
fi 
