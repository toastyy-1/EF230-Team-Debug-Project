function update_terrain_draw(h, terrain_map)
% UPDATE_TERRAIN_DRAW  Refresh the graphics made by draw_terrain after the
% terrain heights change (e.g. a crater).
    height = terrain_map(:,2).';
    nGrad = size(h.sky.YData, 1);
    t = linspace(0, 1, nGrad).';
    yFill = height + (h.ytop - height) .* t;

    set(h.line, 'YData', height);
    set(h.ground, 'YData', [height h.ybot * ones(size(height))]);
    set(h.sky, 'YData', yFill, 'CData', yFill);
end
