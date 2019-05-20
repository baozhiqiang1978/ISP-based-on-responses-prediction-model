clear; close all; clc;

GAINS = [0.3535, 0.1621, 0.3489]; % ISO100

data_path = load('global_data_path.mat');

% load parameters of imaging simulation model
params_dir = fullfile(data_path.path,...
                      'imaging_simulation_model\parameters_estimation\responses\NIKON_D3x\camera_parameters.mat');
load(params_dir);

std_gamut = standard_gamut_calib(params, GAINS);

save_dir = fullfile(data_path.path,...
                    'white_balance_correction\gamut_mapping\NIKON_D3x\std_gamut.mat');
save(save_dir, 'std_gamut');