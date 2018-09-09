function [ similarity ] = compareSignal( sig1, sig2 )
%COMPARESIGNAL Summary of this function goes here
%   Detailed explanation goes here
    sig1 = signalNormalization(sig1);
    sig2 = signalNormalization(sig2);
    
    similarity = max(xcorr(sig1, sig2));

end

