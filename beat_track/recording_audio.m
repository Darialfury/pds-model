
r = audiorecorder(44100, 16, 1);
      
disp('Start speaking.')
recordblocking(r, 5);
disp('End of Recording.');
play(r)
y = getaudiodata(r);
plot(y);

