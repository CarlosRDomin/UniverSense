close all;
addpath(genpath([fileparts(mfilename('fullpath')) '/Helper functions']));
data = loadRealExperimentData(struct('datetime',{'2017-10-03 22-12-51'}, 'ch','80'), [], 2, 13, 10);
UAVgravityFactor = 1;%9.81;
for strAxCell = {'X', 'Y', 'Z'}
	strAx = strAxCell{:};
	figure; plot(data.a_UAV_orig.(strAx).t, UAVgravityFactor.*data.a_UAV_orig.(strAx).measured, 'g', 'LineWidth',2); hold on; plot(data.a_UAV.(strAx).t, UAVgravityFactor.*data.a_UAV.(strAx).measured, 'r', 'LineWidth',2); plot(data.a_cam.(strAx).t, data.a_cam.(strAx).measured, 'b', 'LineWidth',2); legend('a_{UAV},raw', 'a_{UAV},filt', 'a_{cam}');
%     figure; plot(data.a_UAV_orig.(strAx).t, UAVgravityFactor.*data.a_UAV_orig.(strAx).measured, 'b', 'LineWidth',2);
%     figure; plot(data.p_cam.(strAx).t, data.p_cam.(strAx).measured, 'b', 'LineWidth',2);legend('a_{UAV},raw');
%     figure; plot(data.a_UAV.(strAx).t, UAVgravityFactor.*data.a_UAV.(strAx).measured, 'b', 'LineWidth',2); legend('a_{UAV},filt');
%     figure; plot(data.a_cam.(strAx).t, data.a_cam.(strAx).measured, 'b', 'LineWidth',2); legend('a_{cam}');
    
end