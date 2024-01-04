#!/usr/bin/env python3
#
# coding=utf-8
#

import random,sys,getopt
import os
import shutil
import threading
import time
import re

def build_csmith():
    os.system('wget -c -t 3 -T 120 ftp://11.163.23.134/Test/Test/dl/csmith-2.3.0.tar.gz')
    os.system('[ -d csmith-2.3.0 ] || tar -xzf csmith-2.3.0.tar.gz')
    os.system('if [ ! -f install-csmith/bin/csmith ];then cd csmith-2.3.0 && ./configure --prefix=`pwd`/../install-csmith && make -j8 && make install ;fi')
def install_gcc(compiler_path):
    os.system('wget -c -t 3 -T 120 '  + compiler_path)
    cc_name=os.path.basename(compiler_path)
    os.system(' mkdir -p ./install_gcc && tar -xvf ' + cc_name + ' -C ./install_gcc')
    os.system('cp ./install_gcc/Xuantie-900* ./install_gcc/install_gcc -rf ')
def install_qemu(qemu_path):
    os.system('wget -c -t 3 -T 120 ' + qemu_path)
    qemu_name=os.path.basename(qemu_path)
    os.system('mkdir -p ./install_qemu && tar -xvf ' + qemu_name + ' -C ./install_qemu ' )
def random_illegal_number(work_dir):
    number = 0
    input_file=  work_dir + '/tmp.s'
    output_file= work_dir + '/tmp.exe'
    dump_file  = work_dir + '/tmp.txt'

    while True:
        number = random.randrange(0,0xffffffff,1)
        file_out=open(input_file,mode='w')
        file_out.write('.long ' + str(hex(number)) + '\n')
        file_out.close()
        command=  root_dir + '/install_gcc/install_gcc/bin/riscv64-unknown-linux-gnu-gcc -mcpu=c908v   '  + input_file  + ' -c -o ' + output_file
        result=os.system(command)
        command=  root_dir + "/install_gcc/install_gcc/bin/riscv64-unknown-linux-gnu-objdump -d " + output_file  + ' > ' + dump_file
        os.system(command)
        command="grep -e  " + str(hex(number)) + ' ' + dump_file  + ' >/dev/null'
        result=os.system(command)
        if result == 0 :
            print("OK")
            break
    return hex(number)

def parseing_assemble_file(input_assemble_file,output_assemble_file,work_dir):
    file_in=open(input_assemble_file,mode='r')
    file_out=open(output_assemble_file,mode='w')
    status=0
    curr_off=0
    inst_offset=0

    while True:
        line=file_in.readline()
        if len(line) == 0 :
            break
        if status == 0 :
            file_out.write(line)
            result=re.search('^func_.*:',line)
            if result != None :
                status = 1
                curr_off=0
                inst_offset = random.randrange(0,300,1)
        elif status == 1 :
            file_out.write(line)
            curr_off = curr_off + 1
            if curr_off >= inst_offset :
                num=random_illegal_number(work_dir)
                file_out.write('.long ' + str(num) + '\n')
                status = 3
                continue
            result=re.search('jr[ \t]+ra',line)
            if result != None :
                num=random_illegal_number(work_dir)
                file_out.write('.long ' + str(num) + '\n')
                status = 3
                continue
        elif status == 3 :
            file_out.write(line)
    file_out.close()
    file_in.close()

def register_init_for_file(input_assemble_file,output_assemble_file):
    file_in=open(input_assemble_file,mode='r')
    file_out=open(output_assemble_file,mode='w')

    while True:
        line=file_in.readline()
        if len(line) == 0 :
            break
        file_out.write(line)
        result=re.search('^main:',line)
        if result != None :
            file_out.write('li s1,0'+'\n' +'li s2,0'+'\n' + 'li s3,0'+'\n' + 'li s4,0'+'\n' )
            file_out.write('li s5,0'+'\n' +'li s6,0'+'\n' + 'li s7,0'+'\n' + 'li s8,0'+'\n' )
            file_out.write('li s9,0'+'\n' +'li s10,0'+'\n'+ 'li s11,0'+'\n')
            file_out.write('li t1,0'+'\n' +'li t2,0'+'\n' + 'li t3,0'+'\n'  + 'li t4,0'+'\n')
            file_out.write('li t5,0'+'\n' +'li t6,0'+'\n')

class myThread (threading.Thread):
    def __init__(self, threadID,num):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.num = num
    def run(self):
        # mk dir
        path=root_dir + '/run_csmith_case/' + str(self.threadID) + '_dir'
        if  os.path.exists(path) == False :
            os.makedirs(path)
        case_num = 0
        while True :
        ### produce testcase
            time_str = time.strftime("%Y%m%d-%H%M%S")
            elf_name = path + '/' +  '11.elf'
            elf_new_name = path + '/' +   "22.elf"
            assemble_file = path + '/' +  '11.s'
            tmp_file      = path + '/' +  '11_tmp.s'
            assemble_new_file = path + '/' +  '11_new.s'
            case_name =  path + '/' +  "11.c"

            command= root_dir + '/install-csmith/bin/csmith  --output  '   + case_name + '  --max-block-depth  2 --inline-function-prob 10  --max-array-dim 2  --max-funcs  61   --max-struct-fields 3   --max-expr-complexity 4 '
            result=os.system(command)
            
            compiler_cflag='  -mcpu=' + cpu_type   +  ' -I  '  +  root_dir  +  '/install-csmith/include/csmith-2.3.0  -w  -static   '
            cc= root_dir + '/install_gcc/install_gcc/bin/riscv64-unknown-linux-gnu-gcc '
            command=' timeout 30   ' + cc  + compiler_cflag  + ' ' +   case_name  + ' '  + ' -o '    +  elf_name
            result=os.system(command)
            if result !=  0 :
                case_num = case_num + 1
                print('xxx1',command)
                continue

            command=' timeout 30 ' + root_dir + '/install_qemu/bin/qemu-riscv64  -cpu any  '    +  elf_name + ' &>/dev/null'
            result=os.system(command)
            if result != 0 :
                case_num = case_num + 1
                print('xxx2',command)
                continue

            command = cc  + compiler_cflag + ' -S '  + ' '   +   case_name   + ' '  + ' -o '  + assemble_file
            result=os.system(command)
            #modify 11.s ,add .long 0x2222 statment#############
            parseing_assemble_file(assemble_file,tmp_file,path)
            register_init_for_file(tmp_file,assemble_new_file)
            ####################################################
            command = ' timeout 30   ' + cc  + compiler_cflag  + '  ' + assemble_new_file   + ' -o ' +  elf_new_name
            result = os.system(command)
            if result !=  0 :
                case_num = case_num + 1
                print('xxx3',command)
                continue


            command=' timeout 30 ' + root_dir + '/install_qemu/bin/qemu-riscv64   -cpu any ' + elf_new_name
            result=os.system(command)
            #qemu give Illegal instruction or crash
            #note -------  The return value of the result variable depends on the operating system ------------------------
            if result == 33792   :
                command='cp ' + case_name +  ' ./testcase/' + time_str + '_' + str(self.threadID)  +  '.c'
                os.system(command)
                command='cp ' + assemble_new_file  +  ' ./testcase/' + time_str +  '_' + str(self.threadID)  +  '.s'
                os.system(command)
                command='cp ' + elf_new_name  +  ' ./testcase/' + time_str +  '_' + str(self.threadID) + '_fail' +  '.elf'
                os.system(command)
                print('threand qemu return value:',result)
            elif result == 0 :
                print('xxx4',command)
                continue

            case_num = case_num + 1
            if case_num > self.num :
                break



def build_testcase(loop):
    threads = []
    testcase_num = 0
    all_num = int(loop/400)
    if  os.path.exists('testcase') == False :
        os.makedirs('testcase')

    while True:
        threads=[]
        thread_case_num = 20
        for i in range(20):
            thread = myThread(i,thread_case_num)
            thread.start()
            threads.append(thread)
        for t in threads:
            t.join()
        testcase_num   = testcase_num  + 1
        print('xxxxxxxxxxxxxxxx',testcase_num)
        os.system('rm core.*')
        if testcase_num  > all_num :
            break

def usage():
    print ("Usage:")
    print ("python "+ sys.argv[0] + " [ -l loop ] [ -s csmith_args ] [ -h ]")
    print (" -h           help version")
    print (" -l          genarate case num,such as: 10")
    print (" -c         set compiler path ")
    print (" -q         set qemu path ")
    print (" -t         set cpu type ")
    print (" Example:    python3 "+sys.argv[0]+" -l 30 -c ftp://eu95t-iotsoftwareftp01.eng.t-head.cn/Test/Test/Toolschain/gnu-riscv/V2.6.1/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1.tar.gz \
                     -q ftp://eu95t-iotsoftwareftp01.eng.t-head.cn/Test/Test/qemu/V4.0.0/xuantie-qemu-x86_64-Ubuntu-18.04.tar.gz  -t c908v ")

if __name__ == "__main__":
    root_dir=os.getcwd()
    try:
        opts,args = getopt.getopt(sys.argv[1:],"hl:c:q:t:")
        if len(opts) == 0:
            raise Exception('')
    except:
        usage()
        sys.exit(2)
    for opt,arg in opts:
        if opt == '-h':
            usage()
            sys.exit()
        elif opt in ("-l"):
            loop = arg
        elif opt in ("-c"):
            compiler_site = arg
        elif opt in ("-q"):
            qemu_site= arg 
        elif opt in ("-t"):
            cpu_type = arg 
    install_gcc(compiler_site)
    install_qemu(qemu_site)
    build_csmith()
    build_testcase(int(loop))
