
% Reading the image file
img = imread("peppers.png");
original_size = size(img);
% original_size(1) = number of rows = the hight of the image in pixels
% original_size(2) = number of columns = the width of the image in pixels
% original_size(3) = number of color components = 3 {R, G, B}

% Extracting color components.
red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);

zero_matrix = zeros(size(red));

Red_image= cat(3, red, zero_matrix, zero_matrix);
Green_image = cat(3, zero_matrix, green, zero_matrix);
Blue_image = cat(3, zero_matrix, zero_matrix, blue);

% Display color components
figure;
imshow(img);
title('Original Image');
figure;
subplot(1, 3, 1);
imshow(Red_image);
title('Red component of the Image');
subplot(1, 3, 2);
imshow(Green_image);
title('Green component of the Image');
subplot(1, 3, 3);
imshow(Blue_image);
title('Blue component of the Image');



%%%  Edge detection  %%%

edge_Kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1]/256;  % Laplacian

edges_red = conv2(red, edge_Kernel, 'same') /256;
edges_green = conv2(green, edge_Kernel, 'same') /256;
edges_blue = conv2(blue, edge_Kernel, "same") /256;

final_edge = cat(3, edges_red, edges_green, edges_blue) ;

figure;
imshow(final_edge);
title('Edge-detected Image');



%%%  Image sharpening  %%%

sharpeningKernel = [-1 -1 -1; -1 9 -1; -1 -1 -1]/256;

sharpened_red = conv2(red, sharpeningKernel, 'same') /256;
sharpened_green = conv2(green, sharpeningKernel, 'same') /256;
sharpened_blue = conv2(blue, sharpeningKernel, 'same') /256;

final_sharpened = cat(3, sharpened_red, sharpened_green, sharpened_blue);

figure;
imshow(final_sharpened);
title('Sharpened Image');



%%%  Blurring  %%%

blurring_Kernel = ones(10, 10) / (100*256); 
% a matrix of ones it's order 10*10, divided by the number of elements in the matrix (average)

blurred_Red = conv2(red, blurring_Kernel, 'same') /256;
blurred_Green = conv2(green, blurring_Kernel, 'same') /256;
blurred_Blue = conv2(blue, blurring_Kernel, 'same') /256;

final_blurred = cat (3, blurred_Red, blurred_Green, blurred_Blue);

figure;
imshow(final_blurred);
title('Blurred Image');



%%%   Motion blurring in the horizontal direction   %%%

motion_blurring_Kernel = ones(1, 25) / (25*256);

motion_blurred_Red = conv2(red, motion_blurring_Kernel) /256;
motion_blurred_Green = conv2(green, motion_blurring_Kernel) /256;
motion_blurred_Blue = conv2(blue, motion_blurring_Kernel) /256;

final_motion_blurred = cat(3, motion_blurred_Red, motion_blurred_Green, motion_blurred_Blue);

% Resizing the motion-blurred image
excess_columns = ( size(final_motion_blurred, 2) - original_size(2) ) /2 ; % number of the excess columns on each side.
final_motion_blurred = final_motion_blurred (:, (excess_columns +1):(original_size(2) + excess_columns), :);

figure;
imshow(final_motion_blurred);
title('Motion-Blurred Image in the horizontal direction');



%%%   Restoring the original image from the motion-blurred image   %%%

FFT_motion_blurred_Red = fft2(motion_blurred_Red) ;
FFT_motion_blurred_Green = fft2(motion_blurred_Green) ;
FFT_motion_blurred_Blue = fft2(motion_blurred_Blue) ;

FFT_motion_bluring_Kernel = fft2( motion_blurring_Kernel, size(motion_blurred_Red, 1), size(motion_blurred_Red, 2)) *256;

FFT_Red = FFT_motion_blurred_Red ./ FFT_motion_bluring_Kernel;
FFT_Green = FFT_motion_blurred_Green ./ FFT_motion_bluring_Kernel;
FFT_Blue = FFT_motion_blurred_Blue ./ FFT_motion_bluring_Kernel;

restored_Red = ifft2(FFT_Red);
restored_Green = ifft2(FFT_Green);
restored_Blue = ifft2(FFT_Blue);

final_restored = cat(3, restored_Red, restored_Green, restored_Blue);

% Resizing the restored image
final_restored = final_restored (:, 1:original_size(2) , :);

figure
imshow(final_restored);
title('Restored Image');
