#!/bin/sh
insmod slcommon.ko log_levels=1
insmod slksysctl.ko
insmod slmemorydev.ko
#insmod sldma.ko
#insmod slmpu.ko
#insmod slvpu.ko
insmod slvpp.ko
#insmod slfdip.ko
#insmod slviu.ko
#insmod sljpu.ko
#insmod slvtkdsp.ko
#insmod slvpre2venc.ko
insmod silan_usb_host.ko
#insmod slgraphic.ko
#insmod slnulldev.ko

