%% Quadruped robot parameters

% Copyright 2019-2022 The MathWorks Inc.

%% General parameters
density = 800;
foot_density = 1500;
world_damping = 1.25;
world_rot_damping = 0.25;
if ~exist('actuatorType','var')
    actuatorType = 2;
end

%% Inputs
gaitPeriod = 0.5;
time = linspace(0,gaitPeriod,10)';
ankle_motion = deg2rad([-7.5 11 11 5 0 -10 -7.5]');
knee_motion = deg2rad([10, -5, 2.5, -10, -10, 15, 10]');
hip_motion = deg2rad([-10, -7.5, -15, 10, 15, 10, -10]');

%% Contact/friction parameters
contact_stiffness = 2500;
contact_damping = 100;
mu_k = 0.6;
mu_s = 0.8;
mu_vth = 0.1;
height_plane = 0.050;
plane_x = 25;
plane_y = 3;
contact_point_radius = 1e-4;

%% Foot parameters
foot_x = 8;
foot_y = 6;
foot_z = 1;
foot_offset = [-1 0 0];

%% Leg parameters
leg_radius = 0.75;
lower_leg_length = 10;
upper_leg_length = 10;

%% Torso parameters
torso_y = 10;
torso_x = 5;
torso_z = 8;
torso_offset_z = -2;
torso_offset_x = -0.5;
init_height = foot_z + lower_leg_length + upper_leg_length + ...
              torso_z/2 + torso_offset_z + height_plane/2;

%% Joint parameters
joint_damping = 1;
joint_stiffness = 1;
motion_time_constant = 0.01; %0.025;

%% Joint controller parameters
hip_servo_kp = 60;
hip_servo_ki = 10;
hip_servo_kd = 20;
knee_servo_kp = 60;
knee_servo_ki = 5;
knee_servo_kd = 10;
ankle_servo_kp = 20;
ankle_servo_ki = 4;
ankle_servo_kd = 8;
deriv_filter_coeff = 100;
max_torque = 20;

%% Electric motor parameters
motor_resistance = 1;
motor_constant = 0.02;
motor_inertia = 0;
motor_damping = 0;
motor_inductance = 1.2e-6;
gear_ratio = 50;

% Body and leg geometry
L = 1;        % Distance b/w front and rear hip joints (m)
L_back = 1.5; % Length of the torso (m)
l1 = 0.5517;  % Link #1 length (m)
l2 = 0.5517;  % Link #2 length (m)

% Robot mass
M = 2;      % Torso mass (kg)
m1 = 0.2;   % Leg link #1 mass (kg)
m2 = 0.2;   % Leg link #2 mass (kg)

% Moment of inertia (kg-m^2)
Ixx = 1/12 * M * ((0.1*L_back)^2 + (0.1*L_back)^2);
Iyy = 1/12 * M * (L_back^2 + (0.1*L_back)^2);
Izz = 1/12 * M * (L_back^2 + (0.1*L_back)^2);
torso_MOI = [Ixx, Iyy, Izz];

% Gravity (m/s^2)
g = -9.81;

% Sample Time (s)
Ts = 0.02;

% Simulation Time (s)
Tf = 10;

% Desired height of the torso (m)
h_final = 0.75;

% Initial body height and foot displacement (m)
init_foot_disp_x = 0;
init_body_height = h_final;

% Initial joint angles (rad) and velocities (rad/s)
d2r = pi/180;
init_ang_FL = d2r * quadrupedInverseKinematics(init_foot_disp_x,-init_body_height,l1,l2);
init_ang_FR = init_ang_FL;
init_ang_RL = init_ang_FL;
init_ang_RR = init_ang_FL;
init_whip_FL = 0;
init_whip_FR = 0;
init_whip_RL = 0;
init_whip_RR = 0;

% initial height (m)
foot_height = 0.05*l2*(1-sin(2*pi-(3*pi/2+init_ang_FL(1)+init_ang_FL(2))));
y_init = init_body_height + foot_height;

% Initial body speeds in x,y (m/s)
vx_init = 0;
vy_init = 0;

% Contact friction properties
mu_kinetic = 0.88;
mu_static = 0.9;
v_thres = 0.001;

% Ground properties
ground.stiffness = 1e3;
ground.damping = 1e2;
ground.length = 100;
ground.width = 1;
ground.depth = 0.05;

% Hip and Knee Joint properties
joint.stiffness = 0;
joint.damping = 8;
joint.limitStiffness = 500;
joint.limitDamping = 50;
joint.transitionWidth = 2 * d2r;
hip_eq_angle = 0;
knee_eq_angle = 0;

% Define limits on variables
u_max = 10;                        % max joint torque = +/- u_max
y_min = 0.5;                       % min height of body from ground
z_max = 0.5;                       % max translation in z
vx_max = 2.5;                      % max horizontal speed of body
vy_max = 2.5;                      % max vertical speed of body
vz_max = 2.5;                      % max lateral speed of body
roll_max = 10 * d2r;               % max roll angle of body
pitch_max = 10 * d2r;              % max pitch angle of body
yaw_max = 20 * d2r;                % max yaw angle of body
omega_x_max = pi/2;                % max angular speed about x
omega_y_max = pi/2;                % max angular speed about x
omega_z_max = pi/2;                % max angular speed about x
q_hip_min = -120 * d2r;            % hip and knee joint angle limit
q_hip_max = -30 * d2r;
q_knee_min = 60 * d2r;
q_knee_max = 140 * d2r;
w_max = 2*pi*60/60;                % hip and knee joint angular speed limit
y_max = l1*cos(q_hip_max) + l2*cos(q_hip_max+q_knee_min);  % max height of body from ground
normal_force_max = ((M+4*m1+4*m2)*abs(g))/4;
friction_force_max = mu_static * normal_force_max;
