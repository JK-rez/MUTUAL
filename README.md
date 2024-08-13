# MUTUAL ROS 2 Foxy
MUTUAL: Towards Holistic Sensing and Inference in the Operating Room

More updates Coming Soon....

The provided scripts serve as a tutorial for setting up a ROS 2-based MUTUAL platform, a multimodal sensing, annotation, storage, streaming, visualisation, and inference platform for surgery. In our experiments, we use **Ubuntu 20.04**-based OSes and **ROS 2 Foxy** for compatibility with some official ROS 2 wrappers provided by sensor manufacturers at the time. If your devices do not have such constraints, newer OSes and ROS 2 distributions should provide better performance.

## ROS 2 Foxy Installation

To install ROS 2 Foxy, please follow this [link](https://docs.ros.org/en/foxy/Installation.html) to ROS 2 Foxy's official documentation where details are provided for specific operating systems.

## About the Tutorial Scripts

The `src` folder includes a ROS 2 publisher node to publish audio signal to the ROS 2 network and a ROS 2 subscriber node that subscribes to the audio signal and saves it to a `.wav` file for playback. There might be multiple audio devices on the machine, hence a third script is also provided to list all of them to find the desired one.

The `scripts` folder contains a example bash script for recording published topics using ROS 2 bag.

## Info on ROS 2 Wrappers

Some sensor manufacturers provide official ROS 2 wrappers for their SDKs. Below are the two wrappers we use and their dependencies. Please note their dependencies are subject to changes. Hence, it is worth following the links embedded in the names to check their GitHub pages for latest updates.

| [ROS Wrapper for Intel(R) RealSense(TM) Cameras](https://github.com/IntelRealSense/realsense-ros) | [ROS 2 packages for using Stereolabs ZED Cameras](https://github.com/stereolabs/zed-ros2-wrapper) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Ubuntu 20.04 (Focal Fossa)](https://releases.ubuntu.com/focal/) or [Ubuntu 22.04 (Jammy Jellyfish)](https://releases.ubuntu.com/jammy/) <br />[Intel® RealSense™ SDK 2.0](https://github.com/IntelRealSense/librealsense/releases/tag/v2.53.1) <br />ROS 2 Foxy, Humble, or Iron: <br />[Foxy on Ubuntu 20.04](https://docs.ros.org/en/foxy/Installation/Linux-Install-Debians.html)<br />[Humble on Ubuntu 22.04](https://docs.ros.org/en/humble/Installation/Linux-Install-Debians.html)<br />[Iron on Ubuntu 22.04](https://docs.ros.org/en/iron/Installation/Ubuntu-Install-Debians.html) | [Ubuntu 20.04 (Focal Fossa)](https://releases.ubuntu.com/focal/) or [Ubuntu 22.04 (Jammy Jellyfish)](https://releases.ubuntu.com/jammy/)<br />[ZED SDK](https://www.stereolabs.com/developers/release/latest/) v4.1 (for older versions support please check the [releases](https://github.com/stereolabs/zed-ros2-wrapper/releases))<br />[CUDA](https://developer.nvidia.com/cuda-downloads) dependency <br />ROS 2 Foxy or Humble: <br />[Foxy on Ubuntu 20.04](https://docs.ros.org/en/foxy/Installation/Linux-Install-Debians.html)<br />[Humble on Ubuntu 22.04](https://docs.ros.org/en/humble/Installation/Linux-Install-Debians.html) |

### Note for Nvidia Clara/Jetson Users

Nvidia Clara/Jetson devices use JetPack OS, which is a special OS based on Ubuntu Linux. Some sensor manufacturers provide specific SDKs for such OSes. For example, the [Intel RealSense SDK - Installation on Jetson](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation_jetson.md) and the [Stereolabs ZED SDK](https://www.stereolabs.com/en-gb/developers/release#nvidia-jetson-504616ef8d38) (See `NVIDIA Jetson` section).

### Compression

By utilising the image-transport module in ROS 2, RealSense and ZED cameras', we can have compressed publisher topics. On Ubuntu Linux, image-transport can be installed using `sudo apt install ros-<distro>-image-transport`. At the time of the experiments, ROS 2 Foxy does not provide compatibility with this compression feature. 
