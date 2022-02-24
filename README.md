# ORB_SLAM3 点云重建
首先构建g2o,使用 make install 
再次在ORB_SLAM3中利用 build.sh 和 build_ros.sh文件构建项目

# 运行
```shell
roscore
rosrun RGBD_camera camera_RGBD_node
rosrun ORB_SLAM3 RGBD Vocabulary/ORBvoc.txt configYaml/intel_RGBD.yaml
```
其中RGBD_camera ros功能包链接为：
https://github.com/zouyuelin/ORB_SLAM2_changed
