cmake_minimum_required (VERSION 3.0)
project(CoYield C)
 
find_package(Lua REQUIRED)
 
add_library (${PROJECT_NAME} SHARED CoYield.c)
target_link_libraries (${PROJECT_NAME} lua)
set_target_properties (${PROJECT_NAME} PROPERTIES PREFIX "")