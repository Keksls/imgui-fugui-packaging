// HOW TO USE THIS FILE:
// 
// 1 - Place this file into cimgui/imgui directory
// 
// 2 - replace IM_ASSERT into imconfig.h  by the following code:
// #include "imgui_assert_handler.h"
// #define IM_ASSERT(_EXPR) do { if (!(_EXPR)) HandleImGuiAssert(#_EXPR, __FILE__, __LINE__); } while(0)
//
// 3 - add the following line into cimgui/CMakeLists.txt after #general settings file()
// list(APPEND IMGUI_SOURCES imgui/imgui_assert_handler.cpp)


// imgui_assert_handler.h
#pragma once
#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void(*AssertCallbackFn)(const char* expr, const char* file, int line);

    // Only declarations here
    IMGUI_IMPL_API void SetImGuiAssertCallback(AssertCallbackFn callback);
    void HandleImGuiAssert(const char* expr, const char* file, int line);

#ifdef __cplusplus
}
#endif
