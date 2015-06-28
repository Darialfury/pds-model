
addpath('./davies-beat-tracker/')

%List of precision of different songs
%recordings without time filter
% 59.65 opium
% 30.56 noche
% 55.12 cumbia
% 65.00 rif1

% recordings
% 62.96 opium
% 32.84 noche
% 60.56 cumbia
% 64.15 rif1

% sounds from MIDI
% 98.11 opium
% 22.73 noche
% 73.47 cumbia
% 84.00 rif1

%code to start beat analysis
close all
%name_file = 'cumbia_larga_v2';
%name_file = 'noche';
%name_file = 'opium';
%name_file = 'rif1';

%name_file = 'midi_cumbia_larga_v2';
%name_file = 'midi_noche';
name_file = 'midi_opium';
%name_file = 'midi_rif1';

[beats, x_mono, df, df_no_inter]=modified_function([name_file '.wav'], 'resultado.txt');

fs = 44100;
vec_x = 1/fs:1/fs:(length(x_mono))/fs;

figure
plot(vec_x, x_mono, 'r')
hold on
beat_amp = 0.1*ones(1,length(beats));
plot(beats, beat_amp,beats, beat_amp,'g*')
onset_time = kron(df,ones(1,513));
onset_time = (onset_time/max(onset_time))*2;
t2 = 1/fs:1/fs:length(onset_time)/fs;
plot(t2,onset_time,'c')

[pks, id_pks] = findpeaks(df);
id_pks_onset = (id_pks - 1)*513 + 1;
tpkeas = t2(id_pks_onset);
opeaks = onset_time(id_pks_onset);
ids = find(opeaks>mean(opeaks));

tb_peaks = tpkeas(ids);
ob_peaks = opeaks(ids);
plot(tpkeas(ids), opeaks(ids),'k*')
%plot(t2(id_pks_onset), onset_time(id_pks_onset),'k*')
title('Tempo and beat location')
xlabel('Time')

hold off
[ida, ta_peaks] = filter_time_peaks(tb_peaks, 5);
oa_peaks = ob_peaks(ida);


figure
plot(df)
title('onset function')


figure
plot(vec_x, x_mono, 'r')
hold on
plot(t2,onset_time,'c')
plot(ta_peaks, oa_peaks,'y*')
%plot(t2(id_pks_onset), onset_time(id_pks_onset),'k*')
title('Tempo and beat location')
xlabel('Time')


dv_beat = beats(2:end) - beats(1:end-1);
av_beat = mean(dv_beat)

gt_file = [name_file '_gt.mat'];
if(exist(gt_file))
	disp('start testing... ')
	load(gt_file)
	length(vector_gt)

	dif_gt = vector_gt(2:end) - vector_gt(1:end-1);
	dif_exp = ta_peaks(2:end) - ta_peaks(1:end-1);
	num_gt = length(vector_gt);
	num_exp = length(ta_peaks);
	if(length(vector_gt)<length(ta_peaks))
  	mat_dif = abs(repmat(ta_peaks',1,num_gt) - repmat(vector_gt,num_exp,1));
		error_ab1 = sum(min(mat_dif'));
		%error_vector1 = sum(min( ((mat_dif)./(repmat(vector_gt,num_exp,1)))' ))/(num_exp);
	end

	[pre1, recall1] = eval_prec_recall(vector_gt, ta_peaks);
	disp('Error')
	disp(error_ab1)

end

dif_exp = ta_peaks(2:end) - ta_peaks(1:end - 1);
fname = [name_file '_time.txt'];
for i=1:length(dif_exp)
	fid=fopen(fname,'a');
	fprintf(fid,[num2str(dif_exp(i)) '\n']);
	fclose(fid);
end

if(exist(gt_file))
	disp('start testing... ')
	load(gt_file)
	length(vector_gt)
	dif_gt = vector_gt(2:end) - vector_gt(1:end-1);
	dif_exp = tb_peaks(2:end) - tb_peaks(1:end-1);
	num_gt = length(vector_gt);
	num_exp = length(tb_peaks);
	if(length(vector_gt)<length(tb_peaks))
    mat_dif = abs(repmat(tb_peaks',1,num_gt) - repmat(vector_gt,num_exp,1));
		error_ab2 = sum(min(mat_dif'));
		[pre2, recall2] = eval_prec_recall(vector_gt, tb_peaks);
		disp('without time filter')
		%disp(error_ab1)
	end
end
