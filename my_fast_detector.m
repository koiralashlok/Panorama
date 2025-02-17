
function [ret] = my_fast_detector(image, threshold, N)

img = rgb2gray(image); % values are now intensities
filt = zeros(744, 497);

% stores results of each of the 16 points in the circle
% 1 for pt. on circle being bright
% -1 for pt. on circle being dimmer
% 0 for non candidate points
filt2 = zeros(744, 16, 494);

% O(n)
% bScrCol: +1 if corr px on circle is brighter
% dScrCol: -1 if corr px on circle is dimmer
for i = 4: 497

    % fast removal
    % column of image being checked for corner candidates
    imgCol = img(4:747, i);

    % px 1
    sftCol = img(1:744, i);
    difCol = sftCol - imgCol;
    bScrCol = difCol >= threshold;
    dScrCol = (difCol <= -threshold) .*(-1);
    cumBScr = bScrCol;
    cumDScr = dScrCol;
    filt2(:,1,i) = bScrCol + dScrCol;

    % for px 9
    sftCol = img(7:750, i);
    difCol = sftCol - imgCol;
    bScrCol = (difCol >= threshold);
    dScrCol = ((difCol <= -threshold) .*(-1));
    cumBScr = cumBScr + bScrCol;
    cumDScr = cumDScr + dScrCol;
    filt2(:,9,i) = bScrCol + dScrCol;

    % for px 5
    sftCol = img(4:747, i + 3);
    difCol = sftCol - imgCol;
    bScrCol = (difCol >= threshold);
    dScrCol = ((difCol <= -threshold) .*(-1));
    cumBScr = cumBScr + bScrCol;
    cumDScr = cumDScr + dScrCol;
    filt2(:,5,i) = bScrCol + dScrCol;

    %for px 13
    sftCol = img(4:747, i - 3);
    difCol = sftCol - imgCol;
    bScrCol = (difCol >= threshold);
    dScrCol = ((difCol <= -threshold) .*(-1));
    cumBScr = cumBScr + bScrCol;
    cumDScr = cumDScr + dScrCol;
    filt2(:,13,i) = bScrCol + dScrCol;

    % filt will be 0 for pixels discarded by preliminary elimination
    % hence no calculations will be done for those pixels
    % score >= 3 -> maybe a corner, filter has 1 for those candidates
    % score <= -3 -> maybe a corner, filter has 1 for those candidates
    filt(:, i) = (cumBScr >= 3);
    filt(:, i) = filt(:, i) + (cumDScr <= -3);
end

% O(n)
for i = 4: 497
    % Non candidate pixels turned to 0 by .*filt(:,i)
    % Column of image to be checked for corners
    imgCol = img(4:747, i);

    % px 16
    sftCol = img(1:744, i - 1);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,16,i) = bScrCol + dScrCol;
    % px 2
    sftCol = img(1:744, i + 1);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,2,i) = bScrCol + dScrCol;

    % px 3
    sftCol = img(2:745, i + 2);
    difCol = (sftCol - imgCol).*filt(:, i);
    bScrCol = (difCol >= threshold);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,3,i) = bScrCol + dScrCol;

    % px 4
    sftCol = img(3:746, i + 3);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,4,i) = bScrCol + dScrCol;
    % px 6
    sftCol = img(5:748, i + 3);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,6,i) = bScrCol + dScrCol;

    % px 7
    sftCol = img(6:749, i + 2);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,7,i) = bScrCol + dScrCol;

    % px 8
    sftCol = img(7:750, i + 1);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,8,i) = bScrCol + dScrCol;
    % px 10
    sftCol = img(7:750, i - 1);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,10,i) = bScrCol + dScrCol;

    % px11
    sftCol = img(6:749, i - 2);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,11,i) = bScrCol + dScrCol;

    % px 12
    sftCol = img(5:748, i - 3);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,12,i) = bScrCol + dScrCol;
    % px 14
    sftCol = img(3:746, i - 3);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,14,i) = bScrCol + dScrCol;

    % px 15
    sftCol = img(2:745, i - 2);
    difCol = (sftCol - imgCol);
    bScrCol = (difCol >= threshold).*filt(:, i);
    dScrCol = ((difCol <= -threshold) .*(-1)).*filt(:, i);
    filt2(:,15,i) = bScrCol + dScrCol;
end

% reset and reuse filt
filt = zeros(744, 497);

for i = 4: 497
    % page has -1/ 1/ 0 for all 16 points in circle for each row in col i
    page = filt2(:,:,i);

    for j = 1: 16
        % we will check for sigma for condition on N
        % sigma is a column matrix with 744 rows
        % containing sum of intensities
        sigma = sum(page(:, j : min(N+j, 16)), 2);
        if(j > (16-N+1))
            sigma = sigma + sum(page(:, 1 : j - (16-N+1)), 2);
        end

        % add 1 if N contig. pxs are all brighter or all dimmer
        filt(:, i) = filt(:, i) + (sigma == N);
        filt(:, i) = filt(:, i) + (sigma == -N);
    end
end

% filt is >= 1 for every corner 0 for non corner
isCorner = filt(:, 4:497) >= 1;

% return the image with corners cast as double
ret = (isCorner).*1;

end