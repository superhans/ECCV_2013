function [] = rand_proj()
	% Go inside the PROCESSED DATA folder
	tic
	%load the random projection matrix
	rand_proj_mat = load('projection_matrix.mat');
	rand_proj_mat = rand_proj_mat.rand_proj;

	INPUT_PATH = '../PROCESSED_DATA/';
	d = dir(INPUT_PATH);
	isub = [d(:).isdir];
	main_folds = {d(isub).name}';
	main_folds(ismember(main_folds,{'.','..'})) = [];

	if matlabpool('size') == 0 % checking to see if my pool is already open
	     matlabpool open 6
	end

	for i=1:size(main_folds,1)
		MAIN_FOLDER_PATH = strcat(INPUT_PATH,main_folds{i},'/')
		% now list all of the files within this folder
		d = dir(MAIN_FOLDER_PATH);
		isub = [d(:).isdir];
		movie_folder_names = {d(isub).name}';
		movie_folder_names(ismember(movie_folder_names,{'.','..'})) = [];

		% now, go into eah of the movies folders
		for j=1:size(movie_folder_names,1)
			%find the sub_folders here
			MOVIE_FOLDER_PATH = strcat(MAIN_FOLDER_PATH,movie_folder_names{j},'/')
			e = dir(MOVIE_FOLDER_PATH);
			isub = [e(:).isdir];
			clip_folder_names = {e(isub).name}';
			clip_folder_names(ismember(clip_folder_names,{'.','..'})) = [];

			parfor k=1:size(clip_folder_names,1)
				parfor_function(k,MOVIE_FOLDER_PATH,clip_folder_names,rand_proj_mat);
				% VLAD_PATH = strcat(MOVIE_FOLDER_PATH,clip_folder_names{k},'/');
				% mkdir(VLAD_PATH,'rand_proj_vlad');
				% VLAD_PATH_VLADS = strcat(VLAD_PATH,'vlads/');
				% f = dir(strcat(VLAD_PATH_VLADS,'*.mat'));
				% isub = ~[f(:).isdir];
				% vlad_file_names = {f(isub).name}';
				% vlad_file_names(ismember(vlad_file_names,{'.','..'})) = [];
				% SAVE_PROJECTED_VLADS_PATH = strcat(VLAD_PATH,'rand_proj_vlad/');

				% for l=1:size(vlad_file_names,1)
				% 	% load the input vlad
				% 	VLAD_FILE_PATH = strcat(VLAD_PATH_VLADS,vlad_file_names{l});
				% 	vlad = load(VLAD_FILE_PATH);
				% 	vlad = vlad.vlad;
				% 	projected_vlad = rand_proj_mat*vlad;
				% 	[pathstr,name,ext] = fileparts(VLAD_FILE_PATH);
				% 	save_path = strcat(SAVE_PROJECTED_VLADS_PATH,name,'proj.mat');
				% 	save(save_path,'projected_vlad');

				% end

			end
		end
	end
	toc
end

function [] = parfor_function(k,MOVIE_FOLDER_PATH,clip_folder_names,rand_proj_mat)
	VLAD_PATH = strcat(MOVIE_FOLDER_PATH,clip_folder_names{k},'/');
	mkdir(VLAD_PATH,'rand_proj_vlad');
	VLAD_PATH_VLADS = strcat(VLAD_PATH,'vlads/');
	f = dir(strcat(VLAD_PATH_VLADS,'*.mat'));
	isub = ~[f(:).isdir];
	vlad_file_names = {f(isub).name}';
	vlad_file_names(ismember(vlad_file_names,{'.','..'})) = [];
	SAVE_PROJECTED_VLADS_PATH = strcat(VLAD_PATH,'rand_proj_vlad/');

	for l=1:size(vlad_file_names,1)
		% load the input vlad
		VLAD_FILE_PATH = strcat(VLAD_PATH_VLADS,vlad_file_names{l});
		vlad = load(VLAD_FILE_PATH);
		vlad = vlad.vlad;
		projected_vlad = rand_proj_mat*vlad;
		[pathstr,name,ext] = fileparts(VLAD_FILE_PATH);
		save_path = strcat(SAVE_PROJECTED_VLADS_PATH,name,'proj.mat');
		save(save_path,'projected_vlad');
	end
end