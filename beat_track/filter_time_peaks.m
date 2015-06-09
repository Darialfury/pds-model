function [id_after_peaks, ta_peaks] = filter_time_peaks(tb_peaks, sample_take)

	id_after_peaks = logical(ones(size(tb_peaks)));
	num_peaks = numel(id_after_peaks)
	begi = ceil(sample_take/2);
	en = num_peaks - ceil(sample_take/2) + 1;

	% begin vector
	dift = abs(tb_peaks(1:sample_take-1) - tb_peaks(2:sample_take));
	mean_dif = mean(dift);
	std_dif = std(dift);
	idf = dift(1:begi)>(mean_dif - std_dif);
	id_after_peaks(1:begi) = idf; 

	%end vector
	dift = abs(tb_peaks((num_peaks-sample_take+1):num_peaks-1) - tb_peaks((num_peaks-sample_take+2):num_peaks));
	mean_dif = mean(dift);
	std_dif = std(dift);
	idf = dift(end-begi+1:end)>(mean_dif - std_dif);
	id_after_peaks(en:end) = idf; 


	for i=(begi+1):(en-1)
		if(id_after_peaks(i))
			dift = abs(tb_peaks((i-begi+1):(i-begi+sample_take-1)) - tb_peaks((i-begi+2):(i-begi+sample_take)));
			mean_dif = mean(dift);
			std_dif = std(dift);
			id_after_peaks(i+1) = dift(begi)>(mean_dif - std_dif);
		end
	end
	ta_peaks = tb_peaks(id_after_peaks);