#  ==============================================================================
#  
#  This file is part of the iPlug 2 library. Copyright (C) the iPlug 2 developers. 
#
#  See LICENSE.txt for  more info.
#
#  ==============================================================================

cmake_minimum_required(VERSION 3.11)

set(VST3_SDK "${IPLUG2_DIR}/Dependencies/IPlug/VST3_SDK" CACHE PATH "VST3 SDK directory.")
set(vst3_target_arch "")

if (WIN32)
  if (CMAKE_SYSTEM_PROCESSOR MATCHES "X86")
    set(_paths "C:/Program Files (x86)/Common Files/VST3" "C:/Program Files/Common Files/VST3")
    set(vst3_target_arch "x86")
  elseif ((CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "AMD64") OR (CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "IA64"))
    set(_paths "C:/Program Files/Common Files/VST3")
    set(vst3_target_arch "x86_64")
  endif()
  set(vst3_target_arch "${vst3_target_arch}-win")
elseif (CMAKE_SYSTEM_NAME MATCHES "Darwin")
  set(_paths "$ENV{HOME}/Library/Audio/Plug-Ins/VST3" "/Library/Audio/Plug-Ins/VST3")
elseif (CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(_paths "$ENV{HOME}/.vst3")
  set(vst3_target_arch "${CMAKE_SYSTEM_PROCESSOR}-linux")
endif()


iplug_find_path(VST3_INSTALL_PATH REQUIRED DIR DEFAULT_IDX 0
  DOC "Path to install VST3 plugins"
  PATHS ${_paths})


function(iplug_configure_vst3 target)
  iplug_target_add(${target} PUBLIC LINK iPlug2_VST3)

  target_link_libraries(${target} PUBLIC)

  if (WIN32)
    set(out_dir "${CMAKE_BINARY_DIR}/${PLUG_NAME}.vst3")
  else()
    set(out_dir "${CMAKE_BINARY_DIR}/out/${PLUG_NAME}.vst3")
  endif()
  set(install_dir "${VST3_INSTALL_PATH}/${PLUG_NAME}.vst3")

  if (WIN32)
    set(res_dir "${CMAKE_BINARY_DIR}/vst3-resources")

    set_target_properties(${target} PROPERTIES
      OUTPUT_NAME "${PLUG_NAME}"
      RUNTIME_OUTPUT_DIRECTORY "${out_dir}/Contents/${vst3_target_arch}"
      LIBRARY_OUTPUT_DIRECTORY "${out_dir}/Contents/${vst3_target_arch}"
      PREFIX ""
      SUFFIX ".vst3"
    )

    add_custom_command(TARGET ${target} POST_BUILD
      COMMAND "${CMAKE_BINARY_DIR}/postbuild-win.bat" 
      ARGS "\"$<TARGET_FILE:${target}>\"" "\".vst3\""
      COMMAND ${CMAKE_COMMAND} -E copy_if_different "$<TARGET_PDB_FILE:${target}>" "${CMAKE_BINARY_DIR}/out/${PLUG_NAME}-vst3.pdb" || echo "No PDB found for VST3"
    )

  elseif (APPLE)
    set(res_dir "${out_dir}/Contents/Resources")

    set_target_properties(${target} PROPERTIES 
      BUNDLE TRUE
      MACOSX_BUNDLE TRUE
      MACOSX_BUNDLE_INFO_PLIST ${PLUG_RESOURCES_DIR}/${PLUG_NAME}-VST3-Info.plist
      BUNDLE_EXTENSION "vst3"
      LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/out"
      PREFIX ""
      SUFFIX ""
      XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
      XCODE_ATTRIBUTE_GCC_GENERATE_DEBUGGING_SYMBOLS "YES"
    )

    # Make sure Xcode generator uses the same output directories
    if(CMAKE_GENERATOR STREQUAL "Xcode")
      set_target_properties(${target} PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}/out"
        LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/out"
      )
    endif()
    
    add_custom_command(TARGET ${target} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy_directory "${out_dir}" "${install_dir}"
      COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/out"
      COMMAND dsymutil "$<TARGET_FILE:${target}>" -o "${CMAKE_BINARY_DIR}/out/${PLUG_NAME}.vst3.dSYM"
      COMMAND ${CMAKE_COMMAND} -E copy_directory "$<TARGET_BUNDLE_DIR:${target}>.dSYM" "${CMAKE_BINARY_DIR}/out/${PLUG_NAME}.vst3.dSYM" || echo "No dSYM found for VST3"
    )

    set(PKGINFO_FILE "${out_dir}/Contents/PkgInfo")
    file(WRITE ${PKGINFO_FILE} "BNDL????")
    add_custom_command(TARGET ${target} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E touch ${PKGINFO_FILE})

  elseif (UNIX AND NOT APPLE)
    set_target_properties(${target} PROPERTIES
      OUTPUT_NAME "${PLUG_NAME}"
      LIBRARY_OUTPUT_DIRECTORY "${out_dir}/Contents/${vst3_target_arch}"
      PREFIX ""
      SUFFIX ".so"
    )

    add_custom_command(TARGET ${target} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy_directory "${out_dir}" "${install_dir}"
    )

  endif()

  iplug_target_bundle_resources(${target} "${res_dir}")
  
endfunction()
