% tank class
classdef Tank < handle
    properties
        % position of the tank in 2d space
        r (1,2) double = [0 0]

        % tank mass
        m

        % tank velocity in 2D space
        v (1,2) double = [0 0]

        % tank acceleration in 2D space
        a (1,2) double = [0 0]

        % tank orientation in radians (attidue)
        att (1,1) double = 0

        % tank angular velocity in radians per second
        w (1,1) double = 0

        % tank cannon orientation
        cannonOrientation (1,1) double = 0

    end
    properties (Constant)
        g = 9.80665;
    end

    methods
        function obj = Tank(pos)
            arguments
                pos (1,2) double
            end
            obj.r = pos;
        end

        function update(dt)
            obj.v = obj.v + obj.a * dt;
            obj.r = obj.r + obj.v * dt;
            obj.w = obj.w;
            obj.att = obj.att + obj.w * dt;
        end

    end
end