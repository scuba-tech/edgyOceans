# edgyOceans

* * *

## Overview

Image Processing class project to experiment with obstacle detection and collision avoidance at sea by comparing and contrasting both edge-detect-based angular classification with the other approach of using directional impulse-response filters. Code will be a mismash of C++, MATLAB (hopefully Octave by the time we're done), and sloppy Python. 

AUTHORS:  C.D., P.B.
LICENSING: GNU GPL v.3  (TLDR: do what you like, we appreciate credit, keep everything FOSS)

* * *

## Problem

For an Autonomous Surface Vehicle (ASV), detecting and avoiding objects while in motion is a challenge that must be addressed for the vehicle to operate properly. Distinguishing objects such as other vessels and debris will make it possible for the ship’s onboard navigation to avoid them. Currently, solutions exists with the use of OpenCV1 and extension integrations such as YOLO2, however these solutions consume a relatively high amount of computing power, and thus electrical power. For a sense of context, a small solar-powered autonomous vessel such as the RoBoat3 project would have more power dedicated to computer vision than propulsion! 

* * *

## Approach

It is hypothesized by our group that the time-averaged majority of high-contrast edges when out in the high seas are oriented relatively close to a horizontal angle. Conversely, it is hypothesized that many potential obstacles to an autonomous vessel at sea would consist of edges at or near a vertical angle. Some examples of such obstacles could include another ship, lighthouse, cliffs, etc. By the use of edge-detection with angular classification and density mapping, we can construct a rudimentary obstacle map for any image frame. 

* * *

## Tools

A USB camera and computer will be required to perform this task. To process the images taken by the camera, the group intends to use MATLAB4 for the primary processing algorithm and may use Python or Bash scripting if necessary to transfer or further process data. 

* * *

## Tasks

Both group members will work to implement the edge detection algorithm. After the image is segmented, an angle between the center of the image and the object will need to be calculated in order to provide useful data back to the control and navigation system. From there, edge distances (centroid or otherwise) will be used to provide a density map of edges matching preset angle rules for obstacle map generation, for potential use in issuing corrective steering vectors. 
1. https://opencv.org/  
2. https://pjreddie.com/darknet/yolo/ 
3. https://sites.google.com/stevens.edu/ro-boat/home  
4. https://www.mathworks.com/products/matlab.html  
