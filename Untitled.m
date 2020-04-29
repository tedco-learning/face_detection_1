%     subject    : face detection
%     programmer : Reza Tanaki Zadeh
%     date       : April 2020
%     article    : is in source file`s folder

clear
% ------------------------------------------------------
% read image and resize it
rgbImage = imread('pic.png'); % Get image from file
rgbImage = imresize(rgbImage,[160 120]);
% -------------------end-------------------------------



% ------------------------------------------------------
%make lum average
redChannel = rgbImage(:,:,1);
redmean = mean(mean(redChannel));

greenChannel = rgbImage(:,:,2);
greenmean = mean(mean(greenChannel));

blueChannel = rgbImage(:,:,3);
bluenmean = mean(mean(blueChannel));

k = (redmean + greenmean + bluenmean)/3;

R = redChannel * (k/redmean);
G = greenChannel * (k/greenmean);
B = blueChannel * (k/bluenmean);

rgbImagefinal = cat(3, R, G, B);
% -------------------end-------------------------------



% ------------------------------------------------------
% segmented image in HSV and RGB
hsv2 = rgb2hsv(rgbImagefinal); % Convert image, not string
image = rgbImagefinal;
for c = 1:160
    for r = 1:120
        if ((hsv2(c,r,2) >= 0.2 || hsv2(c,r,2) <= 0.6) && ...
           ((hsv2(c,r,1) >= 0 && hsv2(c,r,1) <= 0.06) || (hsv2(c,r,1) >= 0.9 && hsv2(c,r,1) <= 1)) && ...
           (hsv2(c,r,3) >= 0.4)) || ...
           (image(c,r,1) >= 95 && image(c,r,2) >= 40 && image(c,r,3) >= 20 && image(c,r,1) > image(c,r,2) && image(c,r,1) > image(c,r,3) && abs(image(c,r,1) - image(c,r,2)) > 15)
           rgbImagefinal(c,r,1) = 255;
           rgbImagefinal(c,r,2) = 255;
           rgbImagefinal(c,r,3) = 255;
        else
           rgbImagefinal(c,r,1) = 0;
           rgbImagefinal(c,r,2) = 0;
           rgbImagefinal(c,r,3) = 0;
        end
    end
end 

% ----------------------end------------------------------



% -------------------------------------------------------
% gray image that have only face ib gray scale
image2 = image;
imrgbhsv = immultiply(rgbImagefinal , image2);
imrgbhsv = medfilt3(imrgbhsv);
imrgbhsv = rgb2gray(imrgbhsv);
imrgbhsv = imfill(imrgbhsv,'holes');

% ----------------------end------------------------------



% -------------------------------------------------------
% edge detection
gray = rgb2gray(image);
edge = edge(gray,'Canny');

% ----------------------end------------------------------



% -------------------------------------------------------
% find RGB face face
face = image;
for c = 1:160
    for r = 1:120
        if imrgbhsv(c,r,:)~= 255
            face(c,r,:) = 0;
        end
    end
end 
% ----------------------end------------------------------


% plot images

figure('Name','Source');
imshow(image);
figure('Name','imrgbhsv');
imshow(imrgbhsv);
figure('Name','Edge detection');
imshow(edge);
figure('Name','face');
imshow(face);



