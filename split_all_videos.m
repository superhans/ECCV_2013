% This code splits all the videos in the directory INRIA_JOLY and stores the results 
% in PROCESSED_DATA

% first, get all the directories in INRIA_JOLY

INPUT_PATH = '../INRIA_JOLY/';
OUTPUT_PATH = '../PROCESSED_DATA/'
d = dir(INPUT_PATH);
isub = [d(:).isdir];
main_folds = {d(isub).name}';
main_folds(ismember(main_folds,{'.','..'})) = [];
segment_length = 20;

for i=1:size(main_folds,1)
	MAIN_FOLDER_PATH = strcat(INPUT_PATH,main_folds{i},'/')
	mkdir(OUTPUT_PATH,main_folds{i});
	% now list all of the files within this folder
	d = dir(strcat(MAIN_FOLDER_PATH,'*.mpg'));
	isub = ~[d(:).isdir];
	file_names = {d(isub).name}';
	file_names(ismember(file_names,{'.','..'})) = []

	for j=1:size(file_names,1)
		file_path = strcat(MAIN_FOLDER_PATH,file_names{j})
		[pathstr,name,ext] = fileparts(file_names{j});
		mkdir(strcat(OUTPUT_PATH,'/',main_folds{i}),name);
		out_path = strcat(OUTPUT_PATH,main_folds{i},'/',name,'/')
		split_video(file_path,out_path,segment_length);
	end

end