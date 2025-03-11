clc; clear; close all;
% Load and Preprocess the Image
% Load Image
[file, path] = uigetfile('*.jpg', 'Select a Vehicle Image');
img = imread(fullfile(path, file));

% Convert to Grayscale
gray_img = rgb2gray(img);

% Enhance Contrast
enhanced_img = imadjust(gray_img);

% Display Result
figure; imshow(enhanced_img); title('Enhanced Image');



% License Plate Detection
% Apply Edge Detection
edges = edge(enhanced_img, 'sobel');

% Morphological Processing
se = strel('rectangle', [5 5]); % Structuring element
dilated_img = imdilate(edges, se);
filled_img = imfill(dilated_img, 'holes');

% Find Connected Components
[L, num] = bwlabel(filled_img);
stats = regionprops(L, 'BoundingBox', 'Area');

% Filter Based on Area
min_area = 2000; % Adjust this value as needed
for i = 1:num
    if stats(i).Area > min_area
        bbox = stats(i).BoundingBox;
        plate_img = imcrop(enhanced_img, bbox);
        figure; imshow(plate_img); title('Detected License Plate');
    end
end


% Character Segmentation
% Convert to Binary
binary_plate = imbinarize(plate_img);

% Remove Small Objects
binary_plate = bwareaopen(binary_plate, 100);

% Label Characters
[L, num] = bwlabel(binary_plate);
stats = regionprops(L, 'BoundingBox');

% Display Segmented Characters
figure; imshow(binary_plate); title('Segmented Characters');
hold on;
for i = 1:num
    bbox = stats(i).BoundingBox;
    rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
end
hold off;

%Character Recognition using OCR
% Apply OCR
results = ocr(binary_plate);

% Display Recognized Text
recognized_text = results.Text;
disp(['License Plate: ', recognized_text]);

