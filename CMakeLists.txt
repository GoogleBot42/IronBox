cmake_minimum_required(VERSION 2.8)
CMAKE_POLICY( SET CMP0046 OLD )

project (CoYield)
set(CMAKE_BUILD_TYPE Release)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_library(CoYield SHARED main.c)
ADD_DEPENDENCIES(CoYield lua)
