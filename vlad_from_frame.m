function [ enc ] = vlad_from_frame(image_file,vocabulary,kdtree)

keypoint_type = '-hesaff';
descriptor_type = '-sift';
[descrs2,metadata] = end_to_end_sift(image_file,keypoint_type,descriptor_type);
descrs2 = descrs2';

% this is supposed to be normalized, but we're skipping the step

dataEncode = double(descrs2);


nn = double(vl_kdtreequery(kdtree, vocabulary, dataEncode));
numClusters = size(vocabulary,2);
numDataToBeEncoded = size(descrs2,2);
assignments = double(zeros(numClusters,numDataToBeEncoded));
assignments(sub2ind(size(assignments), nn, 1:length(nn))) = 1;
enc = vl_vlad(double(dataEncode),double(vocabulary),double(assignments),'SquareRoot');

end

