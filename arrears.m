%% EXTRACT_VLADS for every single image

master_path = '/media/My Passport/ZZ_VARUN_HARD_DRIVE/VLAVS_DATA/';
num_videos = 49;
vocabulary = fvecs_read('clust_k64.fvecs')';
kdtree = vl_kdtreebuild(vocabulary) ;

for i=1:num_videos
    main_folder_path = strcat(master_path,num2str(i),'/');
    d = dir(main_folder_path);
    isub = [d(:).isdir]; %# returns logical vector
    nameFolds = {d(isub).name};
    for j=3:size(nameFolds,2)
       inside_folder_path = strcat(main_folder_path,num2str(j-3),'/')
       mkdir(inside_folder_path,'vlads');
       frames_folder_path = strcat(inside_folder_path,'frames/')
       d = dir(strcat(frames_folder_path,'*.png'));
       isub = not([d(:).isdir]);
       nameFiles = {d(isub).name};
       for k = 1:size(nameFiles,2)
          file_path = strcat(frames_folder_path,nameFiles{k});
          vlad_enc = vlad_from_frame(strcat('"',file_path,'"'),vocabulary,kdtree);
          [pathstr,name,ext] = fileparts(file_path);
          save_path = strcat(inside_folder_path,'vlads/',name,'_vlad');
          save(save_path,'vlad_enc');
       end
       
    end
    
end
% 
% image_file1 = 'frame00010.png';
% keypoint_type = '-hesaff';
% descriptor_type = '-sift';
% [descrs2,metadata] = end_to_end_sift(image_file1,keypoint_type,descriptor_type);
% descrs2 = descrs2';
% vocabulary = fvecs_read('clust_k64.fvecs')';
% 
% % this is supposed to be normalized, but we're skipping the step
% kdtree = vl_kdtreebuild(vocabulary) ;
% dataEncode = descrs2;
% nn = double(vl_kdtreequery(kdtree, vocabulary, dataEncode));
% numClusters = size(vocabulary,2);
% numDataToBeEncoded = size(descrs2,2);
% assignments = double(zeros(numClusters,numDataToBeEncoded));
% assignments(sub2ind(size(assignments), nn, 1:length(nn))) = 1;
% class(assignments)
% class(dataEncode)
% enc = vl_vlad(double(dataEncode),double(vocabulary),double(assignments),'SquareRoot');

%% Compute the MMV_Vlad 
GRAND_MASTER_ALL_VLADS = [];
MASTER_ALL_VLADS = [];
master_path = '/media/My Passport/ZZ_VARUN_HARD_DRIVE/VLAVS_MINI/';
num_videos = 8;
for i=1:num_videos    main_folder_path = strcat(master_path,num2str(i),'/');
    main_folder_path = strcat(master_path,num2str(i),'/');
    d = dir(main_folder_path);
    isub = [d(:).isdir]; %# returns logical vector
    nameFolds = {d(isub).name};
    
    for j=3:size(nameFolds,2)
        MASTER_ALL_VLADS = [];
        inside_folder_name = strcat(main_folder_path,num2str(j-3),'/','vlads','/')
        d = dir(strcat(inside_folder_name,'*vlad.mat'));
        isub = not([d(:).isdir]);
        nameVlads = {d(isub).name};
        current_segment_mmv = zeros(8192,1);
        for k=1:size(nameVlads,2)
           file_path = strcat(inside_folder_name,nameVlads{k});
           current_vlad = load(file_path);
           current_vlad = current_vlad.vlad_enc;
           MASTER_ALL_VLADS = [MASTER_ALL_VLADS current_vlad];
           current_segment_mmv = current_segment_mmv + current_vlad;
        end
        current_segment_all_vlads = MASTER_ALL_VLADS;
        current_segment_mmv = current_segment_mmv/size(nameVlads,2);
        mmv_file_name = sprintf('segments_%d_%d_vlad.mat',i,(j-3));
        all_vlads_file_name = sprintf('segments_%d_%d_all_vlads.mat',i,(j-3));
        save_path = strcat(main_folder_path,num2str(j-3),'/',mmv_file_name);
        save_path2 = strcat(main_folder_path,num2str(j-3),'/',all_vlads_file_name);
        save(save_path2,'current_segment_all_vlads');
        save(save_path,'current_segment_mmv');
        GRAND_MASTER_ALL_VLADS = [GRAND_MASTER_ALL_VLADS MASTER_ALL_VLADS];
    end
disp('Saving_All_Vlads');
save('GRAND_MASTER_ALL_VLADS.mat','GRAND_MASTER_ALL_VLADS');
end

%% Save GRAND_MASTER
GRAND_MASTER_ALL_VLADS = [];
master_path = '/media/My Passport/ZZ_VARUN_HARD_DRIVE/VLAVS_MINI/';
num_videos = 8;
for i=1:num_videos    
    
    main_folder_path = strcat(master_path,num2str(i),'/');
    d = dir(main_folder_path);
    isub = [d(:).isdir]; %# returns logical vector
    nameFolds = {d(isub).name};
    
    for j=3:size(nameFolds,2)
        MASTER_ALL_VLADS = [];
        inside_folder_name = strcat(main_folder_path,num2str(j-3),'/');
        d = dir(strcat(inside_folder_name,'*vlads.mat'));
        isub = not([d(:).isdir]);
        nameVlads = {d(isub).name};
        
        for k=1:size(nameVlads,2)
           file_path = strcat(inside_folder_name,nameVlads{k})
           current_vlad = load(file_path);
           current_vlad = current_vlad.current_segment_all_vlads;
%           current_vlad = current_vlad.vlad_enc;
           GRAND_MASTER_ALL_VLADS = [GRAND_MASTER_ALL_VLADS current_vlad];
%           current_segment_mmv = current_segment_mmv + current_vlad;
        end
%        current_segment_all_vlads = MASTER_ALL_VLADS;
%        current_segment_mmv = current_segment_mmv/size(nameVlads,2);
%        mmv_file_name = sprintf('segments_%d_%d_vlad.mat',i,(j-3));
%        all_vlads_file_name = sprintf('segments_%d_%d_all_vlads.mat',i,(j-3));
%        save_path = strcat(main_folder_path,num2str(j-3),'/',mmv_file_name);
%        save_path2 = strcat(main_folder_path,num2str(j-3),'/',all_vlads_file_name);
%        save(save_path2,'current_segment_all_vlads');
%        save(save_path,'current_segment_mmv');
%        GRAND_MASTER_ALL_VLADS = [GRAND_MASTER_ALL_VLADS MASTER_ALL_VLADS];
    end

end

disp('Saving_All_Vlads');
save('GRAND_MASTER_ALL_VLADS.mat','GRAND_MASTER_ALL_VLADS','-v7.3');

%% Do the PCA

disp('loading the matrix');
grand_master = load('GRAND_MASTER_ALL_VLADS.mat');
grand_master = grand_master.GRAND_MASTER_ALL_VLADS';
size(grand_master);

[coeff,score] = princomp(grand_master);
n_low_dims = 128;
pca_grand_master = grand_master*c;
pca_grand_master = pca_grand_master(:,128);
pca_grand_master = pca_grand_master';

save('pca_grand_master.mat','pca_grand_master');

%% Take mmv from each clip 

% This are the indices 
% video1 - 0-49 0 to 49
% video2 - 0-16 50 to 66
% video3 - 0-28 67 to 95
% video4 - 0-19 96 to 115
% video5 - 0-24 116 to 140
% video6 - 0-78 141 to 219
% video7 - 0-37 220 to 257
% video8 - 0-53 258 to 311
% --------------
% Total  - 312 ( i think, but not sure)

GRAND_MASTER_ALL_MMVS = [];

for i=1:num_videos    
    
    main_folder_path = strcat(master_path,num2str(i),'/');
    d = dir(main_folder_path);
    isub = [d(:).isdir]; %# returns logical vector
    nameFolds = {d(isub).name};
    
    for j=3:size(nameFolds,2)
       % MASTER_ALL_VLADS = [];
        inside_folder_name = strcat(main_folder_path,num2str(j-3),'/');
        d = dir(strcat(inside_folder_name,'*vlad.mat'));
        isub = not([d(:).isdir]);
        nameVlads = {d(isub).name};
        
        for k=1:size(nameVlads,2)
           file_path = strcat(inside_folder_name,nameVlads{k})
           current_vlad = load(file_path);
           current_vlad = current_vlad.current_segment_mmv;
           GRAND_MASTER_ALL_MMVS = [GRAND_MASTER_ALL_MMVS current_vlad];
           
        end

    end

end

save('GRAND_MASTER_ALL_MMVS.mat','GRAND_MASTER_ALL_MMVS','-v7.3');

%% Now, find the MMV closest to the query MMV but not itself. 

% first load the mmv set
clear all;
all_mmvs = load('GRAND_MASTER_ALL_MMVS.mat');
all_mmvs = all_mmvs.GRAND_MASTER_ALL_MMVS;
size(all_mmvs)

% now, find the vlad that is closest to the query mmv except for the query
% mmv

eu_dist = zeros(size(all_mmvs,2),size(all_mmvs,2));

for i=1:size(all_mmvs,2)
   for j=1:size(all_mmvs,2)
      eu_dist(i,j) = sqrt(sum((all_mmvs(:,i) - all_mmvs(:,j)).^2));

   end
end

[sorted,rank_list] = sort(eu_dist,2,'ascend');

top6 = rank_list(:,1:6)-1

