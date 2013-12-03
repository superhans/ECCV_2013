function [] = split_video(in_path, out_path, segment_length)
% superhans This video takes in a video with path in_path % and uses ffmpeg to 
% split the video into several segments of length segment_length (seconds). 
% The segmented videos % are labeled accordingly and placed at out_path

% to get FFMPEG to work, load the following instead : 
% LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6 matlab

split_system_call = ['ffmpeg -i',' ',in_path,' -map 0 -vcodec copy -loglevel quiet'...
	,' -f segment -segment_time',' ',num2str(segment_length),' ',out_path,'%05d.mpg'];

system(split_system_call)

end

