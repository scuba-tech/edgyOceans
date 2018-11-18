%{
EdgyOceans: Vertical Edge detection for Obstacle Avoidance... at sea!
Copyright (C) 2018  C. Drew and P. Brine
cdrew2@stevens.edu  pbrine@stevens.edu

GNU GPL v.3

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
NO WARRANTY IS IMPLIED NOR LIABILITY FOR ANY PURPOSE ACCEPTED.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: Vertical edge detection |==> "Horizontal Frequency"

% Setting up small filters for test battery:

%{
  filter7x7 =  [0 0 0 0 0 0 0; %first attempt
                0 0 0 0 0 0 0;
                0 0 0 0 0 0 0;
                -1 -1 -1 6 -1 -1 -1;
                0 0 0 0 0 0 0;
                0 0 0 0 0 0 0;
                0 0 0 0 0 0 0;];

                %}
filter3x3EdgeDetection = [-1 0 1;
                          -1 0 1;
                          -1 0 1];

filter7x7HorizontalFrequency =  [0 0 -1 2 -1 0 0;
                                 0 0 -1 2 -1 0 0;
                                 0 0 -1 2 -1 0 0;
                                 0 0 -1 2 -1 0 0;
                                 0 0 -1 2 -1 0 0;
                                 0 0 -1 2 -1 0 0;
                                 0 0 -1 2 -1 0 0;];

filter7x7EdgeDetection = [-0.1 -0.1 -1 0 1 0.1 0.1;
                          -0.1 -0.1 -1 0 1 0.1 0.1;
                          -0.1 -0.1 -1 0 1 0.1 0.1;
                          -0.1 -0.1 -1 0 1 0.1 0.1;
                          -0.1 -0.1 -1 0 1 0.1 0.1;
                          -0.1 -0.1 -1 0 1 0.1 0.1;
                          -0.1 -0.1 -1 0 1 0.1 0.1;];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting up 21x21 filters for test battery:

%{
 filter21x21 =  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 4 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2  -0.2 -0.2;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
                 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;];
                 %}

%Larger filter for vertical edge detection
filter21x21HorizontalFrequency =  [0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;
                0 0 0 0 0 0 0 0 0 -0.2 0.4 -0.2 0 0 0 0 0 0 0 0 0;];

filter21x21EdgeDetection = [0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0 0 0 -0.4 0 0.4 0 0 0 0 0 0 0 0 0;];


%{
wanna test this filter at some point: (magnitude may be too high)
0     0     0     0     0     0     0     0     0
0     0     1    -4     6    -4     1     0     0
0     0     1    -4     6    -4     1     0     0
0     0     1    -4     6    -4     1     0     0
0     0     1    -4     6    -4     1     0     0
0     0     1    -4     6    -4     1     0     0
0     0     1    -4     6    -4     1     0     0
0     0     1    -4     6    -4     1     0     0
0     0     0     0     0     0     0     0     0

convolution between:

filter3x3 =

     0     0     0
    -1     2    -1
     0     0     0

and

filter7x7 =

     0     0    -1     2    -1     0     0
     0     0    -1     2    -1     0     0
     0     0    -1     2    -1     0     0
     0     0    -1     2    -1     0     0
     0     0    -1     2    -1     0     0
     0     0    -1     2    -1     0     0
     0     0    -1     2    -1     0     0
%}

image = rgb2gray(im2double(imread('boat-test-3.jpg')));
%output7x7 = conv2(image,filter7x7);
%output21x21 = conv2(image,filter21x21);

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Row 1

subplot(3,3,1);
imshow(image);
title('Greyscale Image Input');

subplot(3,3,2);
%imagesc(im2double(filter7x7));
%title('7x7 Horizontal Frequency');
%axis equal;
imshow(abs(conv2(image,filter7x7HorizontalFrequency)));
title('7x7 Horizontal Frequency');

imwrite(abs(conv2(image,filter7x7HorizontalFrequency)), '7x7HorizontalFrequency.png');


subplot(3,3,3);
%imagesc(im2double(filter21x21));
%title('21x21 Filter');
%axis equal;
imshow(abs(conv2(image,filter7x7EdgeDetection)));
title('7x7 Edge Detection');

imwrite(abs(conv2(image,filter7x7EdgeDetection)), '7x7EdgeDetection.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Row 2:

subplot(3,3,4);
%imshow(abs(output7x7));
%title('7x7 Laplacian Output')
imshow(abs(conv2(image,filter3x3EdgeDetection)));
title('3x3 Edge Detection');

imwrite(abs(conv2(image,filter3x3EdgeDetection)), '3x3EdgeDetection.png');

subplot(3,3,5);
imshow(abs(output7x7));
title('7x7 Scaled-Laplacian Output');


subplot(3,3,6);
imshow(abs(output7x7));
title('7x7 Absolute-Laplacian Output');

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Row 3:

subplot(3,3,7);
imshow(abs(output21x21));
title('21x21 Laplacian Output');

subplot(3,3,8);
imshow(abs(output21x21));
title('21x21 Scaled-Laplacian Output');

subplot(3,3,9);
imshow(abs(output21x21));
title('21x21 Absolute-Laplacian Output');
