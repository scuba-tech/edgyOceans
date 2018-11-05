filter = [0 0 0 0 0 0 0;
        0 0 0 0 0 0 0;
        0 0 0 0 0 0 0;
        -1 -1 -1 6 -1 -1 -1;
        0 0 0 0 0 0 0;
        0 0 0 0 0 0 0;
        0 0 0 0 0 0 0;];
    
nullFilter = [0 0 0 0 0 0 0;
         0 0 0 0 0 0 0;
         0 0 0 0 0 0 0;
         0 0 0 1 0 0 0;
         0 0 0 0 0 0 0;
         0 0 0 0 0 0 0;
         0 0 0 0 0 0 0;];

image = rgb2gray(im2double(imread('boat-test-3.jpg')));
paddedImage = conv2(image,nullFilter);
output = conv2(image,filter);

subplot(2,2,1);
imshow(image);

subplot(2,2,2);
imshow(output);

subplot(2,2,3);
imshow(output + 0.5);

subplot(2,2,4);
imshow(abs(output));
