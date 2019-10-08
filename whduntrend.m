%simple wrapper function to visualize how smoothing the window to different
%sizes ends up working out

function vec = whduntrend(propmat, winsize)

vec = nanmean(propmat);
vec = nanmoving_average(vec,winsize);
plot(vec,'o');


