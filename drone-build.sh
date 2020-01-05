#!/usr/bin/env bash

mkdir /output
dnf --assumeyes install mingw64-fftw automake autoconf libtool mingw64-gcc mingw64-gcc-c++

#Deal with case sensitivity - Windows vs windows in includes
ln -s /usr/x86_64-w64-mingw32/sys-root/mingw/include/windows.h /usr/x86_64-w64-mingw32/sys-root/mingw/include/Windows.h

./bootstrap

#Once the makefile templates are created, remove links to librt which doesn't exist in Windows or MinGW
#I wonder whether this is why some utilities don't exit correctly
sed -ie s/^LRT_FLAGS.*//gi Makefile.in && sed -ie s/^LRT_FLAGS.*//gi src/Makefile.in

./configure --host=x86_64-w64-mingw32 && make -j

cp      /usr/x86_64-w64-mingw32/sys-root/mingw/bin/libgcc_s_seh-1.dll \
        /usr/x86_64-w64-mingw32/sys-root/mingw/bin/libfftw3-3.dll \
        /usr/x86_64-w64-mingw32/sys-root/mingw/bin/librtlsdr.dll \
        /usr/x86_64-w64-mingw32/sys-root/mingw/bin/libusb-1.0.dll \
        /usr/x86_64-w64-mingw32/sys-root/mingw/bin/libwinpthread-1.dll \
        /usr/x86_64-w64-mingw32/sys-root/mingw/bin/libstdc++-6.dll \
        /usr/x86_64-w64-mingw32/sys-root/mingw/bin/rtl*.exe \
        src/kal.exe /output/

tar -zcf rtl.tar.gz /output
pwd