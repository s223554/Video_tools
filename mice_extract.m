clear all;
[files folder]= uigetfile('*.wmv');
movieFullFileName  = fullfile(folder, files);
%%
videoObject = VideoReader(movieFullFileName);
writeObject = VideoWriter(strcat(movieFullFileName(1:end-4),'_zoomed'),'MPEG-4');
numberOfFrames = videoObject.Duration*videoObject.FrameRate;
vidHeight = videoObject.Height;
vidWidth = videoObject.Width;
window = 32;
%% calculate mean background
backgroundGray = (zeros(vidHeight,vidWidth));

for t = 10000:10:11000
videoObject.CurrentTime = t;
while hasFrame(videoObject)
    thisFrame = readFrame(videoObject);
    currAxes.Visible = 'off';
    videoFrameGray = rgb2gray(thisFrame);
    backgroundGray = backgroundGray + double(videoFrameGray); 
    break;
end
    
end
BG = uint8(backgroundGray./100);        % assign new factor

%% substract and processing
white = input('Color of mice? White = 1');
writeObject.FrameRate = 15;
% writeObject.Colormap = jet(256);

open(writeObject);

t_start = 10000;
t_end = 10100;
t_step = 10;
t_duration = 5; 


for t = t_start:t_step:t_end
    
    videoObject.CurrentTime = t;
    
while hasFrame(videoObject)
    
    if videoObject.CurrentTime >t+t_duration
        break;
        
    end
    disp(videoObject.CurrentTime)
    thisFrame = readFrame(videoObject);
    disp(videoObject.CurrentTime)
    currAxes.Visible = 'off';
    videoFrameGray = rgb2gray(thisFrame);
    if white == 1
    objectFrame = videoFrameGray-BG; 
    else
    objectFrame = BG-videoFrameGray; 
    end
    
    center_struc = regionprops(objectFrame>100,'centroid');
    center = center_struc.Centroid;
    W = floor(center(1));
    H = floor(center(2));
    if window > min(W,H)        % another half.
        continue
    end
    %zoomedObject = objectFrame(H-window:H+window,W-window:W+window);
    zoomedObject = thisFrame(H-window:H+window,W-window:W+window,:);
    objectFinal = imresize(zoomedObject,4);
    writeVideo(writeObject,objectFinal);
    
end

end
close(writeObject);
%%

%close(videoObject);