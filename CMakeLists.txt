cmake_minimum_required (VERSION 3.0)
project(CoYield C)

SET(LIBRARY_OUTPUT_PATH  ${PROJECT_SOURCE_DIR}/IronBox)

add_library (${PROJECT_NAME} SHARED c_src/CoYield.c)
target_link_libraries (${PROJECT_NAME} lua51)
set_target_properties (${PROJECT_NAME} PROPERTIES PREFIX "")

if (WIN32)
	if( CMAKE_SIZEOF_VOID_P EQUAL 8 )
		add_custom_command(TARGET ${PROJECT_NAME} PRE_LINK
			COMMAND ${CMAKE_COMMAND} -E copy_if_different
			"${CMAKE_CURRENT_SOURCE_DIR}/lib/lua51-64.lib"
			"${CMAKE_CURRENT_BINARY_DIR}/lua51.lib")
	else( CMAKE_SIZEOF_VOID_P EQUAL 8 )
		add_custom_command(TARGET ${PROJECT_NAME} PRE_LINK
			COMMAND ${CMAKE_COMMAND} -E copy_if_different
			"${CMAKE_CURRENT_SOURCE_DIR}/lib/lua51.lib"
			"${CMAKE_CURRENT_BINARY_DIR}/lua51.lib")
	endif( CMAKE_SIZEOF_VOID_P EQUAL 8 )
endif(WIN32)