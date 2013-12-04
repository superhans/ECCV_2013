function [] = video_to_vlad(video_path, every_nth_frame,vocabulary,kdtree)
% this code extracts VLAD descriptors from a video and places them in a folder with
% the same name as the video

[pathstr,name,ext] = fileparts(video_path);

mkdir(pathstr,'temp');
mkdir(pathstr,name);
mkdir(strcat(pathstr,'/',name),'vlads');
vlad_path = strcat(pathstr,'/',name,'vlads/');

sample_system_command = ['ffmpeg -i ',video_path,' -r ',num2str(every_nth_frame),' ',...
pathstr,'/temp/%05d.png']

system(sample_system_command);

% now, extract sift features for each image
d = dir(strcat(pathstr,'/','temp','/','*.png'));
isub = ~[d(:).isdir];
file_names = {d(isub).name}'

for i=1:size(file_names,1)

	[descrs,~] = end_to_end_sift(strcat(pathstr,'/','temp','/',file_names{i})...
		,keypoint_type,descriptor_type)
	vlad = vlad_from_frame(strcat(pathstr,'/','temp','/',file_names{i}))
	[~,name,ext] = fileparts(file_names{i});
	save_path = strcat(vlad_path,name,'vlad.mat')
	% save('vlad');
end