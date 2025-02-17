% Part 1

img11 = im2double(imresize(imread("S1-im1.png", "png"), [750, 500]));
img12 = im2double(imresize(imread("S1-im2.png", "png"), [750, 500]));

img21 = im2double(imresize(imread("S2-im1.png", "png"), [750, 500]));
img22 = im2double(imresize(imread("S2-im2.png", "png"), [750, 500]));

img31 = im2double(imresize(imread("S3-im1.png", "png"), [750, 500]));
img32 = im2double(imresize(imread("S3-im2.png", "png"), [750, 500]));

img41 = im2double(imresize(imread("S4-im1.png", "png"), [750, 500]));
img42 = im2double(imresize(imread("S4-im2.png", "png"), [750, 500]));

% -------------------------------------------------------------------------

% Part 2: FAST feature detector

% Increasing threshold reduces number of corners inferred
%   threshold is the brightness difference that must exist between
%   center pixel and pixels on the "Bresenham circle" of radius 3
% Increasing N reduces number of corners inferred
%   N is the number of pixels on the Bresenham circle that must clear
%   this threshold
tic();
fast11 = my_fast_detector(img11, 0.05, 15);
fast12 = my_fast_detector(img12, 0.05, 15);

fast21 = my_fast_detector(img21, 0.03, 14);
fast22 = my_fast_detector(img22, 0.05, 15);

fast31 = my_fast_detector(img31, 0.05, 14);
fast32 = my_fast_detector(img32, 0.05, 15);

fast41 = my_fast_detector(img41, 0.05, 12);
fast42 = my_fast_detector(img42, 0.05, 15);

tot_time = toc()
avg_time = tot_time / 8

imwrite(fast11, "Report/Images/S1-fast.png", "png")
imwrite(fast21, "Report/Images/S2-fast.png", "png")

% -------------------------------------------------------------------------

% Part 2: Robust FAST using Harris Cornerness metric

tic();
sob = fspecial('sobel');
gaus = fspecial('gaussian', 5, 0.4);
dog = conv2(gaus, sob);

ix = imfilter(fast11, dog);
iy = imfilter(fast11, dog');
ix2g = imfilter(ix .* ix, gaus);
iy2g = imfilter(iy .* iy, gaus);
ixiyg = imfilter(ix .* iy, gaus);
harCorMeas = (ix2g .* iy2g) - (ixiyg .* ixiyg) - 0.05 * (ix2g + iy2g).^2;
fastr11 = harCorMeas > 0.04; % for cereal1, corners equally as strong perhaps but improvement in joining
imwrite(fastr11, "Report/Images/S1-fastR.png", "png");

ix = imfilter(fast12, dog);
iy = imfilter(fast12, dog');
ix2g = imfilter(ix .* ix, gaus);
iy2g = imfilter(iy .* iy, gaus);
ixiyg = imfilter(ix .* iy, gaus);
harCorMeas = (ix2g .* iy2g) - (ixiyg .* ixiyg) - 0.05 * (ix2g + iy2g).^2;
fastr12 = harCorMeas > 0.04; % for cereal2

ix = imfilter(fast21, dog);
iy = imfilter(fast21, dog');
ix2g = imfilter(ix .* ix, gaus);
iy2g = imfilter(iy .* iy, gaus);
ixiyg = imfilter(ix .* iy, gaus);
harCorMeas = (ix2g .* iy2g) - (ixiyg .* ixiyg) - 0.05 * (ix2g + iy2g).^2;
fastr21 = harCorMeas > 0.04; % for lamp
imwrite(fastr21, "Report/Images/S2-fastR.png", "png");

ix = imfilter(fast22, dog);
iy = imfilter(fast22, dog');
ix2g = imfilter(ix .* ix, gaus);
iy2g = imfilter(iy .* iy, gaus);
ixiyg = imfilter(ix .* iy, gaus);
harCorMeas = (ix2g .* iy2g) - (ixiyg .* ixiyg) - 0.05 * (ix2g + iy2g).^2;
fastr22 = harCorMeas > 0.04; % for lamp

ix = imfilter(fast31, dog);
iy = imfilter(fast31, dog');
ix2g = imfilter(ix .* ix, gaus);
iy2g = imfilter(iy .* iy, gaus);
ixiyg = imfilter(ix .* iy, gaus);
harCorMeas = (ix2g .* iy2g) - (ixiyg .* ixiyg) - 0.05 * (ix2g + iy2g).^2;
fastr31 = harCorMeas > 0.005; % for Bulbasaur
figure
imshow(fast31)
figure;
imshow(fastr31)

ix = imfilter(fast32, dog);
iy = imfilter(fast32, dog');
ix2g = imfilter(ix .* ix, gaus);
iy2g = imfilter(iy .* iy, gaus);
ixiyg = imfilter(ix .* iy, gaus);
harCorMeas = (ix2g .* iy2g) - (ixiyg .* ixiyg) - 0.05 * (ix2g + iy2g).^2;
fastr32 = harCorMeas > 0.005; % for Bulbasaur 08
% figure;
% imshow(fastr32)

ix = imfilter(fast41, dog);
iy = imfilter(fast41, dog');
ix2g = imfilter(ix .* ix, gaus);
iy2g = imfilter(iy .* iy, gaus);
ixiyg = imfilter(ix .* iy, gaus);
harCorMeas = (ix2g .* iy2g) - (ixiyg .* ixiyg) - 0.05 * (ix2g + iy2g).^2;
fastr41 = harCorMeas > 0.045; % for trash

ix = imfilter(fast42, dog);
iy = imfilter(fast42, dog');
ix2g = imfilter(ix .* ix, gaus);
iy2g = imfilter(iy .* iy, gaus);
ixiyg = imfilter(ix .* iy, gaus);
harCorMeas = (ix2g .* iy2g) - (ixiyg .* ixiyg) - 0.05 * (ix2g + iy2g).^2;
fastr42 = harCorMeas > 0.045; % for trash

tot_time = tot_time + toc()
avg_time = tot_time / 8


% -------------------------------------------------------------------------

% Part 3: Point description and matching & Part 4: RANSAC and Panoramas

% manually save figures since imwrite cannot write "primitive.images"
tic();
% Set1
% [descF11, locatF11] = extractFeatures(rgb2gray(img11), detectSURFFeatures(fast11), 'Method', 'FREAK');
% [descF12, locatF12] = extractFeatures(rgb2gray(img12), detectSURFFeatures(fast12), 'Method', 'FREAK');
% indexPairs = matchFeatures(descF11, descF12);
% matchedPoints1 = locatF11(indexPairs(:,1),:);
% matchedPoints2 = locatF12(indexPairs(:,2),:);
% figure;
% showMatchedFeatures(img11,img12,matchedPoints1,matchedPoints2)
% figure(1)
% imshow(myRansac(matchedPoints1, matchedPoints2, img11, img12, fast11, fast12, 10000))

% [descR11, locatR11] = extractFeatures(rgb2gray(img11), detectSURFFeatures(fastr11), 'Method', 'FREAK');
% [descR12, locatR12] = extractFeatures(rgb2gray(img12), detectSURFFeatures(fastr12), 'Method', 'FREAK');
% indexPairs = matchFeatures(descR11, descR12);
% matchedPoints1 = locatR11(indexPairs(:,1),:);
% matchedPoints2 = locatR12(indexPairs(:,2),:);
% figure;
% showMatchedFeatures(img11,img12,matchedPoints1,matchedPoints2);
% figure(2)
% imshow(myRansac(matchedPoints1, matchedPoints2, img11, img12, fastr11, fastr12, 100))


% Set 2
% [descF21, locatF21] = extractFeatures(rgb2gray(img21), detectORBFeatures(fast21, 'NumLevels', 4), 'Method', 'ORB');
% [descF22, locatF22] = extractFeatures(rgb2gray(img22), detectORBFeatures(fast22, 'NumLevels', 4), 'Method', 'ORB');
% indexPairs = matchFeatures(descF21, descF22);
% matchedPoints1 = locatF21(indexPairs(:,1),:);
% matchedPoints2 = locatF22(indexPairs(:,2),:);
% figure;
% showMatchedFeatures(img21,img22,matchedPoints1,matchedPoints2);
% figure(1)
% imshow(myRansac(matchedPoints1, matchedPoints2, img21, img22, fast21, fast22, 10000))

% [descR21, locatR21] = extractFeatures(rgb2gray(img21), detectORBFeatures(fastr21, 'NumLevels', 4), 'Method', 'ORB');
% [descR22, locatR22] = extractFeatures(rgb2gray(img22), detectORBFeatures(fastr22, 'NumLevels', 4), 'Method', 'ORB');
% indexPairs = matchFeatures(descR21, descR22);
% matchedPoints1 = locatR21(indexPairs(:,1),:);
% matchedPoints2 = locatR22(indexPairs(:,2),:);
% figure;
% showMatchedFeatures(img21,img22,matchedPoints1,matchedPoints2);
% figure(2)
% imshow(myRansac(matchedPoints1, matchedPoints2, img21, img22, fastr21, fastr22, 100))

avg_time_FAST = toc()/2
% avg_time_FASTR = toc()/2

% Set 3
[descF31, locatF31] = extractFeatures(rgb2gray(img31), detectORBFeatures(fast31), 'Method', 'ORB');
[descF32, locatF32] = extractFeatures(rgb2gray(img32), detectORBFeatures(fast32), 'Method', 'ORB');
indexPairs = matchFeatures(descF31, descF32);
matchedPoints1 = locatF31(indexPairs(:,1),:);
matchedPoints2 = locatF32(indexPairs(:,2),:);
figure;
showMatchedFeatures(img31,img32,matchedPoints1,matchedPoints2)
figure(1)
imshow(myRansac(matchedPoints1, matchedPoints2, img31, img32, fast31, fast32, 10000))

[descR31, locatR31] = extractFeatures(rgb2gray(img31), detectORBFeatures(fastr31), 'Method', 'ORB');
[descR32, locatR32] = extractFeatures(rgb2gray(img32), detectORBFeatures(fastr32), 'Method', 'ORB');
indexPairs = matchFeatures(descR31, descR32);
matchedPoints1 = locatR31(indexPairs(:,1),:);
matchedPoints2 = locatR32(indexPairs(:,2),:);
figure;
showMatchedFeatures(img31,img32,matchedPoints1,matchedPoints2);
figure(2)
imshow(myRansac(matchedPoints1, matchedPoints2, img31, img32, fastr31, fastr32, 100))


% Set 4
% [descF41, locatF41] = extractFeatures(rgb2gray(img41), detectORBFeatures(fast41), 'Method', 'ORB');
% [descF42, locatF42] = extractFeatures(rgb2gray(img42), detectORBFeatures(fast42), 'Method', 'ORB');
% indexPairs = matchFeatures(descF41, descF42);
% matchedPoints1 = locatF41(indexPairs(:,1),:);
% matchedPoints2 = locatF42(indexPairs(:,2),:);
% figure(1);
% showMatchedFeatures(img41,img42,matchedPoints1,matchedPoints2)
% figure(3)
% imshow(myRansac(matchedPoints1, matchedPoints2, img41, img42, fast41, fast42, 10000))
% 
% 
% [descR41, locatR41] = extractFeatures(rgb2gray(img41), detectORBFeatures(fastr41), 'Method', 'ORB');
% [descR42, locatR42] = extractFeatures(rgb2gray(img42), detectORBFeatures(fastr42), 'Method', 'ORB');
% indexPairs = matchFeatures(descR41, descR42);
% matchedPoints1 = locatR41(indexPairs(:,1),:);
% matchedPoints2 = locatR42(indexPairs(:,2),:);
% figure(2);
% showMatchedFeatures(img41,img42,matchedPoints1,matchedPoints2);
% figure(4)
% imshow(myRansac(matchedPoints1, matchedPoints2, img41, img42, fastr41, fastr42, 100))

% -------------------------------------------------------------------------

