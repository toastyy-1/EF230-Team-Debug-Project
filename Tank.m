% tank class
classdef Tank < handle
    properties (Access = private)
        % position of the tank in the 2d side view cs
        r (1,2) double = zeros(1, 2);

        % tank mass
        m;

        % tank velocity in 2D space
        v (1,2) double = zeros(1, 2);

        % tank acceleration in 2D space
        a (1,2) double = zeros(1, 2);

        % tank orientation in radians (attitude)
        att (1,1) double = 0;

        % tank angular velocity in radians per second
        w (1,1) double = 0;

        % tank cannon orientation
        cannonOrientation (1,1) double = 0;

        % is touching ground
        ground = false;

        % tank health
        health (1,1) double = 100;

        % fuel measured in map units (default = 20 units per turn)
        fuel (1,1) double = 20;
        max_fuel (1,1) double = 20;
    end

    methods
        function obj = Tank(pos)
            arguments
                pos (1,2) double
            end
            obj.r = pos;
        end

        function update(obj, dt, ground_height)
            old_x = obj.r(1);

            % update kinematics
            obj.v = obj.v + (obj.a + [0, -9.81]) * dt;
            obj.r = obj.r + obj.v * dt;

            % subtract exact horizontal distance driven from fuel
            if obj.a(1) ~= 0 || obj.v(1) ~= 0
                dist_moved = abs(obj.r(1) - old_x);
                obj.fuel = max(0, obj.fuel - dist_moved);
                if obj.fuel <= 0
                    obj.v(1) = 0;
                    obj.a(1) = 0;
                end
            end

            % keep tank inside map boundaries [-98, 98]
            obj.r(1) = max(-98, min(98, obj.r(1)));

            % ground collision
            if obj.r(2) <= ground_height
                obj.r(2) = ground_height;
                obj.v(2) = max(obj.v(2), 0);
                obj.ground = true;
            else
                obj.ground = false;
            end

            % update attitude
            obj.att = obj.att + obj.w * dt;
        end

        function pos = get_pos(obj)
            pos = obj.r;
        end

        function vel = get_vel(obj)
            vel = obj.v;
        end

        function aim(obj, target)
            obj.cannonOrientation = atan2(target(2) - obj.r(2), target(1) - obj.r(1));
        end

        function ang = get_cannon_angle(obj)
            ang = obj.cannonOrientation;
        end

        function drive(obj, direction)
            if obj.fuel <= 0
                obj.a(1) = 0;
                obj.v(1) = 0;
                return;
            end

            switch direction
                case 'left'
                    if obj.v(1) > -4.0
                        obj.a(1) = -1.2;
                    else
                        obj.a(1) = 0;
                    end
                case 'right'
                    if obj.v(1) < 4.0
                        obj.a(1) = 1.2;
                    else
                        obj.a(1) = 0;
                    end
                otherwise
                    obj.a(1) = 0;
                    obj.v(1) = 0;
            end
        end

        function take_damage(obj, amount)
            obj.health = max(0, obj.health - amount);
        end

        function hp = get_health(obj)
            hp = obj.health;
        end

        function refill_fuel(obj)
            obj.fuel = obj.max_fuel;
        end

        function f = get_fuel(obj)
            f = obj.fuel;
        end

        function upgrade_fuel(obj, bonus_units)
            obj.max_fuel = obj.max_fuel + bonus_units;
            obj.fuel = obj.max_fuel;
        end
    end
end
