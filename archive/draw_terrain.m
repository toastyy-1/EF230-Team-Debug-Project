function h = draw_terrain(ax, terrain_map, ybot, ytop)
% DRAW_TERRAIN  Draw the colored terrain (fire-gradient sky + brown ground)
% into the axes AX and return a struct of graphics handles.
%   ybot / ytop are the bottom / top y-limits of the playfield.
% Use update_terrain_draw(h, terrain_map) to refresh after deformation.
    hold(ax, 'on');

    x = terrain_map(:,1).';
    height = terrain_map(:,2).';

    % Sky: a fine grid whose vertices are colored by their y value, so
    % 'interp' shading gives a smooth gradient from the terrain up to ytop.
    nGrad = 64;
    t = linspace(0, 1, nGrad).';
    xFill = repmat(x, nGrad, 1);
    yFill = height + (ytop - height) .* t;
    h.sky = surface(ax, xFill, yFill, -2 * ones(size(yFill)), yFill, ...
        'FaceColor', 'interp', 'EdgeColor', 'none');

    % Ground: solid brown polygon from the terrain line down to the axes bottom.
    h.ground = patch(ax, 'XData', [x fliplr(x)], ...
        'YData', [height ybot * ones(size(x))], ...
        'ZData', -1 * ones(1, 2 * numel(x)), ...
        'FaceColor', [0.65 0.33 0.18], 'EdgeColor', 'none');

    % Terrain outline
    h.line = plot(ax, x, height, 'k', 'LineWidth', 1.5);

    % Red (low) -> yellow (high) "burned planet" sky colormap
    colormap(ax, [ones(nGrad, 1), linspace(0, 1, nGrad).', zeros(nGrad, 1)]);
    ax.CLim = [0 ytop];

    h.ybot = ybot;
    h.ytop = ytop;
end
