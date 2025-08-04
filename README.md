# To Update to the latest cimgui version

1. git submodule update --init
2. git submodule update --remote
3. Update the version in version.json file
4. and then git commit + push.



# To Trigger a release push a tag as shown below

2. git tag -a v1.4 -m "my version 1.4"
3. git push origin v1.4



// HOW TO USE THIS FILE:

// 

// 1 - Place this file into cimgui/imgui directory

// 

// 2 - replace IM\_ASSERT into imconfig.h  by the following code:

// #include "imgui\_assert\_handler.h"

// #define IM\_ASSERT(\_EXPR) do { if (!(\_EXPR)) HandleImGuiAssert(#\_EXPR, \_\_FILE\_\_, \_\_LINE\_\_); } while(0)

//

// 3 - add the following line into cimgui/CMakeLists.txt after #general settings file()

// list(APPEND IMGUI\_SOURCES imgui/imgui\_assert\_handler.cpp)



