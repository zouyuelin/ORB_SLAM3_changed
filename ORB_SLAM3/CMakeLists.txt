cmake_minimum_required(VERSION 2.8)
project(ORB_SLAM3 CXX)

SET(CMAKE_BUILD_TYPE Release)

MESSAGE("Build type: " ${CMAKE_BUILD_TYPE})

set(CMAKE_CXX_COMPILER "clang++")
#set(CMAKE_CXX_COMPILER "g++")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -Wall -std=c++14  -O3")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++14  -O3")
#set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -march=native")
#set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -march=native")

# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-deprecated -O3 -march=native ")
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-deprecated -O3 -march=native")

# Check C++11 or C++0x support
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
ADD_COMPILE_OPTIONS(-std=c++14 )
LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake_modules)

find_package(OpenCV 4.5.1)
if(NOT OpenCV_FOUND)
  find_package(OpenCV 3.0)
  if(NOT OpenCV_FOUND)
    message(FATAL_ERROR "OpenCV > 3.0 not found.")
  endif()
endif()

MESSAGE("OPENCV VERSION:")
MESSAGE(${OpenCV_VERSION})

find_package(Eigen3 3.1.0 REQUIRED)
find_package(Pangolin REQUIRED)
find_package(realsense2)
find_package( G2O REQUIRED )
find_package( PCL REQUIRED )

include_directories(
${PROJECT_SOURCE_DIR}
${PROJECT_SOURCE_DIR}/include
${PROJECT_SOURCE_DIR}/include/CameraModels
${EIGEN3_INCLUDE_DIR}
${PCL_INCLUDE_DIRS}
${Pangolin_INCLUDE_DIRS}
${G2O_INCLUDE_DIR}
)
add_definitions( ${PCL_DEFINITIONS} )
link_directories( ${PCL_LIBRARY_DIRS} ${Boost_LIBRARIES} )
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)

add_library(${PROJECT_NAME} SHARED
src/System.cc
src/Tracking.cc
src/LocalMapping.cc
src/LoopClosing.cc
src/ORBextractor.cc
src/ORBmatcher.cc
src/FrameDrawer.cc
src/Converter.cc
src/MapPoint.cc
src/KeyFrame.cc
src/Atlas.cc
src/Map.cc
src/MapDrawer.cc
src/Optimizer.cc
src/Frame.cc
src/KeyFrameDatabase.cc
src/Sim3Solver.cc
src/Initializer.cc
src/Viewer.cc
src/ImuTypes.cc
src/G2oTypes.cc
src/CameraModels/Pinhole.cpp
src/CameraModels/KannalaBrandt8.cpp
src/OptimizableTypes.cpp
src/MLPnPsolver.cpp
src/TwoViewReconstruction.cc
src/pointcloudmapping.cc
include/System.h
include/Tracking.h
include/LocalMapping.h
include/LoopClosing.h
include/ORBextractor.h
include/ORBmatcher.h
include/FrameDrawer.h
include/Converter.h
include/MapPoint.h
include/KeyFrame.h
include/Atlas.h
include/Map.h
include/MapDrawer.h
include/Optimizer.h
include/Frame.h
include/KeyFrameDatabase.h
include/Sim3Solver.h
include/Initializer.h
include/Viewer.h
include/ImuTypes.h
include/G2oTypes.h
include/CameraModels/GeometricCamera.h
include/CameraModels/Pinhole.h
include/CameraModels/KannalaBrandt8.h
include/OptimizableTypes.h
include/MLPnPsolver.h
include/TwoViewReconstruction.h
include/Config.h
include/pointcloudmapping.h
)

#add_subdirectory(Thirdparty/g2o)

target_link_libraries(${PROJECT_NAME}
${OpenCV_LIBS}
${EIGEN3_LIBS}
${PCL_LIBRARIES}
${Pangolin_LIBRARIES}
g2o_core g2o_types_slam3d g2o_solver_csparse g2o_stuff g2o_csparse_extension g2o_types_sim3 g2o_types_sba
${PROJECT_SOURCE_DIR}/Thirdparty/DBoW2/lib/libDBoW2.so
#${PROJECT_SOURCE_DIR}/Thirdparty/g2o/lib/libg2o.so
-lboost_serialization
-lcrypto
)


### Build examples

# RGB-D examples
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/RGB-D)

add_executable(rgbd_tum
Examples/RGB-D/rgbd_tum.cc)
target_link_libraries(rgbd_tum ${PROJECT_NAME})


# Stereo examples
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Stereo)

add_executable(stereo_kitti
Examples/Stereo/stereo_kitti.cc)
target_link_libraries(stereo_kitti ${PROJECT_NAME})

add_executable(stereo_euroc
Examples/Stereo/stereo_euroc.cc)
target_link_libraries(stereo_euroc ${PROJECT_NAME})

add_executable(stereo_tum_vi
Examples/Stereo/stereo_tum_vi.cc)
target_link_libraries(stereo_tum_vi ${PROJECT_NAME})

# Monocular examples
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Monocular)

add_executable(mono_tum
Examples/Monocular/mono_tum.cc)
target_link_libraries(mono_tum ${PROJECT_NAME})

add_executable(mono_kitti
Examples/Monocular/mono_kitti.cc)
target_link_libraries(mono_kitti ${PROJECT_NAME})

add_executable(mono_euroc
Examples/Monocular/mono_euroc.cc)
target_link_libraries(mono_euroc ${PROJECT_NAME})

add_executable(mono_tum_vi
Examples/Monocular/mono_tum_vi.cc)
target_link_libraries(mono_tum_vi ${PROJECT_NAME})

# Monocular-Inertial examples
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Monocular-Inertial)

add_executable(mono_inertial_euroc
Examples/Monocular-Inertial/mono_inertial_euroc.cc)
target_link_libraries(mono_inertial_euroc ${PROJECT_NAME})

add_executable(mono_inertial_tum_vi
Examples/Monocular-Inertial/mono_inertial_tum_vi.cc)
target_link_libraries(mono_inertial_tum_vi ${PROJECT_NAME})

# Stereo-Inertial examples
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Stereo-Inertial)

add_executable(stereo_inertial_euroc
Examples/Stereo-Inertial/stereo_inertial_euroc.cc)
target_link_libraries(stereo_inertial_euroc ${PROJECT_NAME})

add_executable(stereo_inertial_tum_vi
Examples/Stereo-Inertial/stereo_inertial_tum_vi.cc)
target_link_libraries(stereo_inertial_tum_vi ${PROJECT_NAME})

