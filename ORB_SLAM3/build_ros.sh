echo "Building ROS nodes"
conda activate
cd Examples/ROS/ORB_SLAM3
mkdir build
cd build
cmake .. -DROS_BUILD_TYPE=Release
make -j

