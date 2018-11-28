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
% Filter Block:

%{
TODO:
3. Angle calculation
4. Focal length Input
5. Web hosting
6. Update report:  components, usage results
%}


filterRoberts1    = [-1 0;
                      0 1];

filterRoberts2    = [0 -1;
                     1  0];

filterPrewittVert = [-1 0 1;
                     -1 0 1;
                     -1 0 1;];

filterSobelVert   = [-1 0 1;
                     -2 0 2;
                     -1 0 1];

filterLaplacian   = [ 0 -1  0;
                     -1  4 -1;
                      0 -1  0];

%{
this filter is too weak, testing stronger filter
filterGaussian    = [0      0.125  0;
                     0.125  0.5    0.125;
                     0      0.125  0;];
%}
filterGaussian    = [1  4  7  4  1;
                     4 16 26 16  4;
                     7 26 41 26  7;
                     4 16 26 16  4;
                     1  4  7  4  1;]/273;
filterLoG         = conv2(filterLaplacian, filterGaussian);

filterLoGVert     = conv2(filterPrewittVert, filterGaussian);

border = 10; %pixels to remove for border created by convolutions

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Block:

[fileName,pathName] = uigetfile({'*.jpg; *.png', 'Image Files (*.jpg, *.png)'},'Please Choose an Image');
if isequal(fileName,0)
   disp('No file chosen!');
   quit;
else
   disp(['Image selected: ', fullfile(pathName,fileName)]);
end

imageColor = imread(fullfile(pathName, fileName));
image = rgb2gray(im2double(imageColor));
%image = rgb2gray(im2double(imread(fullfile(pathName, fileName))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Processing Block:

outputRoberts   = abs(conv2(image,filterRoberts1));
outputRoberts   = outputRoberts + abs(conv2(image,filterRoberts2));

outputVertEdge  = abs(conv2(image,filterPrewittVert));

outputLaplacian = abs(conv2(image,filterLaplacian));

outputGaussian  = abs(conv2(image,filterGaussian));

outputLoG       = abs(conv2(image,filterLoG));

outputLoGVert   = abs(conv2(image,filterLoGVert));

threshold = (2*graythresh(image) + 8*graythresh(outputLoGVert))/10; %set threshold level
outputThresholding = imbinarize(outputLoGVert, threshold); %binarize image
[width, height] = size(outputThresholding); %obtain width and height of output
%next 4 lines: set border pixels to 0 to compensate for convolution
outputThresholding(1:10,:) = 0;
outputThresholding((width-border):width,:) = 0;
outputThresholding(:,1:border) = 0;
outputThresholding(:,(height-border):height) = 0;

% outputThresholding = medfilt2(outputThresholding,[7 3]);
% ^ median-filter for threshold to eliminate small artifacts and fill-in gaps
% the 7x3 is a vertically-oriented rectangular median filter to eliminate more
% of the horizontal artifacts and fill-in more vertical artifacts
 outputThresholding = medfilt2(outputThresholding,[3 3]);
% ^ this iteration is to get rid of any remaining symmetrical artifacts
% changes as of 28 November: commented-out 2nd median filter, changed
% threshold from "outputLogVert" to "image" (line ~ 101)


%TODO: FINISH Blobbing
profileVertical = any(outputThresholding > 0,1);
profileHorizontal = any(outputThresholding > 0,2);
xLeft   = find(profileVertical,   1, 'first');
xRight  = find(profileVertical,   1, 'last');
yTop = find(profileHorizontal, 1, 'first');
yBottom    = find(profileHorizontal, 1, 'last');


%TODO: Angle calculation
outputAngle = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display Block:

% Row 1:

subplot(3,3,1);
imshow(image);
title('Greyscale Image Input');
imwrite(image, 'Output-1-Greyscale.png');


subplot(3,3,2);
imshow(outputRoberts);
title('Roberts Omnidirectional Edge Detection');
imwrite(outputRoberts, 'Output-2-Roberts.png');

subplot(3,3,3);
imshow(outputVertEdge);
title('Vertical Edge Detection'); %TODO: test Prewitt -vs- Sobel  (see lect.8)
imwrite(outputVertEdge, 'Output-3-VerticalEdgeDetection.png');

% Row 2:

subplot(3,3,4);
imshow(outputLaplacian);
title('Laplacian Edge Detection');
imwrite(outputLaplacian, 'Output-4-Laplacian3x3.png');

subplot(3,3,5);
imshow(outputLoG);
title('Laplacian of Gaussian (LoG)');
imwrite(outputLoG, 'Output-5-LoG.png');


subplot(3,3,6);
imshow(outputLoGVert);
title('Vertical-Edge-Biased LoG (Vertical Edge filter convolved with Gaussian)');%TODO: convolve vertical w/ Gaussian
imwrite(outputLoGVert, 'Output-6-LoGVert.png');

% Row 3:

subplot(3,3,7);
imshow(outputThresholding);
title('Thresholding'); %TODO: test graythresh() and imbinarize()
imwrite(outputThresholding, 'Output-7-Thresholding.png');

subplot(3,3,8);
title('Blobbing Output');
%imwrite(outputThresholding, 'Output-8-Blobbing.png');
imshow(outputThresholding);
rectangle('Position',[xLeft yTop (xRight-xLeft) (yBottom-yTop)],'EdgeColor','r');
%rectangle('Position',[((xLeft-xRight)/2 + 2) ((yBottom-yTop)/2 + 2) ((xLeft-xRight)/2 - 2) ((yBottom-yTop)/2 - 2)],'FaceColor','red');

subplot(3,3,9);
% TODO: find conservative angle from blob
title('Obstacle Solution Angle');
imshow(imageColor);
rectangle('Position',[xLeft yTop (xRight-xLeft) (yBottom-yTop)],'EdgeColor','r');
%imwrite(outputAngle, 'Output-9-XXXXXXXXXXXXXXXXXXX.png'); TODO: find way to write angle to text file
