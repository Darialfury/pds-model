
addpath('./davies-beat-tracker/')

%code to start beat analysis

[beats, x_mono, df, df_no_inter]=modified_function('cumbia_larga_v2.wav', 'resultado.txt');

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
plot(tpkeas(ids), opeaks(ids),'k*')
%plot(t2(id_pks_onset), onset_time(id_pks_onset),'k*')
title('Tempo and beat location')
xlabel('Time')

figure
plot(df)
title('onset function')


dv_beat = beats(2:end) - beats(1:end-1);
av_beat = mean(dv_beat)

