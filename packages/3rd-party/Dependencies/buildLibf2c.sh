#!/bin/sh

############################################################

# This UNIX script builds the f2c FORTRAN --> C translator #

# under Mac OS X.                                          #

# Make this script executable with "chmod +x buildf2c"     #

############################################################

echo "==================================="

echo "Build f2c FORTRAN --> C translator."

echo "==================================="

echo "USAGE:  ./buildf2c"



######################################

# Set trap to allow abort on signal: #

######################################

trap 'echo "Interrupted by signal" >&2; exit' 1 2 3 15



########################################################

# 1. Download f2c source from Bell Labs.               #

# (Tar file is not visible - it's created on the fly.) #

########################################################

echo "--------------------------------------------"

echo "1. Downloading f2c source from Bell Labs ..."

echo "--------------------------------------------"

# wget --passive-ftp ftp://netlib.bell-labs.com/netlib/f2c.tar

curl http://netlib.sandia.gov/cgi-bin/netlib/netlibfiles.tar?filename=netlib/f2c -o "f2c.tar"

echo "... done."



#####################################

# 2. Uncompress f2c tarred archive: #

#####################################

echo "-------------------------------"

echo "2. Uncompressing f2c source ..."

echo "-------------------------------"

tar -xvf f2c.tar

gunzip -rf f2c/*

cd f2c

unzip libf2c.zip -d libf2c

cd ..

echo "... done."



###############################################################

# 3. Prepare the unix makefiles for building the f2c library. #

#    Note: CC compiler switched from 'cc' to '/usr/bin/cc'   #

###############################################################

echo "-------------------------------------------"

echo "3. Preparing makefiles for building f2c ..."

echo "-------------------------------------------"

sed 's/CC = cc/CC = \/usr\/bin\/cc/' f2c/libf2c/makefile.u > f2c/libf2c/makefile

sed 's/CC = cc/CC = \/usr\/bin\/cc/' f2c/src/makefile.u > f2c/src/makefile

echo "... done."



##########################################

# 4. Create and install f2c header file. #

# If you use a C++ compiler:  make hadd  #

# Otherwise:                  make f2c.h #

##########################################

echo "----------------------------------------------------"

echo "4. Creating and installing f2c header file f2c.h ..."

echo "----------------------------------------------------"

cd f2c/libf2c

make f2c.h

if test ! -d /usr/local/include; then

    mkdir -p /usr/local/include

fi

cp f2c.h /usr/local/include/

echo "... done."



################################################

# 5. Create and install f2c library "libf2c.a" #

################################################

echo "-----------------------------------------------------"

echo "5. Creating and installing f2c library "libf2c.a" ..."

echo "-----------------------------------------------------"

make

if test ! -d /usr/local/lib; then

    mkdir -p /usr/local/lib

fi

cp libf2c.a /usr/local/lib/

ranlib /usr/local/lib/libf2c.a

echo "... done."



######################################

# 6. Make executable f2c translator: #

######################################

echo "---------------------------------------------"

echo "6. Creating and installing f2c translator ..."

echo "---------------------------------------------"

cd ../src

gcc -o xsum xsum.c

make veryclean

make f2c

if test ! -d /usr/local/bin; then

    mkdir -p /usr/local/bin

fi

cp f2c /usr/local/bin/

echo "... done."



################################################################

# 7. Install fc script:                                        #

#                                                              #

# 1. Remove "-Olimit 2000" in the -O processing options within #

#    the 'fc' script.                                          #

# 2. Eliminate all references to the math library (-lm) in     #

#    the script 'fc' since it is included the System framework #

#    and is linked by default under Mac OS X.                  #

# 3. Eliminate '-u MAIN__' at the bottom of the 'fc' script.   #

#    You will have to explitly load FORTRAN MAIN programs      #

#    (explicitly mention the relevant .f or .o file).          #

################################################################

echo "---------------------------"

echo "7. Installing fc script ..."

echo "---------------------------"

cd ..

mv fc fc.orig

sed 's/ -Olimit 2000//g; s/ -lm//g; s/ -u MAIN__//g' fc.orig > fc

chmod +x fc

cp fc /usr/local/bin/

echo "... done."



#########################

# 8. Install man pages: #

#########################

echo "---------------------------"

echo "8. Installing man pages ..."

echo "---------------------------"

cp f2c.1t /usr/share/man/man1/f2c.1

echo "... done."



################

# 9. Clean up: #

################

echo "------------------"

echo "9. Cleaning up ..."

echo "------------------"

cd src

make clean

cd ../libf2c

make clean

cd ../..
s
echo "... All done!"



#############################################

# 10. Test f2c on your FORTRAN source code: #

#############################################

echo "======================================================"

echo "======================================================"

echo "======================================================"

echo "   === To test f2c on your FORTRAN source code: ==="

echo "   === cd ~/wherever/your/code/is               ==="

echo "   === 1. f2c myprog.f                          ==="

echo "   ===    cc -O -o myprog.exe myprog.c -lf2c    ==="

echo "   ===    myprog.exe                            ==="

echo "   === 2. fc -O -w -o myprog.exe myprog.f       ==="

echo "   ===    myprog.exe                            ==="

echo "======================================================"

echo "======================================================"

echo "======================================================"



exit






