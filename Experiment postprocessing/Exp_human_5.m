close all;clear;clc;
addpath(genpath([fileparts(mfilename('fullpath')) '/Helper functions']));
data = loadRealExperimentData(struct('datetime',{'2017-10-11 21-44-05'}, 'ch','80'), [], 2, 13, 10);
exp = readNPZ(['/Users/shijiapan/Google Drive/log/80/2017-10-11 21-44-05/log_experiment_running_80_2017-10-11_21-44-05.npz']);
expStart = exp.tFloat(exp.measured == 1);
expStop = exp.tFloat(exp.measured == 0);
expStop(1:2) = [];
cameraIdxOffset = 0.18;
eventPadding = 0;
UAVgravityFactor = 8;%9.81;
axisCount = 0;

offsetCali = [46, 48];
for strAxCell = {'Y', 'Z'}
    axisCount = axisCount + 1;
    if axisCount == 1
        axisYP = 1;
    else
        axisYP = 1;
    end
	strAx = strAxCell{:};
	figure; plot(data.a_UAV_orig.(strAx).tFloat, UAVgravityFactor.*data.a_UAV_orig.(strAx).measured, 'g', 'LineWidth',2); hold on; 
    plot(data.a_UAV.(strAx).tFloat, UAVgravityFactor.*(data.a_UAV.(strAx).measured), 'r', 'LineWidth',2); 
    plot(data.a_cam.(strAx).tFloat+cameraIdxOffset, (data.a_cam.(strAx).measured), 'b', 'LineWidth',2); legend('a_{UAV},raw', 'a_{UAV},filt', 'a_{cam}');
    
    offsetIdx = find(data.a_UAV.(strAx).tFloat >= offsetCali(1) & data.a_UAV.(strAx).tFloat < offsetCali(2));
    offsetIdx2 = find(data.a_cam.(strAx).tFloat+cameraIdxOffset >= offsetCali(1) & data.a_cam.(strAx).tFloat+cameraIdxOffset < offsetCali(2));
    uavOffset = mean(data.a_UAV.(strAx).measured(offsetIdx));
    camOffset = mean(data.a_cam.(strAx).measured(offsetIdx2));
    
    figure;
    for eventID = 1:10%length(expStart)
        eventID
        eventIdx = find(data.a_UAV.(strAx).tFloat >= expStart(eventID)-eventPadding & data.a_UAV.(strAx).tFloat < expStop(eventID)+eventPadding);
        uavSig{axisCount, eventID} = [data.a_UAV.(strAx).tFloat(eventIdx), axisYP.*(UAVgravityFactor.*(data.a_UAV.(strAx).measured(eventIdx)-uavOffset))];
        eventIdx2 = find(data.a_cam.(strAx).tFloat+cameraIdxOffset >= expStart(eventID)-eventPadding & data.a_cam.(strAx).tFloat+cameraIdxOffset < expStop(eventID)+eventPadding);
        camSig{axisCount, eventID} = [data.a_cam.(strAx).tFloat(eventIdx2)+cameraIdxOffset, (data.a_cam.(strAx).measured(eventIdx2)'-camOffset)];
        plot(uavSig{axisCount, eventID}(:,1),uavSig{axisCount, eventID}(:,2));hold on;
        plot(camSig{axisCount, eventID}(:,1),camSig{axisCount, eventID}(:,2));hold on;
        
        fingerprintUAV{axisCount, eventID} = ((uavSig{axisCount, eventID}(:,2)) > -0.15 );
        fingerprintCAM{axisCount, eventID} = ((camSig{axisCount, eventID}(:,2)) > -0.15 );
        sharedSize = 128:512+128;%min(length(fingerprintUAV{axisCount, eventID}),length(fingerprintCAM{axisCount, eventID}));
        matchingPrint{axisCount, eventID} = 1-sum(abs(fingerprintUAV{axisCount, eventID}(sharedSize) - fingerprintCAM{axisCount, eventID}(sharedSize)))./length(sharedSize);
        similarity{axisCount, eventID} = max(xcorr(signalNormalization(fingerprintUAV{axisCount, eventID}(sharedSize)), signalNormalization(fingerprintCAM{axisCount, eventID}(sharedSize))));
        
        plot(uavSig{axisCount, eventID}(:,1),fingerprintUAV{axisCount, eventID});hold on;
        plot(camSig{axisCount, eventID}(:,1),fingerprintCAM{axisCount, eventID});hold on;
    end
    hold off;
    
%     figure; plot(data.a_UAV_orig.(strAx).tFloat, UAVgravityFactor.*data.a_UAV_orig.(strAx).measured, 'b', 'LineWidth',2);
%     figure; plot(data.p_cam.(strAx).tFloat, data.p_cam.(strAx).measured, 'b', 'LineWidth',2);legend('a_{UAV},raw');
%     figure; plot(data.a_UAV.(strAx).tFloat, UAVgravityFactor.*data.a_UAV.(strAx).measured, 'b', 'LineWidth',2); legend('a_{UAV},filt');
%     figure; plot(data.a_cam.(strAx).tFloat, data.a_cam.(strAx).measured, 'b', 'LineWidth',2); legend('a_{cam}');
    
end
matchingPrint
similarity
save('human_5.mat','uavSig','camSig','fingerprintUAV','fingerprintCAM');

