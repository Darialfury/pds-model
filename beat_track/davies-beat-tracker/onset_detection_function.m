function df = onset_detection_function(x,p)

% function to calculate the following onset detection function
% df = complex spectral difference
x = mean(x,2); % just in case we have a stereo file

% onset analysis step increment`      
o_step = p.winlen*2; % should be 1024
% onset analysis winlen
o_winlen = o_step*2; % should be 2048

hlfwin = o_winlen/2; % will be half fft size

% formulate hanningz window function
win = hanningz(o_winlen);
%  win = tukeywin(o_winlen,0.5);

% loop parameters
N = length(x);
pin = 0;
pend = N - o_winlen;

% vectors to store phase and magnitude calculations
theta1 = zeros(hlfwin,1);
theta2 = zeros(hlfwin,1);
oldmag = zeros(hlfwin,1);

% output onset detection function
df = [];

% df sample number
k = 0;
while pin<pend
    
    k=k+1;
    % calculate windowed fft frame
    segment = x(pin+1:pin+o_winlen);
    X = fft(fftshift(win.*segment));

    % discard first half of the spectrum
    X = X(floor(length(X)/2)+1:length(X),:);

    % find the magnitude and phase
    mag = (abs(X));	
    theta = angle(X);
    
    % complexsd part
    dev=princarg(theta-2*theta1+theta2);
    meas=oldmag - (mag.*exp(i.*dev));
    df(k) = sum(sqrt((real(meas)).^2+(imag(meas)).^2));

    % update vectors
    theta2 = theta1;
    theta1 = theta;
    oldmag = mag;
  
    % move to next frame
    pin = pin+o_step;
end

% now interpolate each detection function by a factor of 2 to get resolution of 11.6ms
df = interp1([0:length(df)-1]*p.timeres/p.fs,df,[0:0.5:length(df)-1]*p.timeres/p.fs,'cubic');


