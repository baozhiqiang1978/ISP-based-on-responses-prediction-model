function [img_wb, gains] = awb(img,...
                               ocp_params,...
                               neutral_region0, std_gamut, std_illuminant_rgb,...
                               xlim, ylim, grid_size,...
                               mask_region)
% auto white-balancing using gamut mapping and neutral pixels statistics

AUGMENT_RATIO = 0.02;
NEUTRAL_REGION_AREA_THRESHOLD = 1E-3;

if nargin <= 8
    mask_region = [];
end

if nargin <= 5
    xlim = [-0.6, 1.2];
    ylim = [-0.4, 0.6];
    grid_size = 128;
end

rgb = img2rgb(img, mask_region);

% gamut mapping
illuminant_gamut = gmap(rgb, ocp_params, std_gamut, std_illuminant_rgb);
[x_, y_] = centroid(polyshape(illuminant_gamut));
illuminant_gamut = poly_augment(illuminant_gamut,...
                                        [x_, y_],...
                                        AUGMENT_RATIO,...
                                        false);
                                    
intersected_neutral_region = poly2_intersect(neutral_region0, illuminant_gamut);

neutral_region_visualize(neutral_region0,...
                         illuminant_gamut,...
                         intersected_neutral_region,...
                         xlim, ylim);

if isempty(intersected_neutral_region) ||...
        polyarea(intersected_neutral_region(:, 1), intersected_neutral_region(:,2)) < NEUTRAL_REGION_AREA_THRESHOLD
    warning('intersected neutral region is too small.');
    intersected_neutral_region = neutral_region0;
end

try
    % neutral pixels statistics algorithm
    [gains, whist] = npstat(rgb, ocp_params, intersected_neutral_region, xlim, ylim, grid_size);
catch e
    warning(e.message);
    gains = grayworld(rgb);
    whist = ones(grid_size, grid_size);
end

hist_visualize(whist, intersected_neutral_region);

img_wb = img .* reshape(gains, 1, 1, 3);
img_wb = max(min(img_wb, 1), 0);

end


function neutral_region_visualize(region0, region_candidate, region_intersection,...
                                  x_lim, y_lim)
RED = [255, 84, 84]/255;
BLUE = [0, 128, 220]/255;
CYAN = [178, 224, 240]/255;

figure('color', 'w', 'unit', 'centimeters', 'position', [5, 5, 24, 18]);
hold on; box on; grid on;

if ~isempty(region_intersection) 
    patch(region_intersection(:, 1), region_intersection(:, 2), CYAN,...
          'edgecolor', 'none', 'linewidth', 2);
end

line(region0(:, 1), region0(:, 2),...
     'color', RED, 'linewidth', 2);
line(region_candidate(:, 1), region_candidate(:, 2),...
     'color', BLUE, 'linewidth', 2);

xlim(x_lim);
ylim(y_lim);

xlabel('$X_{orth}$', 'fontsize', 24, 'fontname', 'times new roman',...
       'interpreter', 'latex');
ylabel('$Y_{orth}$', 'fontsize', 24, 'fontname', 'times new roman',...
       'interpreter', 'latex');

set(gca, 'fontname', 'times new roman', 'fontsize', 22, 'linewidth', 1.5);
     
end


function gains = grayworld(rgb)
mean_rgb = mean(rgb, 1);
gains = mean_rgb(2) ./ mean_rgb;
end