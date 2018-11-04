filter = [0 0 0 0 0 0 0;
        0 0 0 0 0 0 0;
        0 0 0 0 0 0 0;
        -0.005 -0.005 -0.005 0.03 -0.005 -0.005 -0.005;
        0 0 0 0 0 0 0;
        0 0 0 0 0 0 0;
        0 0 0 0 0 0 0;];

image = imread('boat-test-3.jpg');
image = rgb2gray(image);
Y = conv2(image,filter);
imshow(Y);