imwrite(im2double(imresize(imread("box1.png", "png"), [750, 500])), "S1-im1.png");
imwrite(im2double(imresize(imread("box2.png", "png"), [750, 500])), "S1-im2.png");

imwrite(im2double(imresize(imread("lamp1.png", "png"), [750, 500])), "S2-im1.png");
imwrite(im2double(imresize(imread("lamp2.png", "png"), [750, 500])), "S2-im2.png");

imwrite(im2double(imresize(imread("bulba1.png", "png"), [750, 500])), "S3-im1.png");
imwrite(im2double(imresize(imread("bulba2.png", "png"), [750, 500])), "S3-im2.png");

imwrite(im2double(imresize(imread("burnaby1.png", "png"), [750, 500])), "S4-im1.png");
imwrite(im2double(imresize(imread("burnaby2.png", "png"), [750, 500])), "S4-im2.png");