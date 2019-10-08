% does moving average on signal x, window size is w
function y = movingAverage(x, w)
   k = ones(1, w) / w;
   %y = conv(x, k, 'same');
   y = conv(x, k,'valid'); %choosing valid truncates the extremes instead of preserving them
end