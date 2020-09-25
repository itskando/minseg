%% [Init   ]: Plant: Linear dynamics: State space model term abbreviations 

% wheel.theta and body.theta.x (pitch) (psi)
plant.linear.k.q(1,1) = plant.net. m * plant.wheel.r^2                     ...
                      + plant.wheel.J;
plant.linear.k.q(2,1) = plant.body.m * plant.wheel.r^2 * plant.body. l.c;
plant.linear.k.q(3,1) = plant.body.m *                   plant.body. l.c^2 ...
                      + plant.wheel.J;
plant.linear.k.q(4,1) = plant.mtr.k.torque * plant.mtr.k.dlambda           ...
                      / plant.mtr.R                                        ...
                      + plant.mtr.k.friction;
plant.linear.k.q(5,1) = plant.body.m * a.gravity       * plant.body. l.c;
plant.linear.k.q(6,1) = plant.mtr.k.torque                                 ...
                      / plant.mtr.R;

plant.linear.k.Q{1,1} =     [ +plant.linear.k.q(1) +plant.linear.k.q(2) 
                              +plant.linear.k.q(2) +plant.linear.k.q(3) ];
plant.linear.k.Q{2,1} = 2 * [ +plant.linear.k.q(4) -plant.linear.k.q(4) 
                              -plant.linear.k.q(4) +plant.linear.k.q(4) ];
plant.linear.k.Q{3,1} =     [ +0                   +0
                              +0                   -plant.linear.k.q(5) ];
plant.linear.k.Q{4,1} =     [ +plant.linear.k.q(6) +plant.linear.k.q(6) 
                              -plant.linear.k.q(6) -plant.linear.k.q(6) ];

% body.theta.y (yaw) (phi)
plant.linear.k.r(1,1) =  plant.body.l.w / plant.wheel.r;

plant.linear.k.R{1,1} =  0.5 * plant.wheel.m  * plant.body.l.w^2           ...
                      +  plant.body.J.y                                    ...
                      +  0.5 * plant.linear.k.r(1)^2 * plant.wheel.J;
plant.linear.k.R{2,1} =  0.5 * plant.linear.k.r(1)^2 * plant.linear.k.q(4);
plant.linear.k.R{3,1} =  0.5 * plant.linear.k.r(1)   * plant.mtr.k.torque  ...
                      /        plant.mtr.R;

% overall
% note the use of backslash.
plant.linear.k.a{1,1} =  - plant.linear.k.Q{1} \ plant.linear.k.Q{3};
plant.linear.k.a{2,1} =  - plant.linear.k.Q{1} \ plant.linear.k.Q{2};
plant.linear.k.a{3,1} =  - plant.linear.k.R{1} \ plant.linear.k.R{2};

plant.linear.k.b{1,1} =  + plant.linear.k.Q{1} \ plant.linear.k.Q{4};
plant.linear.k.b{2,1} =  + plant.linear.k.R{1} \ plant.linear.k.R{3};

%% [Init   ]: Plant: Linear dynamics: State space model: A                 

plant.linear.ss.t.A(1,1) =  0;
plant.linear.ss.t.A(1,2) =  0;
plant.linear.ss.t.A(1,3) =  1;
plant.linear.ss.t.A(1,4) =  0;
plant.linear.ss.t.A(1,5) =  0;
plant.linear.ss.t.A(1,6) =  0;

plant.linear.ss.t.A(2,1) =  0;
plant.linear.ss.t.A(2,2) =  0;
plant.linear.ss.t.A(2,3) =  0;
plant.linear.ss.t.A(2,4) =  1;
plant.linear.ss.t.A(2,5) =  0;
plant.linear.ss.t.A(2,6) =  0;

plant.linear.ss.t.A(3,1) =  plant.linear.k.a{1}(1,1);
plant.linear.ss.t.A(3,2) =  plant.linear.k.a{1}(1,2);
plant.linear.ss.t.A(3,3) =  plant.linear.k.a{2}(1,1);
plant.linear.ss.t.A(3,4) =  plant.linear.k.a{2}(1,2);
plant.linear.ss.t.A(3,5) =  0;
plant.linear.ss.t.A(3,6) =  0;

plant.linear.ss.t.A(4,1) =  plant.linear.k.a{1}(2,1);
plant.linear.ss.t.A(4,2) =  plant.linear.k.a{1}(2,2);
plant.linear.ss.t.A(4,3) =  plant.linear.k.a{2}(2,1);
plant.linear.ss.t.A(4,4) =  plant.linear.k.a{2}(2,2);
plant.linear.ss.t.A(4,5) =  0;
plant.linear.ss.t.A(4,6) =  0;

plant.linear.ss.t.A(5,1) =  0;
plant.linear.ss.t.A(5,2) =  0;
plant.linear.ss.t.A(5,3) =  0;
plant.linear.ss.t.A(5,4) =  0;
plant.linear.ss.t.A(5,5) =  0;
plant.linear.ss.t.A(5,6) =  1;

plant.linear.ss.t.A(6,1) =  0;
plant.linear.ss.t.A(6,2) =  0;
plant.linear.ss.t.A(6,3) =  0;
plant.linear.ss.t.A(6,4) =  0;
plant.linear.ss.t.A(6,5) =  0;
plant.linear.ss.t.A(6,6) =  plant.linear.k.a{3};

%% [Init   ]: Plant: Linear dynamics: State space model: B                 

plant.linear.ss.t.B(1,1) =  0;
plant.linear.ss.t.B(2,1) =  0;
plant.linear.ss.t.B(3,1) =  plant.linear.k.b{1}(1,1);
plant.linear.ss.t.B(4,1) =  plant.linear.k.b{1}(2,1);
plant.linear.ss.t.B(5,1) =  0;
plant.linear.ss.t.B(6,1) = -plant.linear.k.b{2};

plant.linear.ss.t.B(1,2) =  0;
plant.linear.ss.t.B(2,2) =  0;
plant.linear.ss.t.B(3,2) =  plant.linear.k.b{1}(1,2);
plant.linear.ss.t.B(4,2) =  plant.linear.k.b{1}(2,2);
plant.linear.ss.t.B(5,2) =  0;
plant.linear.ss.t.B(6,2) = +plant.linear.k.b{2};

%% [Init   ]: Plant: Linear dynamics: State space model: C, D              

plant.linear.ss.t.C = eye  ( size( plant.linear.ss.t.A    ) );

plant.linear.ss.t.D = zeros( size( plant.linear.ss.t.C, 1 ) ...
                                    , size( plant.linear.ss.t.B, 2 ) );

%% [Init   ]: Plant: Linear dynamics: State space model: cont. to discrete 

[ plant.linear.ss.k.A   ...
, plant.linear.ss.k.B   ...
] = c2d                        ...
( plant.linear.ss.t.A ...
, plant.linear.ss.t.B ...
, mdl.T.sample                 ...
);

plant.linear.ss.k.C = plant.linear.ss.t.C;
plant.linear.ss.k.D = plant.linear.ss.t.D;

%% End










