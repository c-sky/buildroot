ROOTDIR  = $(shell pwd)

include $(ROOTDIR)/config

CC= $(CROSS_TOOLCHAIN_PREFIX)gcc

all     : greelet
.PHONY: all

greelet :
	@mkdir -p $(ROOTDIR)/out
	@$(CC) -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -fno-strict-aliasing -Wdate-time -D_FORTIFY_SOURCE=2 -g -fstack-protector-strong -Wformat -Werror=format-security -fPIC -I$(PYTHON_INCLUDE) -I$(PYTHON_INCLUDE)/Include -c greenlet.c -o $(ROOTDIR)/out/greenlet.o
	@$(CC) -pthread -shared -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-Bsymbolic-functions -Wl,-z,relro -fno-strict-aliasing -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -Wdate-time -D_FORTIFY_SOURCE=2 -g -fstack-protector-strong -Wformat -Werror=format-security -Wl,-Bsymbolic-functions -Wl,-z,relro -Wdate-time -D_FORTIFY_SOURCE=2 -g -fstack-protector-strong -Wformat -Werror=format-security $(ROOTDIR)/out/greenlet.o -o out/greenlet.so

clean :
	@rm ./out -rf
