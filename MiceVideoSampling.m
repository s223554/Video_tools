clear all;
[files folder]= uigetfile('*.*');
movieFullFileName  = fullfile(folder, files);
%% open file
videoObject = VideoReader(movieFullFileName);
writeObject = VideoWriter(strcat(movieFullFileName(1:end-4),'_sampled'),'MPEG-4');
writeObject.FrameRate = 15;
FR = videoObject.FrameRate;
numberOfFrames = videoObject.Duration*FR;
vidHeight = videoObject.Height;
vidWidth = videoObject.Width;
%% sampling
t_duration = 10;
t_interval = 60;
open(writeObject);
for t = 1:t_interval:videoObject.Duration
videoObject.CurrentTime = t;
t_end = t+t_duration;
while hasFrame(videoObject)
    thisFrame = readFrame(videoObject);
    % processing goes here. Mark the time and rescale.
    timestr = datestr(videoObject.CurrentTime/86400, 'HH:MM:SS.FFF');
    processedFrame = insertText(thisFrame,position,timestr,'FontSize',18,'BoxColor',...
    box_color,'BoxOpacity',0.4,'TextColor','white');
    writeVideo(writeObject,processedFrame);
    if videoObject.CurrentTime>t_end
    break;
    end
end
    
end
close(writeObject);