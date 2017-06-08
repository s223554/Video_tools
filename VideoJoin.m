clear all;
[files folder]= uigetfile('*.*');
movieFullFileName1  = fullfile(folder, files);
[files folder]= uigetfile('*.*');
movieFullFileName2  = fullfile(folder, files);

videoObject1 = VideoReader(movieFullFileName1);
videoObject2 = VideoReader(movieFullFileName2);

newFilename = input('new filename','s');
writeObject = VideoWriter(strcat(folder,newFilename,'_joined'),'MPEG-4');
writeObject.FrameRate = 15;

FR = videoObject1.FrameRate;


numberOfFrames = min(videoObject1.Duration,videoObject2.Duration)*FR;
open(writeObject);
while hasFrame(videoObject1) && hasFrame(videoObject2)
    thisFrame1 = readFrame(videoObject1);
    thisFrame2 = readFrame(videoObject2);
    % processing goes here.
    joinedFrame = [thisFrame1 thisFrame2];
    writeVideo(writeObject,joinedFrame);
    % display current time processed.
    timestr1 = datestr(videoObject1.CurrentTime/86400, 'HH:MM:SS.FFF');
    timestr2 = datestr(videoObject2.CurrentTime/86400, 'HH:MM:SS.FFF');
    disp(timestr1)
    %disp(timestr2)
end
close(writeObject)
