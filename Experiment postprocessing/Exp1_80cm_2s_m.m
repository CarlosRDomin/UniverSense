close all;clc;clear;
addpath(genpath([fileparts(mfilename('fullpath')) '/Helper functions']));
data = loadRealExperimentData(struct('datetime',{'2017-10-03 22-17-18'}, 'ch','80'), [], 2, 13, 10);
% exp = readNPZ(['/Users/shijiapan/Google Drive/log/80/2017-10-03 22-17-18/log_experiment_running_80_2017-10-03_22-17-18.npz']);
% expStart = exp.tFloat(exp.measured == 0);
% expStop = exp.tFloat(exp.measured == 1);
% cameraIdxOffset = 0.25;
% eventPadding = 0.1;
% UAVgravityFactor = 3;%9.81;
% axisCount = 0;
% for strAxCell = {'Y', 'Z'}
%     axisCount = axisCount + 1;
% 	strAx = strAxCell{:};
% 	figure; plot(data.a_UAV_orig.(strAx).t, UAVgravityFactor.*data.a_UAV_orig.(strAx).measured, 'g', 'LineWidth',2); hold on; 
%     plot(data.a_UAV.(strAx).t, UAVgravityFactor.*(data.a_UAV.(strAx).measured), 'r', 'LineWidth',2); 
%     plot(data.a_cam.(strAx).t+cameraIdxOffset, (data.a_cam.(strAx).measured), 'b', 'LineWidth',2); legend('a_{UAV},raw', 'a_{UAV},filt', 'a_{cam}');
%     
%     figure;
%     for eventID = 2:16%length(expStart)
%         eventID
%         eventIdx = find(data.a_UAV.(strAx).t >= expStart(eventID)-eventPadding & data.a_UAV.(strAx).t < expStop(eventID)+eventPadding);
%         uavSig{axisCount, eventID-1} = [data.a_UAV.(strAx).t(eventIdx), 9.81.*data.a_UAV.(strAx).measured(eventIdx)];
%         eventIdx2 = find(data.a_cam.(strAx).t+cameraIdxOffset >= expStart(eventID)-eventPadding & data.a_cam.(strAx).t+cameraIdxOffset < expStop(eventID)+eventPadding);
%         camSig{axisCount, eventID-1} = [data.a_cam.(strAx).t(eventIdx2)+cameraIdxOffset, UAVgravityFactor.*data.a_cam.(strAx).measured(eventIdx2)'];
%         plot(uavSig{axisCount, eventID-1}(:,1),uavSig{axisCount, eventID-1}(:,2));hold on;
%         plot(camSig{axisCount, eventID-1}(:,1),camSig{axisCount, eventID-1}(:,2));hold on;
%     end
%     hold off;
%     
% %     figure; plot(data.a_UAV_orig.(strAx).t, UAVgravityFactor.*data.a_UAV_orig.(strAx).measured, 'b', 'LineWidth',2);
% %     figure; plot(data.p_cam.(strAx).t, data.p_cam.(strAx).measured, 'b', 'LineWidth',2);legend('a_{UAV},raw');
% %     figure; plot(data.a_UAV.(strAx).t, UAVgravityFactor.*data.a_UAV.(strAx).measured, 'b', 'LineWidth',2); legend('a_{UAV},filt');
% %     figure; plot(data.a_cam.(strAx).t, data.a_cam.(strAx).measured, 'b', 'LineWidth',2); legend('a_{cam}');
%     
% end

exp = readNPZ(['/Users/shijiapan/Google Drive/log/80/2017-10-03 22-14-52/log_experiment_running_80_2017-10-03_22-14-52.npz']);
expStart = exp.tFloat(exp.measured == 0);
expStop = exp.tFloat(exp.measured == 1);
cameraIdxOffset = 0.2;
eventPadding = 0.1;
UAVgravityFactor = 2;%9.81;
axisCount = 0;

offsetCali = [29.5, 31];
for strAxCell = {'Y', 'Z'}
    
    axisCount = axisCount + 1;
	strAx = strAxCell{:};
	figure; plot(data.a_UAV_orig.(strAx).t, UAVgravityFactor.*data.a_UAV_orig.(strAx).measured, 'g', 'LineWidth',2); hold on; 
    plot(data.a_UAV.(strAx).t, UAVgravityFactor.*(data.a_UAV.(strAx).measured), 'r', 'LineWidth',2); 
    plot(data.a_cam.(strAx).t+cameraIdxOffset, (data.a_cam.(strAx).measured), 'b', 'LineWidth',2); legend('a_{UAV},raw', 'a_{UAV},filt', 'a_{cam}');
    
    offsetIdx = find(data.a_UAV.(strAx).t >= offsetCali(1) & data.a_UAV.(strAx).t < offsetCali(2));
    offsetIdx2 = find(data.a_cam.(strAx).t+cameraIdxOffset >= offsetCali(1) & data.a_cam.(strAx).t+cameraIdxOffset < offsetCali(2));
    uavOffset = mean(data.a_UAV.(strAx).measured(offsetIdx));
    camOffset = mean(data.a_cam.(strAx).measured(offsetIdx2));
    
    expStart(1) = 7;
    figure;
    for eventID = 1:13%length(expStart)
        eventID
        eventIdx = find(data.a_UAV.(strAx).t >= expStart(eventID)-eventPadding & data.a_UAV.(strAx).t < expStop(eventID)+eventPadding);
        uavSig{axisCount, eventID} = [data.a_UAV.(strAx).t(eventIdx), (data.a_UAV.(strAx).measured(eventIdx)-uavOffset)];
        eventIdx2 = find(data.a_cam.(strAx).t+cameraIdxOffset >= expStart(eventID)-eventPadding & data.a_cam.(strAx).t+cameraIdxOffset < expStop(eventID)+eventPadding);
        camSig{axisCount, eventID} = [data.a_cam.(strAx).t(eventIdx2)+cameraIdxOffset, (data.a_cam.(strAx).measured(eventIdx2)'-camOffset)];
        plot(uavSig{axisCount, eventID}(:,1),uavSig{axisCount, eventID}(:,2));hold on;
        plot(camSig{axisCount, eventID}(:,1),camSig{axisCount, eventID}(:,2));hold on;
        
        fingerprintUAV{axisCount, eventID} = (signalNormalization(uavSig{axisCount, eventID}(:,2)) > -0.05);
        fingerprintCAM{axisCount, eventID} = (signalNormalization(camSig{axisCount, eventID}(:,2)) > -0.05);
        sharedSize = min(length(fingerprintUAV{axisCount, eventID}),length(fingerprintCAM{axisCount, eventID}));
        matchingPrint{axisCount, eventID} = 1-sum(abs(fingerprintUAV{axisCount, eventID}(1:sharedSize) - fingerprintCAM{axisCount, eventID}(1:sharedSize)))./sharedSize;
        
        plot(uavSig{axisCount, eventID}(:,1),fingerprintUAV{axisCount, eventID});hold on;
        plot(camSig{axisCount, eventID}(:,1),fingerprintCAM{axisCount, eventID});hold on;
    end
    hold off;
    
%     figure; plot(data.a_UAV_orig.(strAx).t, UAVgravityFactor.*data.a_UAV_orig.(strAx).measured, 'b', 'LineWidth',2);
%     figure; plot(data.p_cam.(strAx).t, data.p_cam.(strAx).measured, 'b', 'LineWidth',2);legend('a_{UAV},raw');
%     figure; plot(data.a_UAV.(strAx).t, UAVgravityFactor.*data.a_UAV.(strAx).measured, 'b', 'LineWidth',2); legend('a_{UAV},filt');
%     figure; plot(data.a_cam.(strAx).t, data.a_cam.(strAx).measured, 'b', 'LineWidth',2); legend('a_{cam}');
    
end
matchingPrint

save('fast_80cm_2s.mat','uavSig','camSig','fingerprintUAV','fingerprintCAM');

