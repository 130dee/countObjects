%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Derek Conway C12728815
%   Image Processing Final Project 08/05/16
%   Isolate 6 coloured cups and count them
%   
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   The algorithm has been tested, sucessfully on the cups image, and with limited success
%   on the bags image. magic numbers
%   have been used to threshold  Foreground was segmented from the background
%   by extracting the reds, greens and blues separately and adding them together.
%   This extracted foreground is used to give an outside edge to the final
%   target image.
%   Edge detection was then performed on the original image using a Sobel Fieldman matrice
%   This was to find the internal edges between the objects. A combination of different edges was used to determine the objects,
%   found through trial and error.
%   Edges were grown using 'strel disk' before combining them.
%   Edges were then layerd over the extracted foreground, this gave an outside edge
%   to the image.
%   Again, the lines were fleshed out to ensure that they formed a full join where needed
%   this was done using imerode and dilate functions
%   Extra noise in the image was eliminated using the imfill function, 
%   this got rid of holes in the objects.
%   Small obects were discarded from the image using the bwareopen function
%   using the example here:
%   http://uk.mathworks.com/matlabcentral/answers/46398-removing-objects-which-have-area-greater-and-lesser-than-some-threshold-areas-and-extracting-only-th
%   Obects were counted using the bwconcomp tool from the example here:
%   http://uk.mathworks.com/matlabcentral/answers/110287-how-to-count-the-number-of-object-present-in-binary-imageto make the line 1 pixel wide and getting the endpoints of the
%   line.
%   Thanks for giving me the opportunity to submit this, I know that my
%   effort is substandard of what is expected, but the task was completed,
%   albeit using magic numbers.
% 

%%

clc % clear screen
clear all % clear memory
close all % close any open imagesImage = imread('ColourObjects.jpg');

%Read in the image
Image = imread('ColourObjects.jpg');

%extract reds, grrens, blues
redish = Image(:,:,1);
greenish = Image(:,:,2);
blueish = Image(:,:,3);

%get binary versions
binR = im2bw(redish,0.65);
bin = im2bw(greenish,0.65);
binB = im2bw(blueish,0.65);
%add the three binaries to get a full extraction of foreground
sumOfBinaries = (binR & bin & binB);
%reverse the values to give a black background
%just a personal way of working with the image
ReversedValueImage = imcomplement(sumOfBinaries);
%fill in the holes to guarantee a full foreground
ReversedValueImage = imfill(ReversedValueImage, 'holes');

%%

I = im2double(Image);
I = rgb2gray(I);

%Sobel_Fieldman filter for edge detection horizontal, vertical, diagonal
%edges detected. Found that if I doubled the value of the first matrice I
%produced a better edge.
SobelH = [2 0 -2;
          4 0 -4;
          2 0 -2]/4;
SobelH2 = [-1 0 1;
          -2 0 2;
          -1 0 1]/4;
      
SobelV = [-1 -2 -1;
           0  0  0;
           1  2  1]/4;
       
SobelV2 = [1 2 1;
           0  0  0;
           -1  -2  -1]/4;
       
SobelD = [0 -1 -2;
           1  0  -1;
           2  1  0]/4;
       
SobelD2 = [0 1 2;
           -1  0  1;
           -2  -1  0]/4;
SobelE = [-2 -1 0;
           -1  0  1;
           0  1  2]/4;
       
SobelE2 = [2 1 0;
           1  0  -1;
           0  -1  -2]/4;
%size of strel disk to flesh out the edges     
strelDisk = strel('disk',6);

%Apply the edge detector
Ih = conv2(I,SobelH,'same');
Ih = imcomplement(Ih);
Ih = im2bw(Ih, 0.95);
Ih = imerode(Ih,strelDisk);
Ih = Ih & ReversedValueImage;

Ih2 = conv2(I,SobelH2,'same');
Ih2 = imcomplement(Ih2);
Ih2 = im2bw(Ih2, 0.95);
Ih2 = imerode(Ih2,strelDisk);
Ih2 = Ih2 & ReversedValueImage;

Iv = conv2(I,SobelV,'same');
Iv = imcomplement(Iv);
Iv = im2bw(Iv, 0.95);
Iv = imerode(Iv,strelDisk);
Iv = Iv & ReversedValueImage;

Iv2 = conv2(I,SobelV2,'same');
Iv2 = imcomplement(Iv2);
Iv2 = im2bw(Iv2, 0.95);
Iv2 = imerode(Iv2,strelDisk);
Iv2 = Iv2 & ReversedValueImage;


Id = conv2(I,SobelD,'same');
Id = imcomplement(Id);
Id = im2bw(Id, 0.95);
Id = imerode(Id,strelDisk);
Id = Id & ReversedValueImage;
Id = Id & ReversedValueImage;

Id2 = conv2(I,SobelD2,'same');
Id2 = imcomplement(Id2);
Id2 = im2bw(Id2, 0.95);
Id2 = imerode(Id2,strelDisk);
Id2 = Id2 & ReversedValueImage;

Ie = conv2(I,SobelE,'same');
Ie = imcomplement(Ie);
Ie = im2bw(Ie, 0.95);
Ie = imerode(Ie,strelDisk);
Ie = Ie & ReversedValueImage;

Ie2 = conv2(I,SobelE2,'same');
Ie2 = imcomplement(Ie2);
Ie2 = im2bw(Ie2, 0.95);
Ie2 = imerode(Ie2,strelDisk);
Ie2 = Ie2 & ReversedValueImage;

%display the edges that I produced, used to see which edges I needed to use
figure; 
subplot(2,4,1), imshow(Ih),title('Ih');
subplot(2,4,2), imshow(Ih2),title('Ih2');
subplot(2,4,3), imshow(Iv),title('Iv');
subplot(2,4,4), imshow(Iv2),title('Iv2');
subplot(2,4,5), imshow(Id),title('Id');
subplot(2,4,6), imshow(Id2),title('Id2');
subplot(2,4,7), imshow(Ie),title('Ie');
subplot(2,4,8), imshow(Ie2),title('Ie2');

% I played around with the edges and discoveder that I only needed to use
% these two
joined =  Ih & Ih2;

%filled any holes that were created
joined = imfill(joined, 'holes');

figure, imshow (joined);

combinedEgdeAndForeground = ReversedValueImage & joined;
combinedEgdeAndForeground = imerode(combinedEgdeAndForeground,strelDisk);
combinedEgdeAndForeground = imdilate(combinedEgdeAndForeground,strelDisk);


%large numbers needed as the image is huge     
lowerLimit = 5000; % min number of pixels for a region to be included in count
combinedEgdeAndForeground = bwareaopen(combinedEgdeAndForeground,lowerLimit);

% get a count of the objects
getCount = bwconncomp(combinedEgdeAndForeground,8);
numberOfObjects  = getCount.NumObjects;
% reverse the image back and display
combinedEgdeAndForeground = imcomplement(combinedEgdeAndForeground);
figure, imshow (combinedEgdeAndForeground);
%display the original image and the count of the objects
figure, imshow(Image);

outputString = sprintf('There are %d objects in the image',numberOfObjects);
text(100,100,outputString);