cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
cmake_policy(SET CMP0091 NEW)

project(IPlugEffect VERSION 1.0.0 LANGUAGES C CXX)


# Set project directories and source files
set(SRC_FILES
  "config.h"
  "IPlugEffect.h"
  "IPlugEffect.cpp"
)
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${SRC_FILES})

iplug_add_app(IPlugEffect
    SOURCES ${SRC_FILES}
    RESOURCES resources/fonts/Roboto-Regular.ttf
)

iplug_add_vst3(IPlugEffect
    SOURCES ${SRC_FILES}
    RESOURCES resources/fonts/Roboto-Regular.ttf
)



if (0)

# CLAP target configuration
set(TARGET clap)
add_library(${TARGET} MODULE ${SRC_FILES})
iplug_target_add(${TARGET} PUBLIC 
  LINK iPlug2_CLAP _base 
  RESOURCE ${RESOURCES}
)
iplug_configure_target(${TARGET} clap)

# VST2 target configuration
set(TARGET vst2)
add_library(${TARGET} MODULE ${SRC_FILES})
iplug_target_add(${TARGET} PUBLIC 
  LINK iPlug2_VST2 _base 
  RESOURCE ${RESOURCES}
)
iplug_configure_target(${TARGET} vst2)

# VST3 target configuration
set(TARGET vst3)
add_library(${TARGET} MODULE ${SRC_FILES})
iplug_target_add(${TARGET} PUBLIC 
  LINK iPlug2_VST3 _base 
  RESOURCE ${RESOURCES}
)
iplug_configure_target(${TARGET} vst3)

# AUv2 target configuration (macOS only)
if(APPLE)
  set(TARGET auv2)
  add_library(${TARGET} MODULE ${SRC_FILES})
  iplug_target_add(${TARGET} PUBLIC 
    LINK iPlug2_AUv2 _base 
    RESOURCE ${RESOURCES}
  )
  iplug_configure_target(${TARGET} auv2)
endif()

# Windows-specific resource configuration
if(WIN32)
  set(CMAKE_RC_FLAGS "/I${PROJECT_DIR}/resources /I${PROJECT_DIR}/resources/fonts /I${PROJECT_DIR}/resources/img ${CMAKE_RC_FLAGS}")
endif()

iplug_target_debug_xcode(vst3 "/Applications/REAPER.app" "")
iplug_target_debug_xcode(vst2 "/Applications/REAPER.app" "")
iplug_target_debug_xcode(clap "/Applications/REAPER.app" "")
iplug_target_debug_xcode(auv2 "/Applications/REAPER.app" "")

endif()
