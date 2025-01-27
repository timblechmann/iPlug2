###################################################################################################
# Yoga

add_library(Yoga STATIC
    yoga/yoga/YGFloatOptional.h
    yoga/yoga/Utils.h
    yoga/yoga/CompactValue.h
    yoga/yoga/Yoga-internal.h
    yoga/yoga/YGLayout.h
    yoga/yoga/log.cpp
    yoga/yoga/Utils.cpp
    yoga/yoga/YGNodePrint.h
    yoga/yoga/YGEnums.h
    yoga/yoga/YGLayout.cpp
    yoga/yoga/YGNode.h
    yoga/yoga/YGMacros.h
    yoga/yoga/Yoga.cpp
    yoga/yoga/YGStyle.cpp
    yoga/yoga/Yoga.h
    yoga/yoga/YGNodePrint.cpp
    yoga/yoga/YGStyle.h
    yoga/yoga/YGEnums.cpp
    yoga/yoga/log.h
    yoga/yoga/YGValue.cpp
    yoga/yoga/YGConfig.h
    yoga/yoga/YGConfig.cpp
    yoga/yoga/YGNode.cpp
    yoga/yoga/YGValue.h
    yoga/yoga/event/event.h
    yoga/yoga/event/event.cpp
    yoga/yoga/Bitfield.h
)

target_include_directories(Yoga
    SYSTEM PUBLIC yoga/yoga
                  yoga
)


###################################################################################################
# NanoVG

add_library(NanoVG STATIC
    NanoVG/src/nanovg_gl.h
    NanoVG/src/nanovg.h
    NanoVG/src/stb_image.h
    NanoVG/src/stb_truetype.h
    NanoVG/src/fontstash.h
    NanoVG/src/nanovg_gl_utils.h
    NanoVG/src/nanovg.c
)

target_include_directories(NanoVG
    SYSTEM PUBLIC NanoVG/src
)

###################################################################################################
# MetalNanoVG

if(APPLE)
    enable_language(OBJC)
    add_library(MetalNanoVG STATIC
        MetalNanoVG/src/nanovg_mtl_shaders.metal
        MetalNanoVG/src/nanovg_mtl.m
        MetalNanoVG/src/mnvg_bitcode/ios.h
        MetalNanoVG/src/mnvg_bitcode/tvos.h
        MetalNanoVG/src/mnvg_bitcode/macos.h
        MetalNanoVG/src/mnvg_bitcode/simulator.h
        MetalNanoVG/src/nanovg_mtl.h
    )

    target_compile_options(MetalNanoVG PRIVATE -fobjc-arc)

    target_include_directories(MetalNanoVG
       SYSTEM PUBLIC MetalNanoVG/src
    )

    target_link_libraries(MetalNanoVG PUBLIC NanoVG "-framework Metal")
endif()

###################################################################################################
# NanoSVG

add_library(NanoSVG INTERFACE
    NanoSVG/src/nanosvg.h
    NanoSVG/src/nanosvgrast.h
)

target_include_directories(NanoSVG
    SYSTEM INTERFACE NanoSVG/src
)

###################################################################################################
# STB

add_library(STB INTERFACE
    STB/stb_textedit.h
)

target_include_directories(STB
    SYSTEM INTERFACE STB
)
