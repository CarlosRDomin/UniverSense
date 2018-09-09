clear; close all;clc;
eventNum = 10;
sharedSize = 128:128+512;

%% axis comparison
for axisID = 1:3
    % id
    for personID = 1:5
        if personID == 1
            load('human_1.mat');
        elseif personID == 2
            load('human_2.mat');
        elseif personID == 3
            load('human_3.mat');
        elseif personID == 4
            load('human_4.mat');
        elseif personID == 5
            load('human_5.mat');
        end
        
        energySet{personID, 1} = [];
        energySet{personID, 2} = [];
        
        for eventID = 1:eventNum
            personID
            eventID
            if axisID == 1
                FP_IMU{eventID} = fingerprintUAV{1, eventID}(sharedSize);
                FP_CAM{eventID} = fingerprintCAM{1, eventID}(sharedSize);
                SIG_IMU{eventID} = uavSig{1, eventID}(sharedSize);
                SIG_CAM{eventID} = camSig{1, eventID}(sharedSize);
            elseif axisID == 2
                FP_IMU{eventID} = fingerprintUAV{2, eventID}(sharedSize);
                FP_CAM{eventID} = fingerprintCAM{2, eventID}(sharedSize);
                SIG_IMU{eventID} = uavSig{2, eventID}(sharedSize);
                SIG_CAM{eventID} = camSig{2, eventID}(sharedSize);
            elseif axisID == 3
                axisYEnergy = signalEnergy(uavSig{1, eventID});
                axisZEnergy = signalEnergy(uavSig{2, eventID});
                energySet{personID, 1} = [energySet{personID, 1}, axisYEnergy];
                energySet{personID, 2} = [energySet{personID, 2}, axisZEnergy];
                
                if axisYEnergy > axisZEnergy
                    FP_IMU{eventID} = fingerprintUAV{1, eventID}(sharedSize);
                    FP_CAM{eventID} = fingerprintCAM{1, eventID}(sharedSize);
                    SIG_IMU{eventID} = uavSig{1, eventID}(sharedSize);
                    SIG_CAM{eventID} = camSig{1, eventID}(sharedSize);
                else
                    FP_IMU{eventID} = fingerprintUAV{2, eventID}(sharedSize);
                    FP_CAM{eventID} = fingerprintCAM{2, eventID}(sharedSize);
                    SIG_IMU{eventID} = uavSig{2, eventID}(sharedSize);
                    SIG_CAM{eventID} = camSig{2, eventID}(sharedSize);
                end
            end
        end
        confusionMatrixVelocity{personID} = zeros(eventNum);
    %     similarityMatrixVelocity{personID} = zeros(eventNum);

        for originalID = 1:eventNum
            for compareID = 1:eventNum
                confusionMatrixVelocity{personID}(originalID, compareID) = compareSignature( FP_IMU{originalID}, FP_CAM{compareID} );
    %             similarityMatrixVelocity{personID}(originalID, compareID) = compareSignal( SIG_IMU{originalID}, SIG_CAM{compareID} ); 

            end
        end

    %     figure;imagesc(confusionMatrixVelocity{velocityID});axis equal;
    end

    for i = 1:5
        confusion{i} = [];
        selfConfusion{i} = [];
        similarity{i} = [];
        for gt = 1:eventNum
            confusion{i} = [confusion{i}, confusionMatrixVelocity{i}(gt,gt)];
    %         similarity{i} = [similarity{i}, similarityMatrixVelocity{i}(gt,gt)];
            for cp = 1:eventNum
                if cp == gt
                    continue;
                else
                    selfConfusion{i} = [selfConfusion{i}, confusionMatrixVelocity{i}(gt,cp)];
                end
            end
        end
    end
    
    

% allEvent{1} = [similarity{1}; similarity{2}; similarity{3}; similarity{4};similarity{5};]';
    allEvent{axisID} = [confusion{1}; confusion{2}; confusion{3}; confusion{4}; confusion{5};]';
    selfEvent{axisID} = [selfConfusion{1};selfConfusion{2};selfConfusion{3};selfConfusion{4};selfConfusion{5};]';
end

mean(reshape(allEvent{1},50,1))
std(reshape(allEvent{1},50,1))

mean(reshape(allEvent{2},50,1))
std(reshape(allEvent{2},50,1))

mean(reshape(allEvent{3},50,1))
std(reshape(allEvent{3},50,1))

figure;
addpath('./aboxplot');
aboxplot(allEvent);

sigVSmulti{1} = [allEvent{1};allEvent{2}];
sigVSmulti{2} = [allEvent{3};NaN(10,5)];

figure;
addpath('./aboxplot');
aboxplot(sigVSmulti);

energyCompare = zeros(5,2);
for i = 1:5
    for j = 1:2
        energyCompare(i,j) = mean(energySet{i,j});
    end
end
mean(reshape(energyCompare,10,1))
eratio = energyCompare./energyCompare(1,1)

        

%% participant comparison
confusionAllDiffUser = [];
for personID = 1:5
    load(['human_' num2str(personID) '.mat']);
    uavSigA = uavSig;
    uavFPA = fingerprintUAV;
    camSigA = camSig;
    camFPA = fingerprintCAM;
    for comparePID = 1:5
        if comparePID == personID
            continue;
        end
        load(['human_' num2str(comparePID) '.mat']);
        uavSigB = uavSig;
        uavFPB = fingerprintUAV;
        camSigB = camSig;
        camFPB = fingerprintCAM;
        
        for eventID = 1:eventNum
            axisYEnergyA = signalEnergy(uavSigA{1, eventID});
            axisZEnergyA = signalEnergy(uavSigA{2, eventID});
            if axisYEnergyA > axisZEnergyA
                FP_CAM_A = camFPA{1, eventID}(sharedSize);
            else
                FP_CAM_A = camFPA{2, eventID}(sharedSize);
            end
            
            for compareEvent = 1:eventNum
                
                axisYEnergyB = signalEnergy(uavSigB{1, compareEvent});
                axisZEnergyB = signalEnergy(uavSigB{2, compareEvent});
                if axisYEnergyB > axisZEnergyB
                    FP_IMU_B = uavFPB{1, compareEvent}(sharedSize);
                else
                    FP_IMU_B = uavFPB{2, compareEvent}(sharedSize);
                end
                
                confusionAllDiffUser = [confusionAllDiffUser; ...
                            compareSignature( FP_IMU_B, FP_CAM_A);];

            end
        end
    end
end


resultMean = [mean(reshape(allEvent{3},50,1)), mean(reshape(selfEvent{3},450,1)), mean(confusionAllDiffUser)];
resultStd = [std(reshape(allEvent{3},50,1)), std(reshape(selfEvent{3},450,1)), std(confusionAllDiffUser)];
figure;
bar(resultMean);hold on;
errorbar(resultMean,resultStd);hold off;


compareSame = [reshape(allEvent{3},50,1); NaN(2400,1)];
compareDiff = [reshape(selfEvent{3},450,1);confusionAllDiffUser];

com{1} = compareSame;
com{2} = compareDiff;
figure;
aboxplot(com);hold on;
plot([0.5,1.5],[0.8,0.8]);hold off;


thResults = [];
for th = 0.6:0.05:0.90
    a = sum(reshape(allEvent{3},50,1) >= th)/50;
    b = sum(reshape(selfEvent{3},450,1) >= th)/450;
    c = sum(confusionAllDiffUser >= th)/length(confusionAllDiffUser);
    thResults = [thResults; a,b,c];
end
figure;
plot(0.6:0.05:0.9,thResults);

tp = sum(reshape(allEvent{3},50,1) >= 0.8)/50;
tn = (sum(reshape(selfEvent{3},450,1) < 0.8) + sum(confusionAllDiffUser < 0.8))/(450+2000);
fp = 1-tp;
fn = 1-tn;

precision = tp/(tp+fp);
recall = tp/(tp+fn);
f1score = 2*precision*recall/(recall+precision)