function beats = davies_quick(df,p,mode)

if nargin<2
  p = bt_parms;
end

% strip any trailing zeros
while (df(end)==0)
  df = df(1:end-1);
end

% get periodicity path
ppath = periodicity_path(df,p);

if nargin<3
	mode = 0; % use this to run normal algorithm.
end

% find beat locations
beats = dynamic_programming(df,p,ppath,mode);
