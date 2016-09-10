cmake_minimum_required (VERSION 3.0)
project(CoYield C)

SET(LIBRARY_OUTPUT_PATH  ${PROJECT_SOURCE_DIR}/IronBox)

add_library (${PROJECT_NAME} SHARED c_src/CoYield.c)
# find luajit library and then lua5.1 if luajit is not found
find_library(LUA_LIB NAMES luajit-5.1 luajit51 luajit lua51 lua5.1 lua-5.1)
target_link_libraries (${PROJECT_NAME} ${LUA_LIB})
set_target_properties (${PROJECT_NAME} PROPERTIES PREFIX "")

if (WIN32)
	if( CMAKE_SIZEOF_VOID_P EQUAL 8 )
		add_custom_command(TARGET ${PROJECT_NAME} PRE_LINK
			COMMAND ${CMAKE_COMMAND} -E copy_if_different
			"${CMAKE_CURRENT_SOURCE_DIR}/c_src/lib/lua51-64.lib"
			"${CMAKE_CURRENT_BINARY_DIR}/lua51.lib")
	elseif( CMAKE_SIZEOF_VOID_P EQUAL 4 )
		add_custom_command(TARGET ${PROJECT_NAME} PRE_LINK
			COMMAND ${CMAKE_COMMAND} -E copy_if_different
			"${CMAKE_CURRENT_SOURCE_DIR}/c_src/lib/lua51.lib"
			"${CMAKE_CURRENT_BINARY_DIR}/lua51.lib")
	endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )
endif(WIN32)
