% tank class
classdef Tank < handle
    properties (Access = private)
        % position of the tank in the 2d side view cs
        r (1,2) double = [0, 0];

        % tank mass
        m;

        % tank velocity in 2D space
        v (1,2) double = [0, 0];

        % tank acceleration in 2D space
        a (1,2) double = [0, 0];

        % tank orientation in radians (attidue)
        att (1,1) double = 0;

        % tank angular velocity in radians per second
        w (1,1) double = 0;

        % tank cannon orientation
        cannonOrientation (1,1) double = 0;

        % is touching ground
        ground = false;

    end

    methods
        function obj = Tank(pos)
            arguments
                pos (1,2) double
            end
            obj.r = pos;
        end

        function update(obj, dt, ground_height)
            % update kiniematics
            obj.v = obj.v + (obj.a + [0 -9.81]) * dt;
            obj.r = obj.r + obj.v * dt;

            % ground collission
            if obj.r(2) <= ground_height
                obj.r(2) = ground_height;
                obj.v(2) = max(obj.v(2), 0);
                obj.ground = true;
            else
                obj.ground = false;
            end

            % update attitude
            obj.w = obj.w;
            obj.att = obj.att + obj.w * dt;
        end

        function pos = get_pos(obj)
            pos = obj.r;
        end

        function vel = get_vel(obj)
            vel = obj.v;
        end

        % use to either get 
        function drive(obj, direction)
            switch direction
                case 'left'
                    if obj.v(1) > -3.0
                        obj.a(1) = -0.3;
                    else
                        obj.a(1) = 0;
                    end
                case 'right'
                    if obj.v(1) < 3.0
                        obj.a(1) = 0.3;
                    else
                        obj.a(1) = 0;
                    end
                otherwise
                    obj.a(1) = 0;
                    obj.v(1) = 0;
            end
        end


    end
end