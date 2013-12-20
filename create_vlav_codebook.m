% go to the database and extract 1 million random vlad codewords

profile on
count = 1;
n_movies = 101;
projected_vlads_to_cluster = zeros(128,10000);
n_codewords = 64;
INPUT_PATH = '../PROCESSED_DATA/DB-MPEG1/movie'

for i=1:10000%size(projected_vlads_to_cluster,2)
	i
	m = randperm(n_movies); m = m(1);
	main_folder_path = strcat(INPUT_PATH,num2str(m),'/');
	%disp('e');
	%disp('f');
	movie_folder_names = evalc(strcat(['ls',' ',main_folder_path,'/*.mpg']));
	nn = ceil(size(movie_folder_names,2)/48);
	sub_folder = randperm(nn);
	sub_folder = sub_folder(1)-1;
	sub_folder_name = sprintf('%05d',sub_folder);
	% disp('g');
	sub_folder_path = strcat(main_folder_path,sub_folder_name,'/','rand_proj_vlad/');
	% disp('h');


	file_names = evalc(strcat(['ls',' ',sub_folder_path]));
	nn = floor(size(file_names,2)/20);
	fil = randperm(nn);
	% size(file_names)
	fil = fil(1);
	file_path = strcat(sub_folder_path,sprintf('%05d',fil),'_vladproj.mat');
	% disp('c');
	x = load(file_path);
	x = x.projected_vlad;
	projected_vlads_to_cluster(:,i) = x;
	% disp('d');

end
profile viewer
disp('starting kmeans');
[centers,~] = vl_kmeans(projected_vlads_to_cluster,n_codewords,'algorithm','ann');
save('64_VLAD_vocab.mat','centers');
