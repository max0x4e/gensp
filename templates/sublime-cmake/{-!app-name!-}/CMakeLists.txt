cmake_minimum_required (VERSION {-!cmake-minimal-version!-})

# set useful CMAKE variables
set(CMAKE_C_COMPILER "{-!cmake-c-compiler!-}")
set(CMAKE_CXX_COMPILER "{-!cmake-cxx-compiler!-}")
set(CMAKE_C_FLAGS_DEBUG "{-!cmake-c-flags-debug!-}")
set(CMAKE_C_FLAGS_RELEASE "{-!cmake-c-flags-release!-}")
set(CMAKE_CXX_FLAGS_DEBUG "{-!cmake-cxx-flags-debug!-}")
set(CMAKE_CXX_FLAGS_RELEASE "{-!cmake-cxx-flags-release!-}")

project ({-!App-name!-})

# set version number
set ({-!App-name!-}_VERSION_MAJOR {-!app-initial-major-version!-})
set ({-!App-name!-}_VERSION_MINOR {-!app-initial-minor-version!-})

# add configure file
configure_file (
  "${PROJECT_SOURCE_DIR}/{-!App-name!-}Config.h.in"
  "${PROJECT_BINARY_DIR}/{-!App-name!-}Config.h"
  )

# add the binary tree to the search path for include files
# so that we will find {-!App-name!-}Config.h
include_directories("${PROJECT_BINARY_DIR}")

# define options
option (BUILD_STATIC_LIBRARY "Generate static library" OFF) 
option (BUILD_TESTS "Build all tests." OFF)

# setup library to be generated and installed
if (BUILD_SHARED_LIBS)
	add_executable({-!app-executable-name!-} ${PROJECT_SOURCE_DIR}/src/{-!app-name!-}.c)
	add_library({-!app-library-name!-} ${PROJECT_SOURCE_DIR}/src/{-!app-name!-}_lib.c)
	install (TARGETS {-!app-library-name!-} DESTINATION lib)
	install (DIRECTORY ${PROJECT_SOURCE_DIR}/include/ DESTINATION include)
	install (FILES ${PROJECT_BINARY_DIR}/{-!App-name!-}Config.h DESTINATION include)
elseif (BUILD_STATIC_LIBRARY)
    add_executable({-!app-executable-name!-} ${PROJECT_SOURCE_DIR}/src/{-!app-name!-}.c)
	add_library({-!app-library-name!-} ${PROJECT_SOURCE_DIR}/src/{-!app-name!-}_lib.c)
    install (TARGETS {-!app-library-name!-} DESTINATION lib)
    install (DIRECTORY ${PROJECT_SOURCE_DIR}/include/ DESTINATION include)
	install (FILES ${PROJECT_BINARY_DIR}/{-!App-name!-}Config.h DESTINATION include)
else (BUILD_SHARED_LIBS)
	add_executable({-!app-executable-name!-} ${PROJECT_SOURCE_DIR}/src/{-!app-name!-}.c)
	install (TARGETS {-!app-executable-name!-} DESTINATION bin)
endif (BUILD_SHARED_LIBS)

# define tests
include(CTest)

# Run google tests
if (BUILD_TESTS)
	ADD_SUBDIRECTORY (googletest)
	enable_testing()
	include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})
	add_executable( runUnitTests ${PROJECT_SOURCE_DIR}/src/testgtest.cpp )
	target_link_libraries(runUnitTests gtest gtest_main pthread)
	add_test( runUnitTests runUnitTests )
endif (BUILD_TESTS)
