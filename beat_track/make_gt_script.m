close all
addpath('./davies-beat-tracker/')

%code to start beat analysis

name_file = 'midi_rif1';
[beats, x_mono, df, df_no_inter]=modified_function([name_file '.wav'], 'resultado.txt');

fs = 44100;
vec_x = 1/fs:1/fs:(length(x_mono))/fs;
step_second = 5;


%start cycle to recollect all onset times
vector_gt = []
figure
count_index = 1;
for i=1:(step_second*44100):length(x_mono)
	if(i>1)
		plot(vec_x(count_index:i), x_mono(count_index:i), 'r')
		title('Making beat location')
		xlabel('Time (s)')
		track_part = audioplayer(x_mono(count_index:i),fs);
		play(track_part)
		[x,~]=ginput;
		key = input('play again?   --->')
		while(key==1)
			track_part = audioplayer(x_mono(count_index:i),fs);
			play(track_part)
			[x,~]=ginput;
			key = input('play again?   --->')
		end
		count_index = i;
		vector_gt = [vector_gt x'];
	end
end

save([name_file '_gt.mat'],'vector_gt')

figure
plot(vec_x, x_mono, 'r')
hold on
beat_amp = 0.1*ones(1,length(beats));
plot(beats, beat_amp,beats, beat_amp,'g*')
onset_time = kron(df,ones(1,513));
onset_time = (onset_time/max(onset_time))*2;
t2 = 1/fs:1/fs:length(onset_time)/fs;
plot(t2,onset_time,'c')




dv_beat = beats(2:end) - beats(1:end-1);
av_beat = mean(dv_beat)
