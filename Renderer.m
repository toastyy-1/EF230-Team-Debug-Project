% renderer class
classdef Renderer < handle
    properties (Access = private)
        fig
        ax

        % tanks being drawn
        tanks
        points

        % keys held down
        held = string.empty;
    end

    methods
        function obj = Renderer(tanks, terrain_map)
            arguments
                tanks
                terrain_map (:,2) double
            end
            obj.tanks = tanks;

            % window that captures key presses
            obj.fig = figure('WindowKeyPressFcn', @(~, e) obj.key_down(e), 'WindowKeyReleaseFcn', @(~, e) obj.key_up(e));
            obj.ax = axes(obj.fig);
            hold(obj.ax, 'on');
            axis(obj.ax, 'equal');
            xlim(obj.ax, [min(terrain_map(:,1)), max(terrain_map(:,1))]);
            ylim(obj.ax, [-20, 60]);

            % terrain
            plot(obj.ax, terrain_map(:,1), terrain_map(:,2), 'k-', 'LineWidth', 2);

            % tank markers
            colors = lines(numel(tanks));
            for i = 1:numel(tanks)
                p = tanks(i).get_pos();
                obj.points{i} = plot(obj.ax, p(1), p(2), 'o', 'MarkerSize', 10, 'Color', colors(i,:), 'MarkerFaceColor', colors(i,:));
            end
        end

        function render(obj)
            for i = 1:numel(obj.tanks)
                p = obj.tanks(i).get_pos();
                obj.points{i}.XData = p(1);
                obj.points{i}.YData = p(2);
            end
            drawnow limitrate;
        end

        function tf = is_open(obj)
            tf = isvalid(obj.fig);
        end

        function tf = is_down(obj, key)
            tf = any(obj.held == key);
        end
    end

    methods (Access = private)
        function key_down(obj, e)
            obj.held = union(obj.held, string(e.Key));
        end

        function key_up(obj, e)
            obj.held = setdiff(obj.held, string(e.Key));
        end
    end
end
