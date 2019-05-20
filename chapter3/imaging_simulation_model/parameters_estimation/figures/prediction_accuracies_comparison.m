% comparisons of the proposed parameters estimation method with PCA and
% radial basis functions network (RBFN) method


%% Nikon D3x

clear; close all; clc;

DELTA_LAMBDA = 5;
CMAP = [176,85,116;...
        215,186,196;...
        248,126,123;...
        248,200,198;...
        250,184,127;...
        250,217,189;...
        220,205,166;...
        230,225,211;...
        94,159,163;...
        192,214,215]/255;

data_path = load('global_data_path.mat');

% load data
loss = load(fullfile(data_path.path, 'imaging_simulation_model\parameters_estimation\responses\NIKON_D3x\validation.mat'));
loss_pca = load(fullfile(data_path.path, 'imaging_simulation_model\parameters_estimation\responses\NIKON_D3x\validation_pca.mat'));
loss_rbfn = load(fullfile(data_path.path, 'imaging_simulation_model\parameters_estimation\responses\NIKON_D3x\validation_rbfn.mat'));

% comparison for 3 validation sets
validation_sets_names = {'diff_illuminant',...
                         'diff_objects',...
                         'diff_illuminant_objects'};
for s = 1:3
    % M*5 matrix, where M is the number of samples
    losses = [loss_pca.loss.(validation_sets_names{s}),...
              loss_rbfn.loss.(validation_sets_names{s}),...
              loss.loss_lin.(validation_sets_names{s}),...
              loss.loss_nonl.(validation_sets_names{s}),...
              loss.loss.(validation_sets_names{s})];
    M = size(losses, 1);
	losses_means = mean(losses, 1);
    losses_std_errs = std(losses, [], 1) / sqrt(M);
    tscore = tinv(0.95, M-1);
    err_bars = tscore * losses_std_errs;
    
    figure('color', 'w', 'unit', 'centimeters', 'position', [5, 5, 24, 16]);
    hold on; box on;
    
    x = [1, 2, 4, 5, 7, 8, 10, 11, 13, 14];
    hbar = bar(x, losses_means,...
               'barwidth', 0.85, 'linewidth', 2, 'facecolor', 'flat');
    set(hbar, 'CData', CMAP);
    
    herrbar = errorbar(x, losses_means, err_bars,...
                       'linestyle', 'none', 'color', 'k', 'linewidth', 2,...
                       'capsize', 12);
         
	xlim([0, 15]);
    ylim([0, 6]);

	xticklabels = {'PCA',...
                   'RBFN',...
                   'PInv',...
                   'Nonlinear',...
                   'Optimal'};
    set(gca, 'linewidth', 2, 'fontname', 'times new roman', 'fontsize', 22,...
             'xtick', [1.5:3:13.5], 'xticklabel', xticklabels, 'ytick', 1:6, 'ticklength', [0, 0],...
             'ygrid', 'on');
    ylabel('Color Difference',...
           'fontname', 'times new roman', 'fontsize', 26);
    
	text(9, 5, {'Left Bar: $\Delta{}E_{ab}^\ast$', 'Right Bar: $\Delta{}E_{00}$'},...
         'fontname', 'times new roman', 'fontsize', 26,...
         'interpreter', 'latex');
end


% comparisons of the proposed parameters estimation method with PCA and
% radial basis functions network (RBFN) method


%% SONY ILCE7

clearvars -except DELTA_LAMBDA CMAP data_path

% load data
loss = load(fullfile(data_path.path, 'imaging_simulation_model\parameters_estimation\responses\ILCE7\validation.mat'));
loss_pca = load(fullfile(data_path.path, 'imaging_simulation_model\parameters_estimation\responses\ILCE7\validation_pca.mat'));
loss_rbfn = load(fullfile(data_path.path, 'imaging_simulation_model\parameters_estimation\responses\ILCE7\validation_rbfn.mat'));

% comparison for 3 validation sets
validation_sets_names = {'diff_illuminant',...
                         'diff_objects',...
                         'diff_illuminant_objects'};
for s = 1:3
    % M*5 matrix, where M is the number of samples
    losses = [loss_pca.loss.(validation_sets_names{s}),...
              loss_rbfn.loss.(validation_sets_names{s}),...
              loss.loss_lin.(validation_sets_names{s}),...
              loss.loss_nonl.(validation_sets_names{s}),...
              loss.loss.(validation_sets_names{s})];
    M = size(losses, 1);
	losses_means = mean(losses, 1);
    losses_std_errs = std(losses, [], 1) / sqrt(M);
    tscore = tinv(0.95, M-1);
    err_bars = tscore * losses_std_errs;
    
    figure('color', 'w', 'unit', 'centimeters', 'position', [5, 5, 24, 16]);
    hold on; box on;
    
    x = [1, 2, 4, 5, 7, 8, 10, 11, 13, 14];
    hbar = bar(x, losses_means,...
               'barwidth', 0.85, 'linewidth', 2, 'facecolor', 'flat');
    set(hbar, 'CData', CMAP);
    
    herrbar = errorbar(x, losses_means, err_bars,...
                       'linestyle', 'none', 'color', 'k', 'linewidth', 2,...
                       'capsize', 12);
         
	xlim([0, 15]);
    ylim([0, 7]);

	xticklabels = {'PCA',...
                   'RBFN',...
                   'PInv',...
                   'Nonlinear',...
                   'Optimal'};
    set(gca, 'linewidth', 2, 'fontname', 'times new roman', 'fontsize', 22,...
             'xtick', [1.5:3:13.5], 'xticklabel', xticklabels, 'ytick', 1:7, 'ticklength', [0, 0],...
             'ygrid', 'on');
    ylabel('Color Difference',...
           'fontname', 'times new roman', 'fontsize', 26);
       
	text(1, 6, {'Left Bar: $\Delta{}E_{ab}^\ast$', 'Right Bar: $\Delta{}E_{00}$'},...
         'fontname', 'times new roman', 'fontsize', 26,...
         'interpreter', 'latex');
end