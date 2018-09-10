clear; close all;clc;

load('mid_20cm_20s.mat');
eventNum = 10;
duration{1} = 128:192;
duration{2} = 128:256;
duration{3} = 128:384;
duration{4} = 1:512;

%% axis analysis
durationID = 2;
for eventID = 1:eventNum
    FP_IMU{eventID} = fingerprintUAV{1, eventID}(duration{durationID});
    FP_CAM{eventID} = fingerprintCAM{1, eventID}(duration{durationID});
end
confusionMatrixAxis{1} = zeros(eventNum);
for originalID = 1:eventNum
    for compareID = 1:eventNum
        confusionMatrixAxis{1}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} ); 
    end
end

clear FP_IMU FP_CAM;
for eventID = 1:eventNum
    FP_IMU{eventID} = fingerprintUAV{2, eventID}(duration{durationID});
    FP_CAM{eventID} = fingerprintCAM{2, eventID}(duration{durationID});
end
confusionMatrixAxis{2} = zeros(eventNum);
for originalID = 1:eventNum
    for compareID = 1:eventNum
        confusionMatrixAxis{2}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} ); 
    end
end

clear FP_IMU FP_CAM;
for eventID = 1:eventNum
    eventID
    yEnergy = signalEnergy(uavSig{1,eventID})
    zEnergy = signalEnergy(uavSig{2,eventID})
    if yEnergy >= 1.5*zEnergy
        % cut 32 bits out from y
        FP_IMU{eventID} = fingerprintUAV{1, eventID}(duration{durationID});
        FP_CAM{eventID} = fingerprintCAM{1, eventID}(duration{durationID});
    else
        % cut 32 bits out from z
        FP_IMU{eventID} = fingerprintUAV{2, eventID}(duration{durationID});
        FP_CAM{eventID} = fingerprintCAM{2, eventID}(duration{durationID});
    end
end
confusionMatrixAxis{3} = zeros(eventNum);
for originalID = 1:eventNum
    for compareID = 1:eventNum
        confusionMatrixAxis{3}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} ); 
    end
end

% axis strategies
for i = 1:3
    paired{i} = [];
    nonpaired{i} = [];
    for gt = 1:eventNum
        paired{i} = [paired{i}, confusionMatrixAxis{i}(gt,gt)];
        for cp = 1:eventNum
            if cp == gt
                continue;
            end
            nonpaired{i} = [nonpaired{i}, confusionMatrixAxis{i}(gt,cp)]; 
        end
    end
end
pairedAve = [mean(paired{1}), mean(paired{2}), mean(paired{3})];
pairedStd = [std(paired{1}), std(paired{2}), std(paired{3})];
nonpairedAve = [mean(nonpaired{1}), mean(nonpaired{2}), mean(nonpaired{3})];
nonpairedStd = [std(nonpaired{1}), std(nonpaired{2}), std(nonpaired{3})];

allEvent{1} = [paired{1}; paired{2}; paired{3}]';
allEvent{2} = [nonpaired{1}; nonpaired{2}; nonpaired{3}]';

figure;
addpath('./aboxplot');
aboxplot(allEvent);

%% duration
for durationID = 1:4
    for eventID = 1:eventNum
        eventID
        yEnergy = signalEnergy(uavSig{1,eventID})
        zEnergy = signalEnergy(uavSig{2,eventID})
        if yEnergy >= zEnergy
            % cut 32 bits out from y
            FP_IMU{eventID} = fingerprintUAV{1, eventID}(duration{durationID});
            FP_CAM{eventID} = fingerprintCAM{1, eventID}(duration{durationID});
        else
            % cut 32 bits out from z
            FP_IMU{eventID} = fingerprintUAV{2, eventID}(duration{durationID});
            FP_CAM{eventID} = fingerprintCAM{2, eventID}(duration{durationID});
        end

    end
    confusionMatrixDuration{durationID} = zeros(eventNum);
    for originalID = 1:eventNum
        for compareID = 1:eventNum
            confusionMatrixDuration{durationID}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} ); 
        end
    end

    figure;imagesc(confusionMatrixDuration{durationID});axis equal;
end

for i = 1:4
    paired{i} = [];
    nonpaired{i} = [];
    for gt = 1:eventNum
        paired{i} = [paired{i}, confusionMatrixDuration{i}(gt,gt)];
        for cp = 1:eventNum
            if cp == gt
                continue;
            end
            nonpaired{i} = [nonpaired{i}, confusionMatrixDuration{i}(gt,cp)]; 
        end
    end
end

allEvent{1} = [paired{1}; paired{2}; paired{3}; paired{4}]';
allEvent{2} = [nonpaired{1}; nonpaired{2}; nonpaired{3}; nonpaired{4}]';

figure;
addpath('./aboxplot');
aboxplot(allEvent);

%% amplitude
eventNum = 5;
durationID = 2;
for amplitudeID = 1:3
    if amplitudeID == 2
        load('mid_40cm_20s.mat');
    elseif amplitudeID == 3
        load('mid_80cm_20s.mat');
    end
    for eventID = 1:eventNum
        amplitudeID
        eventID
        yEnergy = signalEnergy(uavSig{1,eventID})
        zEnergy = signalEnergy(uavSig{2,eventID})
        if yEnergy >= zEnergy
            % cut 32 bits out from y
            FP_IMU{eventID} = fingerprintUAV{1, eventID}(duration{amplitudeID});
            FP_CAM{eventID} = fingerprintCAM{1, eventID}(duration{amplitudeID});
        else
            % cut 32 bits out from z
            FP_IMU{eventID} = fingerprintUAV{2, eventID}(duration{amplitudeID});
            FP_CAM{eventID} = fingerprintCAM{2, eventID}(duration{amplitudeID});
        end

    end
    confusionMatrixAmplitude{amplitudeID} = zeros(eventNum);
    for originalID = 1:eventNum
        for compareID = 1:eventNum
            confusionMatrixAmplitude{amplitudeID}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} ); 
        end
    end

    figure;imagesc(confusionMatrixAmplitude{amplitudeID});axis equal;
end

for i = 1:3
    paired{i} = [];
    nonpaired{i} = [];
    for gt = 1:eventNum
        paired{i} = [paired{i}, confusionMatrixAmplitude{i}(gt,gt)];
        for cp = 1:eventNum
            if cp == gt
                continue;
            end
            nonpaired{i} = [nonpaired{i}, confusionMatrixAmplitude{i}(gt,cp)]; 
        end
    end
end

allEvent{1} = [paired{1}; paired{2}; paired{3}; paired{4}]';
allEvent{2} = [nonpaired{1}; nonpaired{2}; nonpaired{3}; nonpaired{4}]';

figure;
addpath('./aboxplot');
aboxplot(allEvent);

%% velocity
eventNum = 5;
durationID = 2;
for velocityID = 1:3
    if velocityID == 1
        load('slow2_20cm_20s.mat');
    elseif velocityID == 2
        load('mid_20cm_20s.mat');
    elseif velocityID == 3
        load('fast2_20cm_20s.mat');
    end
    for eventID = 1:eventNum
        velocityID
        eventID
        yEnergy = signalEnergy(uavSig{1,eventID})
        zEnergy = signalEnergy(uavSig{2,eventID})
%         if yEnergy >= zEnergy
%             % cut 32 bits out from y
%             FP_IMU{eventID} = fingerprintUAV{1, eventID}(duration{velocityID});
%             FP_CAM{eventID} = fingerprintCAM{1, eventID}(duration{velocityID});
%         else
            % cut 32 bits out from z
            FP_IMU{eventID} = fingerprintUAV{2, eventID}(duration{velocityID});
            FP_CAM{eventID} = fingerprintCAM{2, eventID}(duration{velocityID});
%         end

    end
    confusionMatrixVelocity{velocityID} = zeros(eventNum);
    for originalID = 1:eventNum
        for compareID = 1:eventNum
            confusionMatrixVelocity{velocityID}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} ); 
        end
    end

    figure;imagesc(confusionMatrixVelocity{velocityID});axis equal;
end

for i = 1:3
    paired{i} = [];
    nonpaired{i} = [];
    for gt = 1:eventNum
        paired{i} = [paired{i}, confusionMatrixVelocity{i}(gt,gt)];
        for cp = 1:eventNum
            if cp == gt
                continue;
            end
            nonpaired{i} = [nonpaired{i}, confusionMatrixVelocity{i}(gt,cp)]; 
        end
    end
end

allEvent{1} = [paired{1}; paired{2}; paired{3};]';
allEvent{2} = [nonpaired{1}; nonpaired{2}; nonpaired{3};]';

figure;
addpath('./aboxplot');
aboxplot(allEvent);
