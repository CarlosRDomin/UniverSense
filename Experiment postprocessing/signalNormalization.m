function [ normalizedSig ] = signalNormalization( signal )
    signal = signal-mean(signal);
    signalEnergy= sqrt(sum(signal.*signal)); 
    normalizedSig = signal./signalEnergy;
end

