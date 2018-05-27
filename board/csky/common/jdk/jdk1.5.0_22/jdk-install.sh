#!/bin/sh

JDK_VERSION=jdk1.5.0_22
JDK_SITE=https://github.com/c-sky/tools/raw/master/dl
JDK_SHA256_SUM="d9bd5d516c4cb0120b921f82cf6c56f5c00567e0b8def5a2d6907d609ee4be3c"
JDK_DOWNLOAD_DIR=dl
JDK_INSTALL_DIR=output/host/jdk
JDK_OK=false

jdk_check()
{
	echo "Checking $JDK_DOWNLOAD_DIR/${JDK_VERSION}.tar.xz..."

	JDK_SHA256_SUM_NEW=$(sha256sum $JDK_DOWNLOAD_DIR/${JDK_VERSION}.tar.xz)
	JDK_SHA256_SUM_NEW=${JDK_SHA256_SUM_NEW:0:64}

	if [ "$JDK_SHA256_SUM" = "$JDK_SHA256_SUM_NEW" ]; then
		echo "sha256 checksum ok!"
		JDK_OK=true
	else
		echo "error! sha256 checksum mismatch!"
		echo "    expected: $JDK_SHA256_SUM"
		echo "    got:      $JDK_SHA256_SUM_NEW"
		JDK_OK=false
	fi
}

if [ ! -f "$JDK_INSTALL_DIR/$JDK_VERSION/bin/java" ]; then
	mkdir -p $JDK_INSTALL_DIR

	if [ -f "$JDK_DOWNLOAD_DIR/${JDK_VERSION}.tar.xz" ]; then
		jdk_check
	else
		wget -c $JDK_SITE/${JDK_VERSION}.tar.xz -P $JDK_DOWNLOAD_DIR
		jdk_check
	fi

	if [ "$JDK_OK" = "true" ]; then
		echo -n "Installing ${JDK_VERSION}..."
		tar xJf $JDK_DOWNLOAD_DIR/${JDK_VERSION}.tar.xz -C $JDK_INSTALL_DIR
		echo "OK"
	fi
fi

# JDK path
export JAVA_HOME=`pwd`/$JDK_INSTALL_DIR/$JDK_VERSION
export JRE_HOME=$JAVA_HOME/jre
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$JAVA_HOME:$PATH
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib
