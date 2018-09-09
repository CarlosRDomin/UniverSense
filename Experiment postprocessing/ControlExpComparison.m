clear; close all;clc;

load('control_20cm_20s_80bpm.mat');
eventNum = 10;
duration{1} = 1:64;
duration{2} = 1:128;
duration{3} = 1:256;
duration{4} = 1:512;

%% duration
for durationID = 1:4
    for eventID = 1:eventNum
        eventID
        FP_IMU{eventID} = fingerprintUAV{1, eventID}(duration{durationID});
        FP_CAM{eventID} = fingerprintCAM{1, eventID}(duration{durationID});
        SIG_IMU{eventID} = uavSig{1, eventID}(duration{durationID});
        SIG_CAM{eventID} = camSig{1, eventID}(duration{durationID});
    end
    confusionMatrixDuration{durationID} = zeros(eventNum);
    similarityMatrixDuration{durationID} = zeros(eventNum);
    for originalID = 1:eventNum
        for compareID = 1:eventNum
            confusionMatrixDuration{durationID}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} ); 
            similarityMatrixDuration{durationID}(originalID, compareID) = compareSignal( SIG_IMU{originalID}, SIG_CAM{compareID} ); 

        end
    end

%     figure;imagesc(confusionMatrixDuration{durationID});axis equal;
end

for i = 1:4
    confusion{i} = [];
    similarity{i} = [];
    for gt = 1:eventNum
        confusion{i} = [confusion{i}, confusionMatrixDuration{i}(gt,gt)];
        similarity{i} = [similarity{i}, similarityMatrixDuration{i}(gt,gt)];
        
    end
end

% allEvent{1} = [similarity{1}; similarity{2}; similarity{3}; similarity{4}]';
allEvent{1} = [confusion{1}; confusion{2}; confusion{3}; confusion{4}]';

figure;
addpath('./aboxplot');
aboxplot(allEvent);
title('Fingerprint Length');

%% amplitude
for amplitudeID = 1:4
    if amplitudeID == 1
        load('control_10cm_20s_160bpm.mat');
    elseif amplitudeID == 2
        load('control_20cm_20s_80bpm.mat');
    elseif amplitudeID == 3
        load('control_40cm_20s_40bpm.mat');
    elseif amplitudeID == 4
        load('control_80cm_20s_20bpm.mat');
    end
    for eventID = 1:eventNum
        amplitudeID
        eventID
        FP_IMU{eventID} = fingerprintUAV{1, eventID}(duration{durationID});
        FP_CAM{eventID} = fingerprintCAM{1, eventID}(duration{durationID});
        
        SIG_IMU{eventID} = uavSig{1, eventID}(duration{durationID});
        SIG_CAM{eventID} = camSig{1, eventID}(duration{durationID});
    end
    confusionMatrixAmplitude{amplitudeID} = zeros(eventNum);
    similarityMatrixAmplitude{amplitudeID} = zeros(eventNum);

    for originalID = 1:eventNum
        for compareID = 1:eventNum
            confusionMatrixAmplitude{amplitudeID}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} );
            similarityMatrixAmplitude{amplitudeID}(originalID, compareID) = compareSignal( SIG_IMU{originalID}, SIG_CAM{compareID} ); 

        end
    end

%     figure;imagesc(confusionMatrixAmplitude{amplitudeID});axis equal;
end

for i = 1:4
    confusion{i} = [];
    similarity{i} = [];
    for gt = 1:eventNum
        confusion{i} = [confusion{i}, confusionMatrixAmplitude{i}(gt,gt)];
        similarity{i} = [similarity{i}, similarityMatrixAmplitude{i}(gt,gt)];
        
    end
end

% allEvent{1} = [similarity{1}; similarity{2}; similarity{3}; similarity{4}]';
allEvent{1} = [confusion{1}; confusion{2}; confusion{3}; confusion{4}]';

% figure;
subplot(2,1,1);
addpath('./aboxplot');
aboxplot(allEvent);

%% velocity
for velocityID = 1:5
    if velocityID == 1
        load('control_20cm_20s_40bpm.mat');
    elseif velocityID == 2
        load('control_20cm_20s_60bpm.mat');
    elseif velocityID == 3
        load('control_20cm_20s_80bpm.mat');
    elseif velocityID == 4
        load('control_20cm_20s_100bpm.mat');
    elseif velocityID == 5
        load('control_20cm_20s_120bpm.mat');
    end
    for eventID = 1:eventNum
        velocityID
        eventID
        
        FP_IMU{eventID} = fingerprintUAV{1, eventID}(duration{durationID});
        FP_CAM{eventID} = fingerprintCAM{1, eventID}(duration{durationID});
        
        
        SIG_IMU{eventID} = uavSig{1, eventID}(duration{durationID});
        SIG_CAM{eventID} = camSig{1, eventID}(duration{durationID});

    end
    confusionMatrixVelocity{velocityID} = zeros(eventNum);
    similarityMatrixVelocity{velocityID} = zeros(eventNum);

    for originalID = 1:eventNum
        for compareID = 1:eventNum
            confusionMatrixVelocity{velocityID}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} );
            similarityMatrixVelocity{velocityID}(originalID, compareID) = compareSignal( SIG_IMU{originalID}, SIG_CAM{compareID} ); 

        end
    end

%     figure;imagesc(confusionMatrixVelocity{velocityID});axis equal;
end

for i = 1:5
    confusion{i} = [];
    similarity{i} = [];
    for gt = 1:eventNum
        confusion{i} = [confusion{i}, confusionMatrixVelocity{i}(gt,gt)];
        similarity{i} = [similarity{i}, similarityMatrixVelocity{i}(gt,gt)];

    end
end

% allEvent{1} = [similarity{1}; similarity{2}; similarity{3}; similarity{4};similarity{5};]';
allEvent{1} = [confusion{1}; confusion{2}; confusion{3}; confusion{4}; confusion{5};]';

% figure;

subplot(2,1,2);
addpath('./aboxplot');
aboxplot(allEvent, 'grey_down');
