%trimmat of columns and rows that contain either all nans or zeros
function out = trimmat(data)

    data(~any(~isnan(data), 2),:)=[];  %rows
    data( ~any(data,2), : ) = [];  %rows
    data( :, ~any(data,1) ) = [];  %columns
    data(~any(~isnan(data), 2),:)=[];  %columns
    out = data;