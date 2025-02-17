function [panorama] = myRansac(matchedPoints1, matchedPoints2, img1, img2, fast1, fast2, t)

tforms(2) = projtform2d;%(eye(3));
ImageSize = zeros(2, 2);

tforms(2) = estgeotform2d(matchedPoints2, matchedPoints1, 'projective', 'Confidence', 99.9, 'MaxNumTrials', t);
% T(2)*T(1)
tforms(2).T = tforms(2).T*tforms(1).T;

ImageSize(2, :) = size(fast2);

for i = 1:numel(tforms)
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 ImageSize(i,2)], [1 ImageSize(i,1)]);
end

avgXLim = mean(xlim, 2);

[~, idx] = sort(avgXLim);

centerIdx = floor((numel(tforms)+1)/2);

centerImageIdx = idx(centerIdx);
Tinv = invert(tforms(centerImageIdx));

for i = 1:numel(tforms)
    tforms(i).T = tforms(i).T * Tinv.T;
end
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 ImageSize(i,2)], [1 ImageSize(i,1)]);
end

maxImageSize = max(ImageSize);

% Find the minimum and maximum output limits
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', img2);
blender = vision.AlphaBlender('Operation', 'Binary mask', ...
'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Transform I into the panorama.
warpedImage = imwarp(img1, tforms(1), 'OutputView', panoramaView);

% Generate a binary mask.
mask = imwarp(true(size(img1,1),size(img1,2)), tforms(1), 'OutputView', panoramaView);
panorama = step(blender, panorama, warpedImage, mask);

% Transform I into the panorama.
warpedImage = imwarp(img2, tforms(2), 'OutputView', panoramaView);

% Generate a binary mask.
mask = imwarp(true(size(img2,1),size(img2,2)), tforms(2), 'OutputView', panoramaView);
panorama = step(blender, panorama, warpedImage, mask);

end