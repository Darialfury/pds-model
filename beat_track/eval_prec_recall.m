function [precision, recall]=eval_prec_recall(gt_vector, exp_vector)
	%Function to evaluate the precission
	%of the beat tracker
	recall = 0;
	prec = 0;
	sample_gap = 4096;
	sec_gap = sample_gap/44100;

	dif_gt = gt_vector(2:end) - gt_vector(1:end-1);
	dif_exp = exp_vector(2:end) - exp_vector(1:end-1);
	num_gt = length(gt_vector);
	num_exp = length(exp_vector);

  mat_dif = abs(repmat(gt_vector',1,num_exp) - repmat(exp_vector,num_gt,1));
  id_mat = mat_dif<sec_gap;

  false_positive = 0;

	tp_vector = [];
	fp_vector = [];
	id_used = [];
  for i=1:num_gt
    %false_positive = false_positive + sum(mat_dif(i,:)<sec_gap) - 1;
    %false_positive = false_positive + sum(mat_dif(i,:)<sec_gap);

		id1 = find((mat_dif(i,:))<sec_gap);
		[~, b] = min(mat_dif(i,id1));
		tp_vector = [tp_vector exp_vector(id1(b))];
		id_used = [id_used id1(b)];
		if i~=num_gt
			id2 = find(mat_dif(i+1,:)<sec_gap);
			[~, d] = min(mat_dif(i+1,id2));
			fp_vector = [fp_vector exp_vector(id1(b)+1:id2(d)-1)];
		end
  end
  true_positive = length(tp_vector)
  false_positive = num_exp - true_positive
  precision = true_positive/(false_positive + true_positive)
