cmake_minimum_required(VERSION 3.0)
CMAKE_POLICY( SET CMP0046 OLD )

project (CoYield)
set(CMAKE_BUILD_TYPE Release)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_library(CoYield SHARED CoYield.c)
ADD_DEPENDENCIES(CoYield lua)
