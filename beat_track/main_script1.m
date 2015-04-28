
addpath('./davies-beat-tracker/')

%code to start beat analysis

[beats, x_mono]=modified_function('cumbia_larga.wav', 'resultado.txt');

fs = 44100;
vec_x = 1/fs:1/fs:(length(x_mono))/fs;

figure
plot(x_mono)
figure
plot(vec_x, x_mono, 'r')
hold on
beat_amp = 0.2*ones(1,length(beats));
plot(beats, beat_amp,beats, beat_amp,'g*')