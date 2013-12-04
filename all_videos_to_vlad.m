% assume vl_feat has been added to path
vocabulary = load('64_SIFT_vocab.mat');
vocabulary = double(vocabulary.v)';
kdtree = vl_kdtreebuild(vocabulary);
every_nth_frame = 12.5;

INPUT_PATH = '../PROCESSED_DATA/';
d = dir(INPUT_PATH);
isub = [d(:).isdir];
main_folds = {d(isub).name}';
main_folds(ismember(main_folds,{'.','..'})) = [];
segment_length = 20;

for i=1:size(main_folds,1)
	MAIN_FOLDER_PATH = strcat(INPUT_PATH,main_folds{i},'/')
	
	% now list all of the folders within this folder
	d1 = dir(MAIN_FOLDER_PATH);
	isub = [d1(:).isdir];
	sub_folder_names = {d1(isub).name}';
	sub_folder_names(ismember(sub_folder_names,{'.','..'})) = [];

	for j=1:size(sub_folder_names,1)
		SUB_FOLDER_PATH = strcat(MAIN_FOLDER_PATH,sub_folder_names{j},'/');
		d = dir(strcat(SUB_FOLDER_PATH,'*.mpg'));
		isub = ~[d(:).isdir];
		file_names = {d(isub).name}';
		file_names(ismember(file_names,{'.','..'})) = [];

		for k=1:size(file_names,1)
			video_path = strcat(SUB_FOLDER_PATH,file_names{k});
			video_to_vlad(video_path, every_nth_frame,vocabulary,kdtree)
		end
		
	end

end

% video_path = '../Scratch/00000.mpg';
% every_nth_frame = 12.5;
% video_to_vlad(video_path, every_nth_frame,vocabulary,kdtree)

