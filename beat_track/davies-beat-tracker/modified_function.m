function [beats, x_mono]=modified_function(input,output)

%function davies_standard(input,output)
% 
% inputs: 
% input   - wave file to process
% output  - text file to store output beat locations
% 
% outputs:
% none
% 
% overview of processing: 
% read audio file
% convert to mono
% generate onset detection function
% track tempo (find best periodicity path
% find beats using dynamic programming
% write the beats to a text file
%
%
% (c) 2009 Matthew Davies


% read wave file
[x fs] = wavread(input);

% convert to mono
x = mean(x,2);
x_mono = x;
% if audio is not at 44khz resample
if fs~=44100,
  x = resample(x,44100,fs);
end
% read beat tracking parameters
p = bt_parms;

% generate the onset detection function
df = onset_detection_function(x,p);

% strip any trailing zeros
while (df(end)==0)
  df = df(1:end-1);
end

% get periodicity path
ppath = periodicity_path(df,p);

mode = 0; % use this to run normal algorithm.
% find beat locations
beats = dynamic_programming(df,p,ppath,mode);

% write the beat locations out in seconds to the textfile
fid = fopen(output,'w');
fprintf(fid,'%f\n',beats);
fclose(fid); 


