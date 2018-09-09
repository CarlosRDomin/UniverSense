clear; close all; clc;

load('./mid_20cm_20s.mat');

exampleAxis = 1;
exampleEvent = 1;
figure;
subplot(2,1,1);
plot(uavSig{exampleAxis, exampleEvent}(1:256,2));hold on;
plot(camSig{exampleAxis, exampleEvent}(1:256,2));hold off;
xlim([0,256]);
subplot(2,1,2);
plot(fingerprintUAV{exampleAxis, exampleEvent}(1:256));hold on;
plot(fingerprintCAM{exampleAxis, exampleEvent}(1:256));hold off;
xlim([0,256]);
