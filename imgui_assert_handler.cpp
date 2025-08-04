// HOW TO USE THIS FILE: please see imgui_assert_handler.h

// imgui_assert_handler.cpp
#include "imgui_assert_handler.h"

#include <cstdio>
#include <cstdlib>

static void DefaultAssertCallback(const char* expr, const char* file, int line)
{
    fprintf(stderr, "[IM_ASSERT] %s failed at %s:%d\n", expr, file, line);
    fflush(stderr);
}

static AssertCallbackFn& GetAssertCallback()
{
    static AssertCallbackFn callback = &DefaultAssertCallback;
    return callback;
}

extern "C" void HandleImGuiAssert(const char* expr, const char* file, int line)
{
    auto cb = GetAssertCallback();
    if (cb)
        cb(expr, file, line);
    else
        DefaultAssertCallback(expr, file, line); // fallback en cas d’erreur
}

extern "C" IMGUI_IMPL_API void SetImGuiAssertCallback(AssertCallbackFn callback)
{
    GetAssertCallback() = callback;
}
