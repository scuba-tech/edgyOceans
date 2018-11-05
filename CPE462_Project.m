filter7x7 =  [0 0 0 0 0 0 0;
              0 0 0 0 0 0 0;
              0 0 0 0 0 0 0;
              -1 -1 -1 6 -1 -1 -1;
              0 0 0 0 0 0 0;
              0 0 0 0 0 0 0;
              0 0 0 0 0 0 0;];

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
                -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 4 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2 -0.2;
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

image = rgb2gray(im2double(imread('boat-test-1.jpg')));
output7x7 = conv2(image,filter7x7);
output21x21 = conv2(image,filter21x21);

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Row 1

subplot(3,3,1);
imshow(image);
title('Greyscale Image Input')

subplot(3,3,2);
imagesc(im2double(filter7x7));
title('7x7 Filter');
axis equal;


subplot(3,3,3);
imagesc(im2double(filter21x21));
title('21x21 Filter');
axis equal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Row 2:

subplot(3,3,4);
imshow(abs(output7x7));
title('7x7 Laplacian Output')

subplot(3,3,5);
imshow(abs(output7x7));
title('7x7 Scaled-Laplacian Output')


subplot(3,3,6);
imshow(abs(output7x7));
title('7x7 Absolute-Laplacian Output')

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Row 3:

subplot(3,3,7);
imshow(abs(output21x21));
title('21x21 Laplacian Output')

subplot(3,3,8);
imshow(abs(output21x21));
title('21x21 Scaled-Laplacian Output')

subplot(3,3,9);
imshow(abs(output21x21));
title('21x21 Absolute-Laplacian Output')
