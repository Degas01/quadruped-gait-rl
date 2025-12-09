clear; close all; clc; 

% All units are m, N, kg... 

% Gravity 
g = -9.81;  


% Floor size
X_gnd = 10;  
Y_gnd = 1;   
Z_gnd = 0.1; 

r_foot = 0.05; 

L_upperLeg = 0.5;
L_lowerLeg = 0.5; 
w_leg = 2*r_foot; 

% Initial pose of the legs. 
theta0_1 = 0; 
theta0_2 = 0;  % deg
theta0_3 = 0;  % deg 

L_body = 1.2;
w_body = 0.4;
t_body = 0.2; 

m_body = 4; 
m_lowerLeg = 2;
m_upperLeg = 2;


h_body = Z_gnd/2 + r_foot + L_upperLeg*cosd(theta0_3) + L_lowerLeg*cosd(theta0_2);  


mdl = "Dog_Subsystems.slx";
blk = mdl + "/RL Agent";
open_system(mdl);


sim(mdl); 

