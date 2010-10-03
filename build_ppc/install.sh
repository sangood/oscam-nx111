#!/bin/sh
export OLDPATH=$PATH
export PATH=../../toolchains/powerpc-tuxbox-linux-gnu/bin:$OLDPATH     # 指定编译源码时要用的PowerPC环境下的GCC和C++编译器路径
make clean
cmake -DCMAKE_TOOLCHAIN_FILE=../toolchains/toolchain-powerpc-tuxbox.cmake -DWEBIF=1 ..    #用cmake命令对源码进行交叉编译
make
export PATH=$OLDPATH