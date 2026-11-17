function terrain_map = deform_terrain(terrain_map, impact_x, radius, depth)
    x = terrain_map(:, 1);
    y = terrain_map(:, 2);

    % Find terrain points within the blast radius
    dx = abs(x - impact_x);
    in_crater = dx < radius;

    % Semi-circular crater profile (deepest at center, 0 at radius edge)
    crater_cut = depth * sqrt(max(0, 1 - (dx(in_crater) / radius).^2));

    % Lower the terrain height
    y(in_crater) = y(in_crater) - crater_cut;

    % Optional: prevent digging infinitely deep below the bottom of the map
    y = max(y, -28);

    terrain_map(:, 2) = y;
end
