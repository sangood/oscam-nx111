project (OSCam C)

#----------------------- minimum version of cmake to use ------------

# if you want to switch to 2.6 min, please look at the escaped definitions
# later in this file (the add_definitions in 2.6 don't need to be escaped),
# and remove the CMP0005 policy.
# the CMP0003 could also be removed for cmake 2.6
cmake_minimum_required (VERSION 2.4)
if(COMMAND cmake_policy)
    cmake_policy(SET CMP0005 OLD)
    cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)

#----------------------- detect system ------------------------------

if (CMAKE_CROSSCOMPILING)
    if (OSCAM_SYSTEM_NAME MATCHES "Tuxbox")
        set (OSCamOperatingSystem "Tuxbox")
    elseif (OSCAM_SYSTEM_NAME MATCHES "TripleDragon")
        set (OSCamOperatingSystem "TripleDragon")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Coolstream")
        set (OSCamOperatingSystem "NeutrinoHD")
    elseif (OSCAM_SYSTEM_NAME MATCHES "NSLU2")
        set (OSCamOperatingSystem "SlugOS")
    elseif (OSCAM_SYSTEM_NAME MATCHES "WRT350NV2")
        set (OSCamOperatingSystem "OpenWRT")
        set (CS_OS_HW "wrt350nv2")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Dockstar")
        set (OSCamOperatingSystem "OpenWRT")
        set (CS_OS_HW "dockstar")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Fonera2")
        set (OSCamOperatingSystem "Fonera2")
    elseif (OSCAM_SYSTEM_NAME MATCHES "DIR-825")
        set (OSCamOperatingSystem "DIR-825")
    elseif (OSCAM_SYSTEM_NAME MATCHES "AZBox")
        set (OSCamOperatingSystem "AZBox")
    elseif (OSCAM_SYSTEM_NAME MATCHES "agv2+w")
        set (OSCamOperatingSystem "agv2+w")
    elseif (OSCAM_SYSTEM_NAME MATCHES "WRT54G")
        set (OSCamOperatingSystem "WRT54G")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Amino")
        set (OSCamOperatingSystem "Amino")
    elseif (OSCAM_SYSTEM_NAME MATCHES "QboxHD")
        set (OSCamOperatingSystem "QboxHD")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Padre")
        set (OSCamOperatingSystem "Padre")
    elseif (OSCAM_SYSTEM_NAME MATCHES "FriendlyARM")
        set (OSCamOperatingSystem "FriendlyARM")
    elseif (${CYGWIN})
        set (OSCamOperatingSystem "Windows/Cygwin")
        set (CS_OS_HW "pc")
        set (CS_OS_SYS "cygwin")
        set (CMAKE_SYSTEM_PROCESSOR "i386")
    else (OSCAM_SYSTEM_NAME MATCHES "Tuxbox")
        message (STATUS "Unknown cross system name: <${CMAKE_SYSTEM_NAME}>")
        set (OSCamOperatingSystem "Unknown")
    endif (OSCAM_SYSTEM_NAME MATCHES "Tuxbox")
else (CMAKE_CROSSCOMPILING)
    if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        set (OSCamOperatingSystem "Linux")
    elseif (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
        set (OSCamOperatingSystem "FreeBSD")
    elseif (OSCamOperatingSystem MATCHES "Padre")
        add_definitions ("-DPADRE -DSPARC")
        set (DEFAULT_CS_CONFDIR "/etc/oscam")
    elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
        set (OSCamOperatingSystem "Mac OS X")
    elseif (${CYGWIN})
        set (OSCamOperatingSystem "Windows/Cygwin")
        set (CMAKE_SYSTEM_PROCESSOR "i386")
    else (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        message (STATUS "Unknown system name: <${CMAKE_SYSTEM_NAME}>")
        set (OSCamOperatingSystem "Unknown")
    endif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
endif (CMAKE_CROSSCOMPILING)

#----------------------- some paths ------------------------------

set (OPTIONAL_LINK_DIR "" CACHE STRING "Some optional link directories")
set (OPTIONAL_INCLUDE_DIR "" CACHE STRING "Some optional include directories")

if (OSCamOperatingSystem MATCHES "Windows/Cygwin")
include_directories (
    ${CMAKE_CURRENT_SOURCE_DIR}/csctapi
    ${CMAKE_CURRENT_SOURCE_DIR}/cscrypt
    ${CMAKE_CURRENT_SOURCE_DIR}/algo
    ${CMAKE_CURRENT_SOURCE_DIR}/cygwin
    /usr/include/w32api
    ${OPTIONAL_INCLUDE_DIR}
    ${OPTIONAL_INCLUDE_DIR}/w32api
    )
else (OSCamOperatingSystem MATCHES "Windows/Cygwin")
include_directories (
    ${CMAKE_CURRENT_SOURCE_DIR}/csctapi
    ${CMAKE_CURRENT_SOURCE_DIR}/cscrypt
    ${CMAKE_CURRENT_SOURCE_DIR}/algo
    ${OPTIONAL_INCLUDE_DIR}
    )
endif (OSCamOperatingSystem MATCHES "Windows/Cygwin")

if(OSCamOperatingSystem MATCHES "Windows/Cygwin")
link_directories (
    /usr/lib
    /usr/lib/w32api
    /cygdrive/c/WINDOWS/system32/
    ${OPTIONAL_LINK_DIR}
    )
else (OSCamOperatingSystem MATCHES "Windows/Cygwin")
link_directories (
    ${OPTIONAL_LINK_DIR}
    )
endif (OSCamOperatingSystem MATCHES "Windows/Cygwin")

#----------------------- global options ------------------------------

if (OSCamOperatingSystem MATCHES "Linux")
    set (DEFAULT_CS_CONFDIR "/usr/local/etc")
elseif (OSCamOperatingSystem MATCHES "Mac OS X")
    add_definitions ("-DWITH_PCSC")
    set (DEFAULT_CS_CONFDIR "/usr/local/etc")
elseif (OSCamOperatingSystem MATCHES "Tuxbox")
    set (DEFAULT_CS_CONFDIR "/var/tuxbox/config")
elseif (OSCamOperatingSystem MATCHES "TripleDragon")
    add_definitions ("-DSTB04SCI")
    set (DEFAULT_CS_CONFDIR "/var/tuxbox/config")
elseif (OSCamOperatingSystem MATCHES "NeutrinoHD")
    add_definitions ("-DWITH_COOLAPI=1")
    set (DEFAULT_CS_CONFDIR "/var/tuxbox/config")
elseif (OSCamOperatingSystem MATCHES "SlugOS")
    set (DEFAULT_CS_CONFDIR "/var/etc")
elseif (OSCamOperatingSystem MATCHES "OpenWRT")
    if (CS_OS_HW MATCHES "wrt350nv2")
        add_definitions ("-DWRT350NV2")
        set (DEFAULT_CS_CONFDIR "/etc/oscam")
    elseif (CS_OS_HW MATCHES "dockstar")
        add_definitions ("-DDOCKSTAR")
        set (DEFAULT_CS_CONFDIR "/usr/oscam")
    endif (CS_OS_HW MATCHES "wrt350nv2")
elseif (OSCamOperatingSystem MATCHES "Fonera2")
    set (DEFAULT_CS_CONFDIR "/var/etc")
elseif (OSCamOperatingSystem MATCHES "DIR-825")
    set (DEFAULT_CS_CONFDIR "/var/etc")
elseif (OSCamOperatingSystem MATCHES "AZBox")
    add_definitions ("-DWITH_AZBOX")
    set (DEFAULT_CS_CONFDIR "/PLUGINS/OpenXCAS/oscamCAS")
elseif (OSCamOperatingSystem MATCHES "agv2+w")
    set (DEFAULT_CS_CONFDIR "/etc")
elseif (OSCamOperatingSystem MATCHES "WRT54G")
    set (DEFAULT_CS_CONFDIR "/jffs/etc/config/oscam")
elseif (OSCamOperatingSystem MATCHES "Amino")
    set (DEFAULT_CS_CONFDIR "/var/tuxbox/config")
elseif (OSCamOperatingSystem MATCHES "QboxHD")
    add_definitions ("-DQBOXHD")
    set (DEFAULT_CS_CONFDIR "/var/tuxbox/config")
elseif (OSCamOperatingSystem MATCHES "Windows/Cygwin")
    add_definitions ("-static -DWITH_PCSC")
    set (DEFAULT_CS_CONFDIR ".")
elseif (OSCamOperatingSystem MATCHES "FreeBSD")
    add_definitions ("-I/usr/local/include -L/usr/local/lib")
    set (DEFAULT_CS_CONFDIR ".")
elseif (OSCamOperatingSystem MATCHES "FriendlyARM")
    set (DEFAULT_CS_CONFDIR ".")
endif (OSCamOperatingSystem MATCHES "Linux")

set (CS_CONFDIR ${DEFAULT_CS_CONFDIR} CACHE STRING "Default path for the config files")
add_definitions ("-DCS_CONFDIR=\\\"${CS_CONFDIR}\\\"")

# Manage oscam-config.h based on command line parameters
# Manipulate config file based on given parameters and read unset parameters

execute_process (COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config.sh --show-valid OUTPUT_VARIABLE config_vars_string OUTPUT_STRIP_TRAILING_WHITESPACE)
string(REGEX MATCHALL "[A-Z0-9_]+" config_vars ${config_vars_string})

MACRO(GENERATE_OSCAM_CONFIG fullpath)
	foreach(option ${config_vars})
		if(DEFINED ${option})
			if(${option})
				execute_process (COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config.sh --enable ${option})
			else(${option})
				execute_process (COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config.sh --disable ${option})
			endif(${option})
		endif(DEFINED ${option})
	endforeach(option)
ENDMACRO(GENERATE_OSCAM_CONFIG fullpath)

#----------------------- subdirectories ------------------------------

include (CheckIncludeFile)
GENERATE_OSCAM_CONFIG("${CMAKE_CURRENT_SOURCE_DIR}/oscam-config.h")

check_include_file ("pthread.h" HAVE_PTHREAD)
if (HAVE_PTHREAD)
    message(STATUS "  pthread found. Adding pthread support ")
    add_definitions ("-DHAVE_PTHREAD_H")
elseif (HAVE_PTHREAD)
    message(STATUS "  no pthread found. No smartreader ")
endif (HAVE_PTHREAD)

if  (${CS_OSTYPE} MATCHES "powerpc-tuxbox")
elseif (${CS_OSTYPE} MATCHES "i686-pc-linux")
else (${CS_OSTYPE} MATCHES "powerpc-tuxbox")
check_include_file ("openssl/aes.h" HAVE_LIBCRYPTO)
endif  (${CS_OSTYPE} MATCHES "powerpc-tuxbox")

if (HAVE_LIBCRYPTO)
    add_definitions ("-DWITH_LIBCRYPTO")
endif (HAVE_LIBCRYPTO)

execute_process (COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config.sh --enabled WITH_SSL OUTPUT_VARIABLE CONFIG_WITH_SSL OUTPUT_STRIP_TRAILING_WHITESPACE)
if (CONFIG_WITH_SSL MATCHES "Y")
    set (WITH_SSL TRUE)
endif (CONFIG_WITH_SSL MATCHES "Y")

find_package(OpenSSL QUIET)
if (OPENSSL_FOUND)
    include_directories(${OPENSSL_INCLUDE_DIR})
    message(STATUS "  openssl found.")
else (OPENSSL_FOUND)
    message(STATUS "  openssl not found.")
    if (WITH_SSL)
        message(FATAL "  ssl support requested but not found! ")
    endif (WITH_SSL)
endif (OPENSSL_FOUND)

if (NOT OSCamOperatingSystem MATCHES "Mac OS X")
   if (LIBRTDIR)
        check_include_file ("${LIBRTDIR}/include/sys/time.h" HAVE_LIBRT_STATIC)
        if (HAVE_LIBRT_STATIC)
            if (EXISTS ${LIBRTDIR}/lib/librt.a)
                message(STATUS "  static librt found : ${LIBRTDIR}/lib/librt.a (needed by libusb).")
                add_definitions ("-I${LIBRTDIR}/include/")
                add_library(imp_librt STATIC IMPORTED)
                set_property(TARGET imp_librt PROPERTY IMPORTED_LOCATION ${LIBRTDIR}/lib/librt.a)
            else (EXISTS ${LIBRTDIR}/lib/librt.a)
                message(STATUS " ${LIBRTDIR}/lib/librt.a not found (needed by libusb). No smartreader support)")
                set (HAVE_LIBRT_STATIC False)
            endif (EXISTS ${LIBRTDIR}/lib/librt.a)
        else (HAVE_LIBRT_STATIC)
            message(STATUS "  no librt found (needed by libusb). No smartreader support")
        endif (HAVE_LIBRT_STATIC)
    else (LIBRTDIR)
        check_include_file ("time.h" HAVE_LIBRT)
        if (HAVE_LIBRT)
            message(STATUS "  librt found (needed by libusb).")
        else (HAVE_LIBRT)
            message(STATUS "  no librt found (needed by libusb. No smartreader support")
        endif (HAVE_LIBRT)
    endif (LIBRTDIR)
    if (WITH_STAPI)
		    if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/stapi/liboscam_stapi.a)
		    	message(STATUS "  liboscam_stapi.a found")
		    	add_definitions ("-DWITH_STAPI")
		    	add_library(stapilib STATIC IMPORTED)
		    	set_property(TARGET stapilib PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/stapi/liboscam_stapi.a)
		    	set (HAVE_LIBSTAPI True)
		    else (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/stapi/liboscam_stapi.a)
		    	message(FATAL "  liboscam_stapi.a support requested but not found! ")
		    	set (HAVE_LIBSTAPI False)
		    endif (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/stapi/liboscam_stapi.a)
    endif (WITH_STAPI)
else (NOT OSCamOperatingSystem MATCHES "Mac OS X")
    set (HAVE_LIBRT True)
endif (NOT OSCamOperatingSystem MATCHES "Mac OS X")

if( HAVE_LIBRT OR HAVE_LIBRT_STATIC)
    if (LIBUSBDIR)
        check_include_file ("${LIBUSBDIR}/include/libusb-1.0/libusb.h" HAVE_LIBUSB)
	if (HAVE_LIBUSB AND HAVE_PTHREAD)
            if (EXISTS ${LIBUSBDIR}/lib/libusb-1.0.a)
                message(STATUS "  static libusb 1.0 found (${LIBUSBDIR}/lib/libusb-1.0.a). Adding smartreader support ")
                add_definitions ("-DWITH_LIBUSB")
                add_definitions ("-I${LIBUSBDIR}/include/")
                add_library(imp_libusb STATIC IMPORTED)
                set_property(TARGET imp_libusb PROPERTY IMPORTED_LOCATION ${LIBUSBDIR}/lib/libusb-1.0.a)
            else (EXISTS ${LIBUSBDIR}/lib/libusb-1.0.a)
                message(STATUS "  static libusb 1.0 not found (${LIBUSBDIR}/lib/libusb-1.0.a). No smartreader support ")
                set (HAVE_LIBUSB False)
                set (HAVE_LIBRT False)
                set (HAVE_LIBRT_STATIC False)
            endif (EXISTS ${LIBUSBDIR}/lib/libusb-1.0.a)
        else (HAVE_LIBUSB AND HAVE_PTHREAD)
            message(STATUS "  no libusb 1.0 found. No smartreader support")
                set (HAVE_LIBUSB False)
                set (HAVE_LIBRT False)
                set (HAVE_LIBRT_STATIC False)
        endif (HAVE_LIBUSB AND HAVE_PTHREAD)
    else (LIBUSBDIR)
        check_include_file ("libusb-1.0/libusb.h" HAVE_LIBUSB)
        check_include_file ("libusb-1.0/libusb.h" PRESENT)
	if (STATIC_LIBUSB EQUAL 0)
		if(HAVE_LIBUSB AND HAVE_PTHREAD AND PRESENT)
                   message(STATUS "  system libusb 1.0 found  Adding smartreader support ")
                   add_definitions ("-DWITH_LIBUSB")
		   set (STATICLIBUSB False)
		endif(HAVE_LIBUSB AND HAVE_PTHREAD AND PRESENT)
	else(STATIC_LIBUSB EQUAL 0)
	if (OSCAM_SYSTEM_NAME MATCHES "Tuxbox")
	set (STATIC_LIBUSB True)
	endif (OSCAM_SYSTEM_NAME MATCHES "Tuxbox") 
        if (HAVE_LIBUSB AND HAVE_PTHREAD AND STATIC_LIBUSB AND PRESENT)
                message(STATUS "  static libusb 1.0 found (libusb-1.0.a). Adding smartreader support ")
                add_definitions ("-DWITH_LIBUSB")
		set (STATICLIBUSB True)
	elseif (HAVE_LIBUSB AND HAVE_PTHREAD AND PRESENT)
                message(STATUS "  system libusb 1.0 found  Adding smartreader support ")
                add_definitions ("-DWITH_LIBUSB")
		set (STATICLIBUSB False)
        else (HAVE_LIBUSB AND HAVE_PTHREAD AND STATIC_LIBUSB AND PRESENT)
            message(STATUS "  no libusb 1.0 found. No smartreader support")
	    set (HAVE_LIBUSB False)
        endif (HAVE_LIBUSB AND HAVE_PTHREAD AND STATIC_LIBUSB AND PRESENT)
	endif(STATIC_LIBUSB EQUAL 0)
    endif (LIBUSBDIR)
endif( HAVE_LIBRT OR HAVE_LIBRT_STATIC)

check_include_file ("PCSC/wintypes.h" HAVE_PCSC)
if ((NOT HAVE_PCSC) AND OPTIONAL_INCLUDE_DIR)
	check_include_file("${OPTIONAL_INCLUDE_DIR}/PCSC/wintypes.h" HAVE_PCSC)
endif((NOT HAVE_PCSC) AND OPTIONAL_INCLUDE_DIR)
if (HAVE_PCSC)
		if(OPTIONAL_INCLUDE_DIR AND EXISTS ${OPTIONAL_INCLUDE_DIR}/PCSC/wintypes.h)
	    message(STATUS "  PCSC headers found (${OPTIONAL_INCLUDE_DIR}/PCSC). Adding PCSC support ")
		  add_definitions ("-DWITH_PCSC")
		  add_definitions ("-I${OPTIONAL_INCLUDE_DIR}/PCSC")
    elseif (EXISTS /usr/include/PCSC/wintypes.h)
    	message(STATUS "  PCSC headers found (/usr/include/PCSC). Adding PCSC support ")
    	add_definitions ("-DWITH_PCSC")
    	add_definitions ("-I/usr/include/PCSC")
    elseif (EXISTS /usr/local/include/PCSC/wintypes.h)
    	message(STATUS "  PCSC headers found (/usr/local/include/PCSC). Adding PCSC support ")
    	add_definitions ("-DWITH_PCSC")
    	add_definitions ("-I/usr/local/include/PCSC")
    else (OPTIONAL_INCLUDE_DIR AND EXISTS ${OPTIONAL_INCLUDE_DIR}/PCSC/wintypes.h)
    	set (HAVE_PCSC False)
    	if(OPTIONAL_INCLUDE_DIR)
    		message(STATUS "  PCSC headers not found (not in /usr/include/PCSC or /usr/local/include/PCSC or ${OPTIONAL_INCLUDE_DIR}/PCSC). No PCSC support ")
    	else(OPTIONAL_INCLUDE_DIR)
	    	message(STATUS "  PCSC headers not found (not in /usr/include/PCSC or /usr/local/include/PCSC). No PCSC support ")
    	endif(OPTIONAL_INCLUDE_DIR)
    endif(OPTIONAL_INCLUDE_DIR AND EXISTS ${OPTIONAL_INCLUDE_DIR}/PCSC/wintypes.h)
else (HAVE_PCSC)
if (OSCamOperatingSystem MATCHES "Windows/Cygwin")
    add_definitions ("-Icygwin")
    set (HAVE_PCSC "1")
endif (OSCamOperatingSystem MATCHES "Windows/Cygwin")
endif (HAVE_PCSC)


#----------------------- subdirectories ------------------------------

add_subdirectory (csctapi)
add_subdirectory (algo)
add_subdirectory (cscrypt)
if( HAVE_LIBRT OR HAVE_LIBRT_STATIC)
    if (HAVE_LIBUSB)
        add_subdirectory (utils)
    endif (HAVE_LIBUSB)
endif( HAVE_LIBRT OR HAVE_LIBRT_STATIC)

#----------------------- file groups ------------------------------

file (GLOB csmodules_srcs "module-*.c")
file (GLOB csmodules_hdrs "module-*.h")
file (GLOB csreaders_srcs "reader-*.c")
file (GLOB csreaders_hdrs "reader-*.h")
file (GLOB csoscam_srcs "oscam-*.c")
file (GLOB csoscam_hdrs "oscam-*.h")
file (GLOB exe_srcs "oscam.c")
file (GLOB exe_hdrs "globals.h")
file (GLOB all_srcs ${csmodules_srcs} ${csreaders_srcs} ${csoscam_srcs} ${exe_srcs})

#----------------------- modules ------------------------------

set (csmodules "csmodules")
add_library (${csmodules} STATIC ${csmodules_srcs} ${csmodules_hdrs})

#----------------------- readers ------------------------------

set (csreaders "csreaders")
add_library (${csreaders} STATIC ${csreaders_srcs} ${csreaders_hdrs})

#----------------------- other oscam files ------------------------------

set (csoscam "csoscam")
add_library (${csoscam} STATIC ${csoscam_srcs} ${csoscam_hdrs})

#----------------------- the executable ------------------------------

set (exe_name "oscam")
add_executable (${exe_name} ${exe_srcs} ${exe_hdrs})
target_link_libraries (${exe_name} ${csoscam} ${csmodules} ${csreaders} csctapi cscrypt algo)
if(HAVE_LIBRT AND HAVE_LIBUSB)
    if (STATICLIBUSB)
	target_link_libraries (${exe_name} libusb-1.0.a)
    else (STATICLIBUSB)
	if (LIBUSBDIR)
	 target_link_libraries (${exe_name} imp_libusb)
	else(LIBUSBDIR)
	 target_link_libraries (${exe_name} usb-1.0)
	endif(LIBUSBDIR)	
    endif(STATICLIBUSB)
    if (NOT OSCamOperatingSystem MATCHES "Mac OS X")
        target_link_libraries (${exe_name} rt)
    endif (NOT OSCamOperatingSystem MATCHES "Mac OS X")
    if (OSCamOperatingSystem MATCHES "Windows/Cygwin")
        target_link_libraries (${exe_name} setupapi)
        target_link_libraries (${exe_name} ole32)
        target_link_libraries (${exe_name} shell32)
    endif (OSCamOperatingSystem MATCHES "Windows/Cygwin")
endif(HAVE_LIBRT AND HAVE_LIBUSB)

if (HAVE_LIBRT_STATIC AND HAVE_LIBUSB)
    if (STATICLIBUSB)
	target_link_libraries (${exe_name} libusb-1.0.a)
    else (STATICLIBUSB)
	if (LIBUSBDIR)
	 target_link_libraries (${exe_name} imp_libusb)
	else(LIBUSBDIR)
	 target_link_libraries (${exe_name} usb-1.0)
	endif(LIBUSBDIR)	
    endif(STATICLIBUSB)
    if (NOT OSCamOperatingSystem MATCHES "Mac OS X")
    target_link_libraries (${exe_name} imp_librt)
    endif (NOT OSCamOperatingSystem MATCHES "Mac OS X")
    if (OSCamOperatingSystem MATCHES "Windows/Cygwin")
        target_link_libraries (${exe_name} setupapi)
        target_link_libraries (${exe_name} ole32)
        target_link_libraries (${exe_name} shell32)
    endif (OSCamOperatingSystem MATCHES "Windows/Cygwin")
endif (HAVE_LIBRT_STATIC AND HAVE_LIBUSB)

if (HAVE_PTHREAD)
    target_link_libraries (${exe_name} pthread)
endif (HAVE_PTHREAD)

if (WITH_SSL)
    target_link_libraries (${exe_name} ssl)
endif (WITH_SSL)

if (HAVE_LIBCRYPTO)
    target_link_libraries (${exe_name} crypto)
endif (HAVE_LIBCRYPTO)

if (HAVE_PCSC)
if (NOT OSCamOperatingSystem MATCHES "Mac OS X")
if (NOT OSCamOperatingSystem MATCHES "Windows/Cygwin")
    target_link_libraries (${exe_name} pcsclite)
endif (NOT OSCamOperatingSystem MATCHES "Windows/Cygwin")
endif (NOT OSCamOperatingSystem MATCHES "Mac OS X")
endif (HAVE_PCSC)

if (HAVE_LIBSTAPI)
    target_link_libraries(${exe_name} stapilib)
endif (HAVE_LIBSTAPI)

add_dependencies (${exe_name} ${csoscam} ${csreaders} ${csmodules})

#----------------------- specific options ------------------------------

if (OSCamOperatingSystem MATCHES "Linux")
elseif (OSCamOperatingSystem MATCHES "Mac OS X")
    FIND_LIBRARY (PCSC_LIBRARY PCSC)
    message (STATUS "OS X system PCSC : ${PCSC_LIBRARY}")
    target_link_libraries ( ${exe_name} ${PCSC_LIBRARY})
    set (HAVE_PCSC "1")
    FIND_LIBRARY (IOKit_LIBRARY IOKit)
    target_link_libraries ( ${exe_name} ${IOKit_LIBRARY})
    FIND_LIBRARY (CoreFoundation_LIBRARY CoreFoundation)
    target_link_libraries ( ${exe_name} ${CoreFoundation_LIBRARY})
elseif (OSCamOperatingSystem MATCHES "Tuxbox")
    target_link_libraries ( ${exe_name} dl)
elseif (OSCamOperatingSystem MATCHES "TripleDragon")
    target_link_libraries ( ${exe_name} dl)
elseif (OSCamOperatingSystem MATCHES "SlugOS")
elseif (OSCamOperatingSystem MATCHES "OpenWRT")
elseif (OSCamOperatingSystem MATCHES "Fonera2")
elseif (OSCamOperatingSystem MATCHES "DIR-825")
elseif (OSCamOperatingSystem MATCHES "agv2+w")
elseif (OSCamOperatingSystem MATCHES "WRT54G")
elseif (OSCamOperatingSystem MATCHES "Amino")
elseif (OSCamOperatingSystem MATCHES "QboxHD")
elseif (OSCamOperatingSystem MATCHES "Windows/Cygwin")
    message (STATUS "Windows system PCSC : winscard.dll")
    target_link_libraries (${exe_name} -Wl,--enable-stdcall-fixup winscard)
    target_link_libraries (${exe_name} setupapi )
    target_link_libraries (${exe_name} ole32)
    target_link_libraries (${exe_name} shell32)
elseif (OSCamOperatingSystem MATCHES "NeutrinoHD")
    target_link_libraries ( ${exe_name} rt nxp )
elseif (OSCamOperatingSystem MATCHES "AZBox")
    add_library(xcas STATIC IMPORTED)
    set_property(TARGET xcas PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openxcas/libOpenXCASAPI.a)
    target_link_libraries(${exe_name} xcas)
endif (OSCamOperatingSystem MATCHES "Linux")

#----------------------- put svnversion in the build ------------------------------
# at every target rebuild, we re-build the oscam.c compilation...

# add the needed dependency
add_dependencies (${exe_name} svnversion)
add_dependencies (${csoscam} svnversion-log)

# how to re-build the files which printout the version
add_custom_target (
    svnversion
    ALL
#   touch ${CMAKE_CURRENT_SOURCE_DIR}/oscam.c
)
add_custom_target (
    svnversion-log
    ALL
#   touch ${CMAKE_CURRENT_SOURCE_DIR}/oscam-log.c
)

execute_process (COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config.sh --oscam-revision COMMAND tr -d '\n' OUTPUT_VARIABLE CS_SVN_VERSION)
add_definitions ("-D'CS_SVN_VERSION=\"${CS_SVN_VERSION}\"'")

execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpmachine COMMAND tr -d '\n' OUTPUT_VARIABLE CS_TARGET)
add_definitions ("-D'CS_TARGET=\"${CS_TARGET}\"'")

#----------------------- global compile and link options ------------------------------
# disable warning about unused but set variables in gcc 4.6+
if (CMAKE_COMPILER_IS_GNUCC)
    execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
    string(REGEX MATCHALL "[0-9]+" GCC_VERSION_COMPONENTS ${GCC_VERSION})
    list(GET GCC_VERSION_COMPONENTS 0 GCC_MAJOR)
    list(GET GCC_VERSION_COMPONENTS 1 GCC_MINOR)
    add_definitions ("-W -Wall -fno-strict-aliasing")
    set (CMAKE_C_FLAGS "-O2")
    set (CMAKE_C_FLAGS_DEBUG "-O0 -ggdb")
    set (CMAKE_CXX_FLAGS_DEBUG "-O0 -ggdb")
endif (CMAKE_COMPILER_IS_GNUCC)
# some optimisations
if (OSCamOperatingSystem MATCHES "Mac OS X")
    add_definitions("-isysroot /Developer/SDKs/MacOSX10.6.sdk")
endif (OSCamOperatingSystem MATCHES "Mac OS X")

# we don't want the '-rdynamic' in the link command
set (CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")

# we want to strip if not Debug build
if (OSCamOperatingSystem MATCHES "Mac OS X")
  if (NOT CMAKE_BUILD_TYPE STREQUAL Debug)
    set (CMAKE_EXE_LINKER_FLAGS "-s -isysroot /Developer/SDKs/MacOSX10.6.sdk")
  else (NOT CMAKE_BUILD_TYPE STREQUAL Debug)
    message (STATUS "  building with debug")
    set (CMAKE_EXE_LINKER_FLAGS "-ggdb -isysroot /Developer/SDKs/MacOSX10.6.sdk")
  endif (NOT CMAKE_BUILD_TYPE STREQUAL Debug)
else (OSCamOperatingSystem MATCHES "Mac OS X")
  if (NOT CMAKE_BUILD_TYPE STREQUAL Debug)
    set (CMAKE_EXE_LINKER_FLAGS "-s")
  else (NOT CMAKE_BUILD_TYPE STREQUAL Debug)
    message (STATUS "  building with debug")
    set (CMAKE_EXE_LINKER_FLAGS "-ggdb")
  endif (NOT CMAKE_BUILD_TYPE STREQUAL Debug)
endif (OSCamOperatingSystem MATCHES "Mac OS X")

if (OSCamOperatingSystem MATCHES "Windows/Cygwin")
    set (CMAKE_EXE_LINKER_FLAGS "--enable-stdcall-fixup")
endif (OSCamOperatingSystem MATCHES "Windows/Cygwin")

#----------------------- installation -----------------------------

file (GLOB config_files "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/oscam.*")
file (GLOB doc_files "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/txt/*.txt")
file (GLOB man1_files "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/man/*.1")
file (GLOB man5_files "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/man/*.5")
file (GLOB example_files "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/example/oscam.ac"
                         "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/example/oscam.cert"
                         "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/example/oscam.conf"
                         "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/example/oscam.guess"
                         "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/example/oscam.ird"
                         "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/example/oscam.server"
                         "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/example/oscam.services"
                         "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/example/oscam.srvid"
                         "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/doc/example/oscam.user")
file (GLOB monitor_files "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/monitor/mpcs*.sh"
                         "${CMAKE_CURRENT_SOURCE_DIR}/Distribution/monitor/mpcs*.tar")

install (PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${exe_name}${CMAKE_EXECUTABLE_SUFFIX} DESTINATION bin COMPONENT bin)
install (FILES ${config_files} DESTINATION etc COMPONENT config)
install (FILES ${doc_files} DESTINATION share/doc/oscam COMPONENT doc)
install (FILES ${man1_files} DESTINATION share/man/man1 COMPONENT doc)
install (FILES ${man5_files} DESTINATION share/man/man5 COMPONENT doc)
install (FILES ${example_files} DESTINATION share/doc/oscam/example COMPONENT doc)
install (FILES ${monitor_files} DESTINATION share/doc/oscam/monitor COMPONENT doc)

#----------------------- we can use CPack to build pacakges --------------------------

# get version from source file
execute_process (COMMAND grep CS_VERSION ${CMAKE_CURRENT_SOURCE_DIR}/globals.h
    OUTPUT_VARIABLE CS_VERSION)
string (REGEX REPLACE ".*\"\(.*\)\".*" "\\1" CS_VERSION ${CS_VERSION})
string (REGEX REPLACE "\(.*\)\\..*\\..*" "\\1" CPACK_PACKAGE_VERSION_MAJOR ${CS_VERSION})
string (REGEX REPLACE ".*\\.\(.*\)\\..*" "\\1" CPACK_PACKAGE_VERSION_MINOR ${CS_VERSION})
string (REGEX REPLACE ".*\\..*\\.\(.*\)" "\\1" CPACK_PACKAGE_VERSION_PATCH ${CS_VERSION})
set (CPACK_PACKAGE_VERSION
     "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

# compute my filename
set (CPACK_PACKAGE_FILE_NAME
     "${PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CS_TARGET}")

# wich archive we want to generate
set (CPACK_GENERATOR "TGZ")

# what to put in the archive
set (CPACK_STRIP_FILES TRUE)
set (CPACK_COMPONENTS_ALL bin)# config doc)

# ok, we can now use CPack
include (CPack)

#----------------------- printout resume -----------------------------

message (STATUS "")
message (STATUS "  operating system: ${OSCamOperatingSystem}")
message (STATUS "  target system: ${CS_TARGET}")
message (STATUS "  revision: ${CS_SVN_VERSION}")
if (HAVE_LIBCRYPTO)
    message (STATUS "  use libcrypto functions")
else (HAVE_LIBCRYPTO)
    message (STATUS "  use built-in crypt functions")
endif (HAVE_LIBCRYPTO)
if (HAVE_PCSC)
    message (STATUS "  use system pcsc functions")
endif (HAVE_PCSC)
if (HAVE_PTHREAD)
    message (STATUS "  use system pthread functions")
endif (HAVE_PTHREAD)
if (HAVE_LIBUSB)
 if(STATICLIBUSB)
    message (STATUS "  use static libusb functions")
 else(STATICLIBUSB)
   if (LIBUSBDIR)
      message(STATUS " use static libusb from selected LIBUSBDIR functions")
   else(LIBUSBDIR)
      message(STATUS " use system libusb functions")
   endif(LIBUSBDIR)
 endif(STATICLIBUSB)
endif (HAVE_LIBUSB)

message (STATUS "")
