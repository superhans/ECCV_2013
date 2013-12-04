function [descrs,metadata] = end_to_end_sift(image_file,keypoint_type,descriptor_type)
% This function takes a path as input and produces frames and descriptors
% as output. It does this by calling the linux binary
% compute_descriptors_linux64 which produces hessian affine sift
% descriptors. These result in a siftgeo file which is then piped

% end_to_end_sift('',

% Options:
%      -harlap - harris-laplace detector
%      -heslap - hessian-laplace detector
%      -haraff - harris-affine detector
%      -hesaff - hessian-affine detector
%      -harhes - harris-hessian-laplace detector
%      -dense xstep ystep nbscales - dense detector
%      -sedgelap - edge-laplace detector
%      -jla  - steerable filters,  similarity= 
%      -sift - sift [D. Lowe],  similarity=
%      -siftnonorm - sift [D. Lowe],  without normalization
%      -msift - Mahalanobis sift, similarity= 
%      -gloh - extended sift,  similarity= 
%      -mom  - moments,  similarity= 
%      -koen - differential invariants,  similarity= 
%      -cf   - complex filters [F. Schaffalitzky],  similarity=
%      -sc   - shape context,  similarity=45000 
%      -spin - spin,  similarity= 
%      -gpca - gradient pca [Y. Ke],  similarity=
%      -cc - cross correlation,  similarity=
%      -i image.pgm  - input image pgm, ppm, png
%      -i2 image.jpg - input of any format of ImageMagick (WARN: uses only green channel)
%      -pca input.basis - projects the descriptors with pca basis
%      -p1 image.pgm.points - input regions format 1
%      -p2 image.pgm.points - input regions format 2
%      -o1 out.desc - saves descriptors in out.desc output format1
%      -o2 out.desc - saves descriptors in out.desc output format2
%      -o3 out.siftbin - saves descriptors in binary format
%      -o4 out.siftgeo - binary descriptor format used by Bigimbaz
%      -coord out.coord - saves coordinates in binary format
%      -noangle - computes rotation variant descriptors (no rotation esimation)
%      -DC - draws regions as circles in out.desc.png
%      -DR - draws regions as ellipses in out.desc.png
%      -c 255 - draws points in grayvalue [0,...,255]
%      -thres - threshod value
%      -max - maximum for the number of computed descriptors in HESSAFF

% image_file,keypoint_type,feature_type

% Threshold is set to default of 500 (no idea why)
thres = 500;

status = system('chmod 755 ./compute_descriptors_linux64');
linux_command = sprintf(['./compute_descriptors_linux64 -i %s %s ',...
    '-o4 temp_sift %s -thres %d'],image_file,keypoint_type,...
    descriptor_type,thres)

system(linux_command);

% now, read the temp_sift file using sift_geo; max of 1000 descriptors per
% image
[descrs,metadata] = siftgeo_read('temp_sift' ,1000); 

end

