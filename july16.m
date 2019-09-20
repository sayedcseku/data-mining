img = imread('apple1-000-000.png');

%img = im2double(img);

red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);

meanRed = mean(red(:));
meanGreen = mean(green(:));
meanBlue= mean(blue(:));

medianRed = median(red(:));
medianGreen = median(green(:));
medianBlue= median(blue(:));

minRed = min(red(:));
minGreen = min(green(:));
minBlue = min(blue(:));

maxRed = max(red(:));
maxGreen = max(green(:));
maxBlue = max(blue(:));

midRangeRed = (maxRed+minRed)/2;
midRangeGreen = (maxGreen+minGreen)/2;
midRangeBlue = (maxBlue+minBlue)/2;


stdRed = std(red(:));
stdBlue = std(blue(:));
stdGreen = std(green(:));


