#!/bin/bash

#tar 
cd /ci/go/
bunzip2 go-linux-riscv64-bootstrap.tbz
tar -xf go-linux-riscv64-bootstrap.tar
gunzip go1.16.5.src.tar.gz
tar -xf go1.16.5.src.tar

# build by bootstrap
cd go/src/
export CGO_ENABLED=0
GOROOT_BOOTSTRAP=/ci/go/go-linux-riscv64-bootstrap ./make.bash

# test by go src
mkdir -p gocode
export GOOS=linux
export GOROOT=/ci/go/go
export GOPATH=/ci/go/gocode
export PATH=$PATH:$GOROOT/bin
go version
go env -w GOPROXY=none
go tool dist test
