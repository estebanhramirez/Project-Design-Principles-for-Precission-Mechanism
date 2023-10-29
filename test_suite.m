clear
clc
addpath('C:\Program Files\MATLAB\R2023a\spacar\')

%% GLOBAL PARAMETERS
fixworld_x = 0;
fixworld_y = 0;
fixworld_z = 0;

K = 1e6;

alpha = 2;
L = K*220e-6;
F = K*42e-6;

%% TRANSLATIONAL PART PARAMETERS

L_leaf_trans = K*200e-6;
T_leaf_trans = K*5e-6;
W_leaf_trans = K*40e-6;
E_leaf_trans = (166e9)/K;
G_leaf_trans = (65e9)/K;
D_leaf_trans = 3300/K^3;
nbeams_leaf_trans = 3;

L_body_hor = K*60e-6;
T_body_hor = K*60e-6;
W_body_hor = K*40e-6;
D_body_hor = 3300/K^3;

L_body_ver = K*60e-6;
T_body_ver = K*60e-6;
W_body_ver = K*40e-6;
D_body_ver = 3300/K^3;

%% ROTATIONAL PART PARAMETERS

L_leaf_cross = L;
T_leaf_cross = K*5e-6;
W_leaf_cross = K*5e-6;
E_leaf_cross = (166e9)/K;
G_leaf_cross = (65e9)/K;
D_leaf_cross = 3300/K^3;
nbeams_leaf_cross = 3;

L_cantilever = K*500e-6;
T_cantilever = K*5e-6;
W_cantilever = K*50e-6;
E_cantilever = (166e9)/K;
G_cantilever = (65e9)/K;
D_cantilever = 3300/K^3;
nbeams_cantilever = 3;

%% NODES POSITIONS

I_cantilever = (W_cantilever*(T_cantilever^3))/12;
I_leaf_cross = (W_leaf_cross*(T_leaf_cross^3))/12;

min_side = (K*250e-6);
l1 = (-2*alpha*(E_leaf_cross*I_leaf_cross/L_leaf_cross)*(1/(E_cantilever*I_cantilever))*(L_cantilever^2))+(2*min_side)
l2 = min_side - l1

%        x                          y                               z
nodes = [
         % On-fixed world nodes
         fixworld_x                 fixworld_y + L_leaf_trans       fixworld_z                                      ;   % node 1
         fixworld_x                 fixworld_y + L_leaf_trans       fixworld_z - L_body_ver                         ;   % node 2
         % On-body 1 nodes
         fixworld_x - (l1/2)        fixworld_y                      fixworld_z                                      ;   % node 3
         fixworld_x - (l1/2)        fixworld_y                      fixworld_z - L_body_ver                         ;   % node 4
         fixworld_x                 fixworld_y                      fixworld_z                                      ;   % node 5
         fixworld_x                 fixworld_y                      fixworld_z - L_body_ver                         ;   % node 6
         fixworld_x + (l1/2)        fixworld_y                      fixworld_z                                      ;   % node 7
         fixworld_x + (l1/2)        fixworld_y                      fixworld_z - L_body_ver                         ;   % node 8
         % On-canteliver nodes
         fixworld_x - (l1/2)        fixworld_y                      fixworld_z - L_body_ver - sin(45)*L_leaf_cross  ;   % node 9
         fixworld_x + (l1/2)        fixworld_y                      fixworld_z - L_body_ver - sin(45)*L_leaf_cross  ;   % node 10
         fixworld_x + (l1/2) + l2   fixworld_y                      fixworld_z - L_body_ver - sin(45)*L_leaf_cross  ;   % node 11
        ];


%% ELEMENT CONNECTIVITY

%               p   q
elements = [
                1   5;  % element 1 (translational leaf spring)
                2   6;  % element 2 (translational leaf spring)
                5   6;  % element 3 (rigid body 1.1)
                3   5;  % element 4 (rigid body 1.2)
                5   7;  % element 5 (rigid body 1.3)
                4   6;  % element 6 (rigid body 1.4)
                6   8;  % element 7 (rigid body 1.5)
                4   10; % element 8 (crossed leaf spring)
                8   9;  % element 9 (crossed leaf spring)
                9   10; % element 10 (rigid body of length l1)
                10  11; % element 11 (rigid body of length l2)
           ];


%% NODE PROPERTIES

% node 1
nprops(1).fix = true;

% node 2
nprops(2).fix = true;

% node 3

% node 4

% node 5

% node 6

% node 7

% node 8

% node 9

% node 10

% node 11

% node 12
nprops(11).force = [0 0 F];


%% ELEMENT PROPERTIES
%Property set 1 (for the horizontal leaf springs)
eprops(1).elems    = [1,2];
eprops(1).emod     = E_leaf_trans;
eprops(1).smod     = G_leaf_trans;
eprops(1).dens     = D_leaf_trans;
eprops(1).cshape   = 'rect';
eprops(1).dim      = [W_leaf_trans T_leaf_trans];
eprops(1).orien    = [1 0 0];
eprops(1).nbeams   = nbeams_leaf_trans;
eprops(1).flex     = 1:6;
eprops(1).color    = 'grey';
eprops(1).opacity  = 0.7;
eprops(1).warping  = true;

%Property set 2 (for the horizontal rigid bodies)
eprops(2).elems    = [4, 5, 6, 7];
eprops(2).dens     = D_body_hor;
eprops(2).cshape   = 'rect';
eprops(2).dim      = [W_body_hor T_body_hor];
eprops(2).orien    = [0 0 1];
eprops(2).nbeams   = 1;
eprops(2).color    = 'darkblue';
eprops(2).warping  = true;
%Property set 3 (for the vertical rigid bodies)
eprops(3).elems    = [3];
eprops(3).dens     = D_body_ver;
eprops(3).cshape   = 'rect';
eprops(3).dim      = [W_body_ver T_body_ver];
eprops(3).orien    = [1 0 0];
eprops(3).nbeams   = 1;
eprops(3).color    = 'green';
eprops(3).warping  = true;

%Property set 4 (for the crossed hinge leaf springs)
eprops(4).elems    = [8, 9];
eprops(4).emod     = E_leaf_cross;
eprops(4).smod     = G_leaf_cross;
eprops(4).dens     = D_leaf_cross;
eprops(4).cshape   = 'rect';
eprops(4).dim      = [W_leaf_cross T_leaf_cross];
eprops(4).orien    = [0 1 0];
eprops(4).nbeams   = nbeams_leaf_cross;
eprops(4).flex     = 1:6;
eprops(4).color    = 'grey';
eprops(4).opacity  = 0.7;
eprops(4).warping  = true;

%Property set 5 (for the cantilever support rigid body)
eprops(5).elems    = [10, 11];
eprops(5).dens     = D_cantilever;
eprops(5).cshape   = 'rect';
eprops(5).dim      = [W_cantilever T_cantilever];
eprops(5).orien    = [0 1 0];
eprops(5).nbeams   = 1;
eprops(5).color    = 'green';
eprops(5).warping  = true;


%% OPTIONAL ARGUMENTS

%opt.gravity     = [0 0 -9.81];


%% RUN

out = spacarlight(nodes, elements, nprops, eprops);


%% ANALYSIS

theta_spacar = out.step(10).node(11).r_axang(1)
theta_manual = (((l1/2)+l2)*F)/(2*(E_leaf_cross*I_leaf_cross/L_leaf_cross))

max_stress_spacar = out.step(10).stressmax
max_stress_manual = abs(-(E_leaf_cross/L_leaf_cross)*theta_manual*(T_leaf_cross/2))

compliance_spacar = theta_spacar/F
compliance_manual = theta_manual/F

stiffness_manual = (2*(E_leaf_cross*I_leaf_cross/L_leaf_cross))/(((l1/2)+l2)^2)

% CHECKPOINT