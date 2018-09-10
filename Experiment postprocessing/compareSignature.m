function [ similarity ] = compareSignature( sig1, sig2 )
%COMPARESIGNATURE Summary of this function goes here
%   Detailed explanation goes here

    similarity = 1-sum(abs(sig1-sig2))/length(sig1);
end

