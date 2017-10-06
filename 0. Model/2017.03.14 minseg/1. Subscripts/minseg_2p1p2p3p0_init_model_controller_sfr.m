%% [Init   ]: Controller: SFR with RTS: Reference Command                  

ctrl.motorDriver_v.sfr.cmd.p.x.mag = 0*0.25; % [m]
ctrl.motorDriver_v.sfr.cmd.p.y.mag = 0*0.25; % [m]

ctrl.motorDriver_v.sfr.cmd.p.x.T   = 15; % [s]
ctrl.motorDriver_v.sfr.cmd.p.y.T   = ctrl.motorDriver_v.sfr.cmd.p.x.T * 2; 
                                         % [s]

switch ui.plant.dynamics.mode

  case 0    % hardware
  ctrl.motorDriver_v.sfr.cmd.p.x.mag = 00; % [m]
  ctrl.motorDriver_v.sfr.cmd.p.y.mag = 00; % [m]

end

ctrl.motorDriver_v.sfr.cmd.p.x.f = 1 / ctrl.motorDriver_v.sfr.cmd.p.x.T; % [1/s]
ctrl.motorDriver_v.sfr.cmd.p.y.f = 1 / ctrl.motorDriver_v.sfr.cmd.p.y.T; % [1/s]

%% [Init   ]: Controller: SFR with RTS: Reference Command: Timing          

ctrl.motorDriver_v.T.cmd = max( [ctrl.motorDriver_v.T.cmd
                                 ctrl.motorDriver_v.sfr.cmd.p.x.T
                                 ctrl.motorDriver_v.sfr.cmd.p.y.T ] ); % [s]

%% [Init   ]: Controller: SFR with RTS: State-space model                  

switch ctrl.motorDriver_v.mode

case 2 % plant only

system.linear.ss.k.A = plant.linear.ss.k.A;
system.linear.ss.k.B = plant.linear.ss.k.B;

case 3 % plant plus rts
  
% rts: reference tracking system
ctrl.motorDriver_v.rts.ss.k.A = eye(2);
ctrl.motorDriver_v.rts.ss.k.B = eye(2);
ctrl.motorDriver_v.rts.ss.k.C = eye(2);
ctrl.motorDriver_v.rts.ss.k.D = zeros( size(ctrl.motorDriver_v.rts.ss.k.C, 1)  ...
                                     , size(ctrl.motorDriver_v.rts.ss.k.B, 2)  );%

% complete system
%{                                                                         

<x.p: plant                          >
<x.r: reference tracking system (rts)>
<x.s: complete system                >

 x.p.dot =  A.p * x.p + B.p * u.p
 y.p     =  C.p * x.p

 x.r.dot =  A.r * x.r + B.r * u.p
 y.r     =  C.r * x.r

<u.r     =  y.p>

 x.r.dot =  A.r * x.r + B.r * [C.p * x.p]
 y.r     =  C.r * x.r


 x.s.dot =   A.s             *  x.s   +   B.s  *  u.s

 x.s.dot = [ A.p      , 0   ] [ x.p ] + [ B.p ] [ v.l ]
           [ B.r * C.p, A.r ] [ x.r ]   [ 0   ] [ v.r ]

 y.s     =  C.s              *  x.s
%}

system.linear.ss.k.A{1,1} = plant.linear.ss.k.A;
system.linear.ss.k.A{1,2} = zeros(6,2);
system.linear.ss.k.A{2,1} = ctrl.motorDriver_v.rts.ss.k.B                  ...
                          * plant.linear.          ss.k.C([1 5],:);
system.linear.ss.k.A{2,2} = ctrl.motorDriver_v.rts.ss.k.A;


system.linear.ss.k.B{1,1} = plant.linear.ss.k.B;
system.linear.ss.k.B{2,1} = zeros(2,2);

system.linear.ss.k.A      = cell2mat( system.linear.ss.k.A );
system.linear.ss.k.B      = cell2mat( system.linear.ss.k.B );

end

%% [Init   ]: Controller: SFR with RTS: Gains: Optimal Control: LQR        

switch ctrl.motorDriver_v.mode

case 2 % plant only

switch 0
case 0
ctrl.motorDriver_v.sfr.lqr.q                                               ...
 =  [ 100 ... plant: theta
      100 ... plant: phi.x
      100 ... plant: theta.dot
      100 ... plant: phi.x.dot
      100 ... plant: phi.y
      100 ... plant: phi.y.dot
    ];
  
case 1
ctrl.motorDriver_v.sfr.lqr.q                                               ...
 =  [  20 ... plant: theta
       01 ... plant: phi.x
       01 ... plant: theta.dot
       01 ... plant: phi.x.dot
       10 ... plant: phi.y
       01 ... plant: phi.y.dot
    ];
end

ctrl.motorDriver_v.sfr.lqr.r = 1;

case 3 % plant plus rts

ctrl.motorDriver_v.sfr.lqr.q                                               ...
 =  [  05 ... plant: theta
       01 ... plant: phi.x
       01 ... plant: theta.dot
       01 ... plant: phi.x.dot
       01 ... plant: phi.y
       01 ... plant: phi.y.dot
       20 ...   rts: theta
       10 ...   rts: phi.y
    ];
  
ctrl.motorDriver_v.sfr.lqr.r = 1;
  
end

% cost function weighting matrix: state, Q
ctrl.motorDriver_v.sfr.lqr.Q = diag( ctrl.motorDriver_v.sfr.lqr.q );

assert( min( size( ctrl.motorDriver_v.sfr.lqr.Q )                          ...
              ==                                                           ... 
             size( system.linear.ss.k.A             )                      ...
           )                                                               ...
      );

% cost function weighting matrix: input, R
ctrl.motorDriver_v.sfr.lqr.R  = ctrl.motorDriver_v.sfr.lqr.r               ...
                              * eye( size(system.linear.ss.k.B, 2) );

% state feedback gains:
ctrl.motorDriver_v.sfr.lqr.K = dlqr( system.linear.ss.k.A                  ...
                                   , system.linear.ss.k.B                  ...
                                   , ctrl.motorDriver_v.sfr.lqr.Q          ...
                                   , ctrl.motorDriver_v.sfr.lqr.R          ...
                                   );

% robustness norm:
[ ctrl.motorDriver_v.sfr.lqr.delta{1,1} ...
, ctrl.motorDriver_v.sfr.lqr.delta{2,1} ...
] = rb_regsf                            ...
( system.linear.ss.k.A                  ...
, system.linear.ss.k.B                  ...
, ctrl.motorDriver_v.sfr.lqr.K          ...
, mdl.T.sample                          ...
);

%% [Init   ]: Controller: SFR with RTS: Gains: Pole-placement              

%{

ctrl.motorDriver_v.sfr.pp.K = rfbg( system.linear.ss.k.A ...
                                  , system.linear.ss.k.B ...
                                  );

[ ctrl.motorDriver_v.sfr.pp.delta{1,1} ...
, ctrl.motorDriver_v.sfr.pp.delta{2,1} ...
] = rb_regsf                           ...
( system.linear.ss.k.A                 ...
, system.linear.ss.k.B                 ...
, ctrl.motorDriver_v.sfr.pp.K          ...
, mdl.T.sample                         ...
);

%}

%% [Init   ]: Controller: SFR with RTS: Gains: Selection                   

ctrl.motorDriver_v.sfr.gain.mode = 0;

switch ctrl.motorDriver_v.sfr.gain.mode
  case 0; ctrl.motorDriver_v.sfr.K = ctrl.motorDriver_v.sfr.lqr.K;
  case 1; ctrl.motorDriver_v.sfr.K = ctrl.motorDriver_v.sfr.pp. K;
end

%% [Init   ]: Controller: SFR with RTS: Gains: Components                  

switch ctrl.motorDriver_v.mode

case 3 % plant plus rts
ctrl.motorDriver_v.sfr.K_plant = ctrl.motorDriver_v.sfr.K(:,1:6);
ctrl.motorDriver_v.sfr.K_rts   = ctrl.motorDriver_v.sfr.K(:,7:8);

end

%% [Init   ]: Controller: SFR with RTS: State-space initial conditions     

switch ctrl.motorDriver_v.mode

case 3 % plant plus rts
  
%{                                                                         

known:

u.p    = [motorDriver.left.v, motorDriver.middle.v]';

u.p[0] = [0 0]';
x.p[0] = user-specified;

thus:

u.p    = -  [K1 K2] ? [x.p x.a]'
u.p    = -(  K1 ? x.p + K2 ? x.a )
[0 0]' = -(  K1 ? x.p + K2 ? x.a )
[0 0]' =     K1 ? x.p + K2 ? x.a

K2?x.a = -   K1 ? x.p
   x.a = -K2\K1 ? x.p

note thus use of backslash.

thus:

x.a[0] = -K2\K1 ? x.p[0]

%}

ctrl.motorDriver_v.rts.ss.stateIC                                          ...
  =   ctrl.motorDriver_v.sfr.K_rts                                         ...
  \   ctrl.motorDriver_v.sfr.K_plant                                       ...
  *   plant.linear.ss.stateIC;

end
%% End










