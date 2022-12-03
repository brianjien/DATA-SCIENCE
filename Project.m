

outputFolder1=('C:\Users\USER\Downloads\Matlab_Final_project\Vid');
v1=VideoReader('C:\Users\USER\Downloads\ab.mp4');
vid1Frames=read(v1,[1  Inf]);
for frame=1:size(vid1Frames,4)
outputBaseFileName=sprintf('%1d.png',frame);
outputFullFileName=fullfile(outputFolder1,outputBaseFileName);
imwrite(vid1Frames(:,:,:,frame),outputFullFileName,'png');
end

options = trainingOptions('adam', ...
'MiniBatchSize', 1, ... 
'InitialLearnRate', 1e-5, ... 
'LearnRateSchedule', 'piecewise', ...
'LearnRateDropFactor', 0.1, ...
'LearnRateDropPeriod', 100, ...
'MaxEpochs', 20, ...
'CheckpointPath', tempdir, ...
'Verbose', true);

detector = trainFasterRCNNObjectDetector(gTruth,"resnet101",options);



Redd=0;
Gree=0;
Yello=0;
for i=1:frame
    img=imread(['C:\Users\USER\Downloads\Matlab_Final_project\Vid\',...
        num2str(i),'.png']);
adressString = ['C:\Users\USER\Downloads\Matlab_Final_project\Vid_Yolo\',sprintf('%1d', i) ,'.png']; 

[bboxes, score, label] = detect(detector, img, 'MiniBatchSize', 128);
T = 0.88; 
idx = score >= T;
s = score(idx);
lbl = label(idx);
bbox = bboxes(idx, :); 
outputImage = img; 
for ii = 1 : size(bbox, 1)
    annotation = sprintf('%s: (Confidence = %f)', lbl(ii), s(ii));
    outputImage = insertObjectAnnotation(outputImage, 'rectangle', bbox(ii,:), annotation); 
   end
a='Green_Light';
b='Red_Light';
c='Yellow_Light';
S1 = string(lbl(ii));
   t1=strcmp(S1,a);
    t2=strcmp(S1,b);
     t3=strcmp(S1,c);
if (t1==1)
    fprintf('GO \n')
Gree=Gree+1;
end 
if (t2==1)
    fprintf('STOP \n')
Redd=Redd+1;

end 
if (t3==1)
    fprintf('SLOW \n')
    Yello=Yello+1;
end 

imwrite(outputImage,adressString);
end
thingSpeakWrite(1737038,[Redd,Gree,Yello],'WriteKey','7AQ6RJ53M09YVN6K')
fprintf('job done\n')
framesPath = 'C:\Users\USER\Downloads\Matlab_Final_project\Vid_Yolo\';
videoName = 'C:\Users\USER\Downloads\Matlab_Final_project\Bolt.mp4';
fps = 25; 
startFrame = 1; 
endFrame = frame; 
if(exist('videoName','file'))
    delete videoName.mp4
end
aviobj=VideoWriter(videoName); 
aviobj.FrameRate=fps;

open(aviobj);

for i=startFrame:endFrame
    fileName=sprintf('%1d',i);    
    frames=imread([framesPath,fileName,'.png']);
    writeVideo(aviobj,frames);
end
close(aviobj);
fprintf('job done\n')


