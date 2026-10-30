

classdef Projectile < handle
    properties (Access = private)
        % initial states of projectile
        r0 (1,2) double = [0, 0];
        v0 (1,2) double = [0, 0];
        launch_angle double = 0;

        % integrated states of projectile
        r (1,2) double = [0, 0];
        v (1,2) double = [0, 0];

        % if the projectile has hit the ground or not
        ground = false;

    end

    methods
        function obj = Projectile(r_0, launch_speed, angle_rad)
            arguments
                r_0 (1,2) double
                launch_speed double
                angle_rad double
            end
            obj.r0 = r_0;
            obj.launch_angle = angle_rad;
            obj.v0 = launch_speed * [cos(angle_rad), sin(angle_rad)];
            obj.r = obj.r0;
            obj.v = obj.v0;
        end

        function update(obj, dt, ground_height)
            % update kinematics
            obj.v = obj.v + ([0, -9.81]) * dt;
            obj.r = obj.r + obj.v * dt;

            % ground collission
            if obj.r(2) <= ground_height
                obj.r(2) = ground_height;
                obj.v(2) = max(obj.v(2), 0);
                obj.ground = true;
            else
                obj.ground = false;
            end
        end

        function gnd = has_hit_ground(obj)
            gnd = obj.ground;
        end
    end
end