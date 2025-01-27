#  ==============================================================================
#  
#  This file is part of the iPlug 2 library. Copyright (C) the iPlug 2 developers. 
#
#  See LICENSE.txt for  more info.
#
#  ==============================================================================

# function(iplug_add_app PlugName)
#   cmake_policy(SET CMP0076 NEW)

#   cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "SOURCES;RESOURCES")

#   set(TargetName ${PlugName}App)

#   add_executable(${TargetName} WIN32 MACOSX_BUNDLE ${ARG_SOURCES})
#   target_link_libraries(${TargetName} PUBLIC iGraphics iPlug2_Core)
#   target_link_libraries(${TargetName} PUBLIC rtmidi rtaudio iPlug2_Core iGraphics)

#   set(SdkRoot ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../..)
#   set(ResourceDir ${CMAKE_CURRENT_SOURCE_DIR}/resources)

#   target_sources(${TargetName} PRIVATE
#     ${SdkRoot}/IPlug/APP/IPlugAPP.cpp
#     ${SdkRoot}/IPlug/APP/IPlugAPP_dialog.cpp
#     ${SdkRoot}/IPlug/APP/IPlugAPP_host.cpp
#     ${SdkRoot}/IPlug/APP/IPlugAPP_main.cpp
#     ${SdkRoot}/IPlug/APP/IPlugAPP_main.mm
#     ${SdkRoot}/IPlug/APP/IPlugAPP.h
#   )

#   target_compile_definitions(${TargetName} PUBLIC APP_API)
#   target_include_directories(${TargetName} PUBLIC
#     ${SdkRoot}/IPlug/APP
#     ${CMAKE_CURRENT_SOURCE_DIR}
#     ${CMAKE_CURRENT_SOURCE_DIR}/resources
#   )

#   target_compile_definitions(${TargetName} PUBLIC USE_RTAUDIO)

#   if (APPLE)
#     enable_language(OBJCXX)
#     # Set language for files combining C++ and Objective-C
#     set_source_files_properties(${sdk}/IPlugAPP_main.cpp DIRECTORY "${CMAKE_SOURCE_DIR}" PROPERTIES LANGUAGE "OBJCXX")
#     target_link_libraries(${TargetName} PUBLIC Swell)

#     target_link_options(${TargetName} BEFORE PUBLIC -ObjC)
#     target_link_options(${TargetName} BEFORE PUBLIC -all_load)

#     set(Resources
#       "${ResourceDir}/${PlugName}.icns"
#       "${CMAKE_CURRENT_BINARY_DIR}/${PlugName}-macOS-MainMenu.nib"
#       ${ARG_RESOURCES}
#     )

#     find_program( IBTOOL ibtool HINTS "/usr/bin" "${OSX_DEVELOPER_ROOT}/usr/bin" )
#     add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${PlugName}-macOS-MainMenu.nib
#       COMMAND ${IBTOOL} --errors --warnings --notices --output-format human-readable-text
#              --compile
#              ${CMAKE_CURRENT_BINARY_DIR}/${PlugName}-macOS-MainMenu.nib
#              ${ResourceDir}/${PlugName}-macOS-MainMenu.xib
#     )

#     set_source_files_properties(${Resources}
#       PROPERTIES MACOSX_PACKAGE_LOCATION "Resources"
#     )

#     target_sources(${TargetName} PUBLIC ${Resources})
#     source_group(Resources FILES ${Resources} ${ResourceDir}/${PlugName}-macOS-MainMenu.xib)

#     set_target_properties(${TargetName} PROPERTIES
#       MACOSX_BUNDLE TRUE
#       MACOSX_FRAMEWORK_IDENTIFIER org.cmake.ExecutableTarget
#       MACOSX_BUNDLE_INFO_PLIST
#         ${ResourceDir}/${PlugName}-macOS-Info.plist
#     )
#   endif()
# endfunction()


# # Platform-specific configurations
# if(WIN32)
# elseif(APPLE)

# elseif(UNIX AND NOT APPLE)
#   # Linux-specific configuration
#   find_package(PkgConfig REQUIRED)
#   pkg_check_modules(DEPS REQUIRED IMPORTED_TARGET
#     glib-2.0
#     gtk+-3.0
#     gdk-3.0
#   )

#   # FIXME: use swell target
#   # SWELL configuration for Linux
#   set(swell_src
#     swell.h swell.cpp swell-appstub-generic.cpp swell-dlg-generic.cpp
#     swell-gdi-generic.cpp swell-gdi-lice.cpp swell-ini.cpp swell-kb-generic.cpp
#     swell-menu-generic.cpp swell-miscdlg-generic.cpp swell-misc-generic.cpp
#     swell-wnd-generic.cpp swell-generic-gdk.cpp
#   )
#   list(TRANSFORM swell_src PREPEND "${WDL_DIR}/swell/")

#   iplug_target_add(iPlug2_APP INTERFACE
#     DEFINE
#       SWELL_COMPILED SWELL_SUPPORT_GTK SWELL_TARGET_GDK=3 SWELL_LICE_GDI
#       SWELL_FREETYPE _FILE_OFFSET_BITS=64 WDL_ALLOW_UNSIGNED_DEFAULT_CHAR
#     INCLUDE
#       "${WDL_DIR}/swell/"
#       "${WDL_DIR}/lice/"
#     LINK
#       LICE_Core LICE_PNG LICE_ZLIB
#       PkgConfig::DEPS "X11" "Xi"
#     SOURCE
#       ${swell_src}
#       ${PLUG_RESOURCES_DIR}/main.rc_mac_dlg
#       ${PLUG_RESOURCES_DIR}/main.rc_mac_menu
#   )
# else()
#   message(FATAL_ERROR "APP not supported on platform ${CMAKE_SYSTEM_NAME}")
# endif()

# # Function to configure APP targets
# function(iplug_configure_app target)
#   iplug_target_add(${target} PUBLIC LINK iPlug2_APP)

#   set(out_dir "${CMAKE_BINARY_DIR}/out")

#   if(WIN32)
#     set(res_dir "${CMAKE_BINARY_DIR}/${PLUG_NAME}-app/resources")
    
#     set_target_properties(${target} PROPERTIES
#       OUTPUT_NAME "${PLUG_NAME}"
#       RUNTIME_OUTPUT_DIRECTORY "${PLUG_NAME}-app"
#     )
    
#     add_custom_command(TARGET ${target} POST_BUILD
#       COMMAND "${CMAKE_BINARY_DIR}/postbuild-win.bat"
#       ARGS "\"$<TARGET_FILE:${target}>\"" "\".exe\""
#     )
#   elseif(APPLE)
#     set(app_out_dir "${out_dir}/${PLUG_NAME}.app")
#     set(res_dir "${app_out_dir}/Contents/Resources")

#     set_target_properties(${target} PROPERTIES
#       XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
#       XCODE_ATTRIBUTE_GCC_GENERATE_DEBUGGING_SYMBOLS "YES"
#     )
    
#     if(CMAKE_GENERATOR STREQUAL "Xcode")
#       set_target_properties(${target} PROPERTIES
#         RUNTIME_OUTPUT_DIRECTORY_DEBUG "${out_dir}"
#         RUNTIME_OUTPUT_DIRECTORY_RELEASE "${out_dir}"
#       )
#     endif()

#     target_compile_options(${target} PRIVATE -g)

#     set(_res
#       "${PLUG_RESOURCES_DIR}/${PLUG_NAME}.icns"
#       "${PLUG_RESOURCES_DIR}/${PLUG_NAME}-macOS-MainMenu.xib"
#     )
#     source_group("Resources" FILES ${_res})
#     # iplug_target_add(${target} PUBLIC SOURCE ${_res} RESOURCE ${_res})

#     add_custom_command(TARGET ${target} POST_BUILD
#       COMMAND ${CMAKE_COMMAND} -E make_directory "${out_dir}"
#       COMMAND ${CMAKE_COMMAND} -E copy_directory "$<TARGET_BUNDLE_DIR:${target}>" "${app_out_dir}"
#       COMMAND ${CMAKE_COMMAND} -E copy_directory "$<TARGET_BUNDLE_DIR:${target}>.dSYM" "${out_dir}/${PLUG_NAME}.app.dSYM" || ${CMAKE_COMMAND} -E echo "No .dSYM found, possibly a non-Xcode generator"
#       COMMAND ${CMAKE_COMMAND} -E echo "Attempting to generate dSYM file..."
#       COMMAND dsymutil "$<TARGET_BUNDLE_DIR:${target}>/Contents/MacOS/$<TARGET_FILE_NAME:${target}>" -o "${out_dir}/${PLUG_NAME}.app.dSYM" || ${CMAKE_COMMAND} -E echo "Failed to generate dSYM, continuing build..."
#       COMMAND ${CMAKE_COMMAND} -E echo "App bundle and dSYM processing completed"
#     )
#   endif()

#   iplug_target_bundle_resources(${target} "${res_dir}")
# endfunction()
