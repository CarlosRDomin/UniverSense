function [ energy ] = signalEnergy( signal )
%SIGNALENERGY Summary of this function goes here
%   Detailed explanation goes here

    if size(signal,2)>1
        signal = signal(:,2);
    end
    energy = sum(signal.*signal);

end

