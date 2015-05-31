function feature_reformed = shape_vector(vec, dimension)
%Give the feature the shape that needs in order to multiply w
% 

num_element = numel(vec);
feature_reformed = zeros(1,num_element*dimension);
for j=1:num_element
 feature_reformed((((j-1)*dimension) + 1):(j*dimension)) = (dimension*(vec(j) - 1) + 1):(dimension*vec(j));
end
