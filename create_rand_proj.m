function [] = create_rand_proj(k,d)
% This funcion generates and saves a random projection matrix given sizes k and d
% were K << d

% X_rp kxN = R kxd XdxN
% where k << d

% N = 1 and d = 8192. k = 64. Projection matrix is of size 64 X 8192
% From Achlioptas, it can be shown that : 

% r_ij = sqrt(3) * +1 with probability 1/6
% 				   0 with probability 2/3
% 				  -1 with probability 1/6

% This matrix still satisfies Johnson Lindenstrauss

seed = rand(k,d);
rand_proj = zeros(k,d);
plus_one = double(seed > 5/6);
minus_one = double(seed < 1/6) .* -1;
rand_proj = plus_one + minus_one;
rand_proj = rand_proj * sqrt(3);

save('projection_matrix.mat','rand_proj');
