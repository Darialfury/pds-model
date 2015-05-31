
addpath('./davies-beat-tracker/')

%code to start beat analysis

[beats, x_mono, df]=modified_function('test_80.wav', 'resultado.txt');

fs = 44100;
vec_x = 1/fs:1/fs:(length(x_mono))/fs;

figure
plot(x_mono)
figure
plot(vec_x, x_mono, 'r')
hold on
beat_amp = 0.1*ones(1,length(beats));
plot(beats, beat_amp,beats, beat_amp,'g*')

dv_beat = beats(2:end) - beats(1:end-1);
av_beat = mean(dv_beat)

