#!/bin/sh

#
# Step 1: Detect the operating system
#
MAC="Mac OS X"
WIN="Windows"
LIN="Linux"

if [ `uname` = "Darwin" ]; then
    OS=$MAC
elif [ `uname` = "Linux" ]; then
    OS=$LIN
else
    OS=$WIN
fi

#
# Step 2: Move to the directory containing the script
#
APP_PATH=`echo $0 | awk '{split($0,patharr,"/"); idx=1; while(patharr[idx+1] != "") { if (patharr[idx] != "/") {printf("%s/", patharr[idx]); idx++ }} }'`
APP_PATH=`cd "$APP_PATH"; pwd` 
cd "$APP_PATH"
FULL_APP_PATH=$APP_PATH
APP_PATH="."

#
# Step 3: Setup options
#
EXTRA_OPTS="-O3 -Sewn -vwn -dSWINGAME_LIB"
VERSION_NO=3.0
VERSION=3.0
CLEAN="N"
INSTALL="N"

#
# Library versions
#
OPENGL=false
SDL_13=false
STATIC=false
STATIC_NAME="sgsdk-sdl12.a"

#
# Step 4: Usage message and process command line arguments
#
Usage()
{
    echo "Usage: ./build.sh [-c] [-d] [-i] [-h] [-badass] [-godly] [-static] [version]"
    echo 
    echo "Creates and Compiles the native SGSDK library."
    echo
    echo "Options:"
    echo " -c       Perform a clean rather than a build"
    echo " -d       Compile with debug symbols"
    echo " -basass  Compile with SDL2 backend"
    echo " -godly   Compile with SDL2/OpenGL backend"
    echo " -static  Compile as a static library"
    echo " -h       Show this help message"
    echo " -i       Install after compiling"
    echo
    echo "Requires:"
    echo " - Free Pascal Compiler"
    
    if [ "$OS" = "$LIN" ]; then
        echo " - SDL dev"
        echo " - SDL-image dev"
        echo " - SDL-mixer dev"
        echo " - SDL-ttf dev"
        echo " - SDL-gfx dev"
    fi
    exit 0
}

while getopts chdib:g:s: o
do
    case "$o" in
    c)  CLEAN="Y" ;;
    b)  if [ "${OPTARG}" = "adass" ]; then
            SDL_13=true
            STATIC_NAME="sgsdk-sdl13.a"
        fi 
        ;;
    h)  Usage ;;
    g)  if [ "${OPTARG}" = "odly" ]; then
            OPENGL=true
            STATIC_NAME="sgsdk-godly.a"
        fi 
        ;;
    s)  if [ "${OPTARG}" = "tatic" ]; then
            STATIC=true
        fi 
        ;;
    d)  EXTRA_OPTS="-vwn -gw -dTRACE -dSWINGAME_LIB"
        DEBUG="Y" ;;
    i)  INSTALL="Y";;
    [?]) print >&2 "Usage: $0 [-c] [-d] [-i] [-h] [version]"
         exit -1;;
    esac
done

shift $((${OPTIND}-1))

if [ "a$1" != "a" ]; then
    VERSION=$1
fi

#
# Step 5: Set the paths to local variables
#

TMP_DIR="${APP_PATH}/tmp/sdl12"
SDK_SRC_DIR="${APP_PATH}/src"
LOG_FILE="${APP_PATH}/tmp/out.log"
FPC_BIN=`which fpc`

if [ ${SDL_13} = true ]; then
  TMP_DIR="${APP_PATH}/tmp/sdl13"
  EXTRA_OPTS="${EXTRA_OPTS} -dSWINGAME_SDL13"
  VERSION="${VERSION}badass"
fi

if [ ${OPENGL} = true ]; then
  TMP_DIR="${APP_PATH}/tmp/godly"
  EXTRA_OPTS="${EXTRA_OPTS} -dSWINGAME_OPENGL -dSWINGAME_SDL13"
  VERSION="${VERSION}godly"
fi

if [ "$OS" = "$MAC" ]; then
    OUT_DIR="${APP_PATH}/bin/mac"
    FULL_OUT_DIR="${FULL_APP_PATH}/bin/mac"
    VERSION_DIR="${OUT_DIR}/SGSDK.framework/Versions/${VERSION}"
    HEADER_DIR="${VERSION_DIR}/Headers"
    RESOURCES_DIR="${VERSION_DIR}/Resources"
    CURRENT_DIR="${OUT_DIR}/SGSDK.framework/Versions/Current"
    
    # Set lib dir
    if [ ${SDL_13} = true ]; then
      LIB_DIR="${APP_PATH}/lib/sdl13/mac"
    elif [ ${OPENGL} = true ]; then
      LIB_DIR="${APP_PATH}/lib/godly/mac"
    else
      LIB_DIR="${APP_PATH}/lib/mac"
    fi
elif [ "$OS" = "$WIN" ]; then
    OUT_DIR="${APP_PATH}/bin/Win"
    FULL_OUT_DIR="${FULL_APP_PATH}/bin/Win"
    
    if [ ${SDL_13} = true ]; then
      LIB_DIR="${APP_PATH}/lib/sdl13/win"
    elif [ ${OPENGL} = true ]; then
      LIB_DIR="${APP_PATH}/lib/sdl13/win"
    else
      LIB_DIR="${APP_PATH}/lib/win"
    fi
    
    # FPC paths require c:/
    SDK_SRC_DIR=`echo $SDK_SRC_DIR | sed 's/\/\(.\)\//\1:\//'`
    OUT_DIR=`echo $OUT_DIR | sed 's/\/\(.\)\//\1:\//'`
fi

if [ $INSTALL != "N" ]; then
    if [ "$OS" = "$MAC" ]; then
        if [ "$(id -u)" != "0" ]; then
            INSTALL_DIR=`cd ~/Library/Frameworks; pwd`
        else
            INSTALL_DIR=/Library/Frameworks
        fi
    elif [ "$OS" = "$LIN" ]; then
        if [ "$(id -u)" != "0" ]; then
            echo "Install must be run as super user. Use sudo ./build.sh -i to install."
            exit 1
        fi
        INSTALL_DIR="/usr/lib"
        HEADER_DIR="/usr/include/sgsdk"
    else #windows
        INSTALL_DIR="$SYSTEMROOT/System32"
    fi
fi

#
# Step 6: Setup log file
#

if [ -f "${LOG_FILE}" ]
then
    rm -f "${LOG_FILE}"
fi

#
# Step 7: Declare functions for compiling
#

DoDriverMessage()
{
  if [ ${SDL_13} = true ]; then
    echo "  ... Using SDL 1.3 Driver"
  elif [ ${OPENGL} = true ]; then
    echo "  ... Using OpenGL Driver"
  else
    echo "  ... Using SDL 1.2 Driver"
  fi
}

DisplayHeader()
{
    echo "--------------------------------------------------"
    echo "          Creating SwinGame Dynamic Library"
    echo "                 for $OS"
    echo "--------------------------------------------------"
    echo "  Running script from $FULL_APP_PATH"
    echo "  Saving output to $OUT_DIR"
    if [ "$OS" = "$MAC" ]; then
        echo "  Copying Frameworks from ${LIB_DIR}"
    elif [ "$OS" = "$WIN" ]; then
        echo "  Copying libraries from ${LIB_DIR}"
    fi
    echo "  Compiling with $EXTRA_OPTS"
    if [ ! $INSTALL = "N" ]; then
        echo "  Installing to $INSTALL_DIR"
        if [ "$OS" = "$LIN" ]; then
            echo "  Copying headers to $HEADER_DIR"
        fi
    fi
    echo "--------------------------------------------------"
    DoDriverMessage
}

# Clean up the temporary directory
CleanTmp()
{
    if [ -d "${TMP_DIR}" ]
    then
        rm -rf "${TMP_DIR}"
    fi 
}

PrepareTmp()
{
    CleanTmp
    mkdir -p "${TMP_DIR}"
}

#
# Compile for Mac - manually assembles and links files
# argument 1 is arch
#
doMacCompile()
{
    PrepareTmp
    
    LINK_OPTS="$2"
    
    FRAMEWORKS=`cd ${LIB_DIR};ls -d *.framework | awk -F . '{split($1,patharr,"/"); idx=1; while(patharr[idx+1] != "") { idx++ } printf("-framework %s ", patharr[idx]) }'`
    
    if [ "*$DEBUG*" = "**" ] ; then
        EXTRA_OPTS="$EXTRA_OPTS -Xs"
    fi
    
    # Compile...
    "${FPC_BIN}" -S2 -Sh ${EXTRA_OPTS} -FE"${TMP_DIR}" -FU"${TMP_DIR}" -k"$LINK_OPTS -L'${TMP_DIR}' -F'${LIB_DIR}' -current_version '${VERSION_NO}'" -k"-install_name '@rpath/SGSDK.framework/Versions/${VERSION}/SGSDK'" -k"-rpath @loader_path/../Frameworks -rpath @executable_path/../Frameworks -rpath ../Frameworks -rpath ." -k" ${FRAMEWORKS} -framework Cocoa" "${SDK_SRC_DIR}/SGSDK.pas"  >> "${LOG_FILE}"
    if [ $? != 0 ]; then echo "Error compiling SGSDK"; cat "${LOG_FILE}"; exit 1; fi
    rm -f "${LOG_FILE}"
    
    mv ${TMP_DIR}/libSGSDK.dylib ${OUT_DIR}/libSGSDK${1}.dylib
}

# 
# Create fat dylib containing ppc and i386 code
# 
doLipo()
{
    echo "  ... Creating Universal Binary"
    lipo -arch ${1} "${OUT_DIR}/libSGSDK${1}.dylib" -arch ${2} "${OUT_DIR}/libSGSDK${2}.dylib" -output "${OUT_DIR}/libSGSDK.dylib" -create
    
    rm -rf "${OUT_DIR}/libSGSDK${1}.dylib"
    rm -rf "${OUT_DIR}/libSGSDK${2}.dylib"
}

#
# Create Mac Framework
#
doCreateFramework()
{
    echo "  ... Creating Framework version ${VERSION}"
    if [ ! -d "${OUT_DIR}/SGSDK.framework" ]
    then
        mkdir "${OUT_DIR}/SGSDK.framework"
        mkdir "${OUT_DIR}/SGSDK.framework/Versions"
        ADD_SYMLINKS="Y"
    else
        rm -rf "${OUT_DIR}/SGSDK.framework/Versions/${VERSION}"
        ADD_SYMLINKS="N"
    fi
    
    mkdir "${VERSION_DIR}"
    mkdir "${HEADER_DIR}"
    mkdir "${RESOURCES_DIR}"
    
    cp "${SDK_SRC_DIR}/SGSDK.h" "${HEADER_DIR}/SGSDK.h"
    cp "${SDK_SRC_DIR}/Types.h" "${HEADER_DIR}/Types.h"
    mv "${OUT_DIR}/libSGSDK.dylib" "${VERSION_DIR}/SGSDK"
    
    echo "<?xml version='1.0' encoding='UTF-8'?>\
    <!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\
    <plist version=\"1.0\">\
    <dict>\
            <key>CFBundleName</key>\
            <string>SGSDK</string>\
            <key>CFBundleIdentifier</key>\
            <string>au.edu.swinburne.SGSDK</string>\
            <key>CFBundleVersion</key>\
            <string>${VERSION}</string>\
            <key>CFBundleDevelopmentRegion</key>\
            <string>English</string>\
            <key>CFBundleExecutable</key>\
            <string>SGSDK</string>\
            <key>CFBundleInfoDictionaryVersion</key>\
            <string>6.0</string>\
            <key>CFBundlePackageType</key>\
            <string>FMWK</string>\
            <key>CFBundleSignature</key>\
            <string>SWIN</string>\
    </dict>\
    </plist>" >> "${RESOURCES_DIR}/Info.plist"
    
    cd "${OUT_DIR}/SGSDK.framework"
    #link is relative to Current link...
    if [ -d ./Versions/Current ]
    then
        rm ./Versions/Current
    fi
    ln -f -s "./${VERSION}" "./Versions/Current"
    
    if [ $ADD_SYMLINKS = "Y" ]
    then
        ln -f -s "./Versions/Current/Resources" "./Resources"
        ln -f -s "./Versions/Current/Headers" "./Headers"
        ln -f -s "./Versions/Current/SGSDK" "./SGSDK"
    fi
}

#
# Step 8: Do each OSs create/install process...
#
if [ $CLEAN = "N" ]
then
    if [ ! -d "${OUT_DIR}" ]
    then
        mkdir -p "${OUT_DIR}"
    fi
    
    if [ "$OS" = "$MAC" ]
    then
        DisplayHeader
        
        HAS_PPC=false
        HAS_i386=false
        HAS_LEOPARD_SDK=false
        HAS_LION=false
        OS_VER=`sw_vers -productVersion | awk -F . '{print $1"."$2}'`
        
        if [ -f /usr/libexec/as/ppc/as ]; then
            HAS_PPC=true
        fi
        
        if [ -f /usr/libexec/as/i386/as ]; then
            HAS_i386=true
        fi
        
        if [ -d /Developer/SDKs/MacOSX10.5.sdk ]; then
            HAS_LEOPARD_SDK=true
        fi
        
        if [ $OS_VER = '10.5' ]; then
            HAS_LEOPARD_SDK=true
        fi
        
        if [ $OS_VER = '10.7' ]; then
            HAS_LION=true
        fi
        
        echo "  ... Compiling Library"
        
        if [[ $HAS_i386 = true && $HAS_PPC = true && $HAS_LEOPARD_SDK ]]; then
            echo "  ... Building Universal Binary"
            
            #Compile i386 version of library
            FPC_BIN=`which ppc386`
            doMacCompile "i386" "-syslibroot /Developer/SDKs/MacOSX10.5.sdk -macosx_version_min 10.5"
            
            #Compile ppc version of library
            FPC_BIN=`which ppcppc`
            doMacCompile "ppc" "-syslibroot /Developer/SDKs/MacOSX10.5.sdk -macosx_version_min 10.5"
            #"-ldylib1.10.5.o"
            
            #FPC_BIN=`which ppcx64`
            #doMacCompile "x86_64"
            
            #Combine into a fat dylib
            doLipo "i386" "ppc"
        else
            if [[ $HAS_LION ]]; then
                PAS_FLAGS="$PAS_FLAGS -k-macosx_version_min -k10.7 -k-no_pie"
            fi
            
            #Compile i386 version of library
            FPC_BIN=`which ppc386`
            doMacCompile "i386" "-syslibroot /Developer/SDKs/MacOSX10.7.sdk -macosx_version_min 10.7"
            
            mv ${OUT_DIR}/libSGSDKi386.dylib ${OUT_DIR}/libSGSDK.dylib
        fi
        
        if [ $STATIC = true ]; then
             ar -rcs ${OUT_DIR}/${STATIC_NAME} ${TMP_DIR}/*.o
        fi
        
        #Convert into a Framework
        doCreateFramework
        
        if [ ! $INSTALL = "N" ]
        then
            echo "  ... Installing SwinGame"
            if [ ! -d "${INSTALL_DIR}" ]
            then
                mkdir -p "${INSTALL_DIR}"
            fi
        
            doCopyFramework()
            {
                # $1 = framework
                # $2 = dest
                fwk_name=${1##*/} # ## = delete longest match for */... ie all but file name
            
                if [ -d "${2}/${fwk_name}" ]
                then
                    #framework exists at destn, just copy the version details
                    rm $2/${fwk_name}/Versions/Current
                    cp -p -R -f "${1}/Versions/"* "${2}/${fwk_name}/Versions"
                else
                    cp -p -R "$1" "$2"
                fi
            }
        
            doCopyFramework "${FULL_OUT_DIR}"/SGSDK.framework "${INSTALL_DIR}"
            for file in `find ${LIB_DIR} -depth 1 | grep [.]framework$`
            do
                doCopyFramework ${file} "${INSTALL_DIR}"
            done
        fi # install
    elif [ "$OS" = "$WIN" ] 
    then
        DisplayHeader
        
        PrepareTmp
        
        fpc -Mobjfpc -Sh $EXTRA_OPTS -FE"${TMP_DIR}" -FU"${TMP_DIR}" "${SDK_SRC_DIR}/SGSDK.pas" >> "${LOG_FILE}"
        if [ $? != 0 ]; then echo "Error compiling SGSDK"; cat "${LOG_FILE}"; exit 1; fi
        
        mv "${TMP_DIR}/SGSDK.dll" "${OUT_DIR}/SGSDK.dll"

        if [ ! $INSTALL = "N" ]
        then
            echo "  ... Installing SwinGame"
            
            cp -p -f "${OUT_DIR}/SGSDK.dll" ${INSTALL_DIR}
        fi
        CleanTmp 
    else #os = Linux
        DisplayHeader
        
        PrepareTmp

        echo "  ... Compiling Library"
        fpc -Mobjfpc -Sh $EXTRA_OPTS -FE"${TMP_DIR}" -FU"${TMP_DIR}" "${SDK_SRC_DIR}/SGSDK.pas" >> ${LOG_FILE}
        if [ $? != 0 ]; then echo "Error compiling SGSDK"; cat ${LOG_FILE}; exit 1; fi

        mv "${TMP_DIR}/SGSDK.dll" "${OUT_DIR}/SGSDK.dll"
        
        mv "${OUT_DIR}/libSGSDK.so" "${OUT_DIR}/libsgsdk.so"
        mv "${OUT_DIR}/libsgsdk.so" "${OUT_DIR}/libsgsdk.so.${VERSION}"
        ln -s "${OUT_DIR}/libsgsdk.so.${VERSION}" "${OUT_DIR}/libsgsdk.so"
        
        if [ ! $INSTALL = "N" ]
        then
            echo "  ... Installing SwinGame"
            cp -p -f "${OUT_DIR}/libsgsdk.so.${VERSION}" "${INSTALL_DIR}"
            ln -s -f "/usr/lib/libsgsdk.so.${VERSION}" "${INSTALL_DIR}/libsgsdk.so"

            if [ ! -d ${HEADER_DIR} ]
            then
                echo "  ... Creating header directory"
                mkdir -p ${HEADER_DIR}
            fi

            echo "  ... Copying header files"
            cp "${SDK_SRC_DIR}/SGSDK.h" "${HEADER_DIR}/sgsdk.h"
            cp "${SDK_SRC_DIR}/Types.h" "${HEADER_DIR}/Types.h"

            /sbin/ldconfig -n "${INSTALL_DIR}"
        fi
        CleanTmp
    fi
else
    echo "--------------------------------------------------"
    echo "              SwinGame Dynamic Library"
    echo "--------------------------------------------------"
    CleanTmp
    rm -rf "${OUT_DIR}"
    mkdir -p "${OUT_DIR}"
    echo    ... Cleaned

fi

rm -f ${LOG_FILE}
rm -rf ${TMP_DIR} 2>>/dev/null

echo "  Finished"
echo "--------------------------------------------------"