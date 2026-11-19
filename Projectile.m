classdef Projectile < handle
    properties (Access = private)
        % initial states of projectile
        r0 (1,2) double = zeros(1, 2);
        v0 (1,2) double = zeros(1, 2);
        launch_angle double = 0;

        % integrated states of projectile
        r (1,2) double = zeros(1, 2);
        v (1,2) double = zeros(1, 2);


        % if the projectile has hit the ground or not
        ground = false;

        % weapon stats
        damage double = 35;
        hit_radius double = 3.5;
        crater_radius double = 8;
        crater_depth double = 6;
    end

    methods
        function obj = Projectile(r_0, launch_speed, angle_rad, weapon)
            arguments
                r_0 (1,2) double
                launch_speed double
                angle_rad double
                weapon.damage double = 35
                weapon.hit_radius double = 3.5
                weapon.crater_radius double = 8
                weapon.crater_depth double = 6
            end
            obj.r0 = r_0;
            obj.launch_angle = angle_rad;
            obj.v0 = launch_speed * [cos(angle_rad), sin(angle_rad)];
            obj.r = obj.r0;
            obj.v = obj.v0;

            obj.damage = weapon.damage;
            obj.hit_radius = weapon.hit_radius;
            obj.crater_radius = weapon.crater_radius;
            obj.crater_depth = weapon.crater_depth;
        end

        function update(obj, dt, ground_height)
            % update kinematics
            obj.v = obj.v + ([0, -9.81]) * dt;
            obj.r = obj.r + obj.v * dt;

            % ground collision
            if obj.r(2) <= ground_height
                obj.r(2) = ground_height;
                obj.v(2) = max(obj.v(2), 0);
                obj.ground = true;
            else
                obj.ground = false;
            end
        end

        function pos = get_pos(obj)
            pos = obj.r;
        end

        function gnd = has_hit_ground(obj)
            gnd = obj.ground;
        end

        function dmg = get_damage(obj)
            dmg = obj.damage;
        end

        function hr = get_hit_radius(obj)
            hr = obj.hit_radius;
        end

        function [rad, dep] = get_crater_params(obj)
            rad = obj.crater_radius;
            dep = obj.crater_depth;
        end
    end
end
