%% [Init   ]: Plant: Wheel   (single)                                      

% mass measurement precision: 0.01 lb
% note: this could be improved with a better scale.

plant.axel.m         = 0.000;     %                           [kg]       [note low precision.]

plant.wheel.r        = 0.021;     %  radius                   [m]        [source: howard]
plant.wheel.m        = 0.036 / 2; % (includes axel)           [kg]       [source: howard]
plant.wheel.J        = 7.460e-6;  %  moment of inertia        [kg / m^2] [source: howard]
                                  %  measured from center of mass of wheel

%% [Init   ]: Plant: Body: Masses  
% note: body does not include wheels.

% mass measurement precision: 0.01 lb
% note: this could be improved with a better scale.

% plant.board.     m   = 1.000 * k.lb2kg; %                   [kg]
% plant.motorCable.m   = 0.010 * k.lb2kg; % (quantity: 1)     [kg] [note low precision.]
% plant.motor.     m   = 0.220 * k.lb2kg; % (quantity: 1)     [kg] 
% plant.battery.   m   = 1.000 * k.lb2kg; % (quantity: 1)     [kg]

% plant.bluetooth. m   = 0.000 * k.lb2kg; % bluetooth module  [kg] [note low precision.]
% plant.usbCable.  m   = 0.040 * k.lb2kg; % (not included)    [kg]

% plant.body.m         =  plant.board.m                                      ...
%                      +  plant.motor.m      * 2                             ...
%                      +  plant.motorCable.m * 2                             ...
%                      +  plant.battery.m    * plant.n.battery               ...
%                      +  plant.bluetooth.m  * plant.x.bluetoothModule; 
%                               %  mass   [kg]

plant.body.m         =  1.030; % (not included)    [kg]
                               % net measurement taken to reduce rounding errors.
                               % [taken with 6 batteries].

%% [Init   ]: Plant: Body                                                  
% note: does not include wheels.

plant.body.l.h       =  8.00 * k.in2m; %  height [m]
plant.body.l.w       =  3.25 * k.in2m; %  width  [m]
plant.body.l.d       =  2.50 * k.in2m; %  depth  [m]

switch plant.x.bluetoothModule

case 0 % Not inserted
  switch plant.n.batteries
  case 0; plant.body.f.natural =  1; %  natural frequency [rad/s] 
  case 5; plant.body.f.natural =  1; %  natural frequency [rad/s] 
  case 6; plant.body.f.natural =  1; %  natural frequency [rad/s] 
  end

case 1 % Inserted
  switch plant.n.batteries
  case 0; plant.body.f.natural =  1; %  natural frequency [rad/s] 
  case 5; plant.body.f.natural =  1; %  natural frequency [rad/s] 
  case 6; plant.body.f.natural =  3.5087719; %  natural frequency [rad/s] 
  end
  
end

plant.body.w.natural = 2 * pi * plant.body.f.natural; 
                           %  natural angular frequency [rad/s] 

plant.body.l.c       =  3 * (a.gravity - plant.body.w.natural^2 * plant.wheel.r) ...
                     / (4 *              plant.body.w.natural^2                ); 
                           %  wheel axel to center of mass of robot [m]

plant.body.J.x       =  plant.body.m *  plant.body.l.c^2                   ...
                     /  3; 
                           %  moment of inertia (pitch) [kg / m^2]
                           % (measured from center of mass of robot)

plant.body.J.y       =  plant.body.m                                       ...
                     * (plant.body.l.w^2 + plant.body.l.d^2)               ...
                     /  12; 
                           %  moment of inertia (yaw)   [kg / m^2]
                           % (measured from center of mass of robot)

%% [Init   ]: Plant: Net (body + 2 * wheel)                                
plant.net.m          =  plant.body.m + 2 * plant.wheel.m; % [kg]

%% [Init   ]: Plant: Motor                                                 
mtr.R                =  4.400; %  resistance              [ohm        ] [source: howard]
mtr.k.dlambda        =  0.495; %  back EMF constant       [V*s / rad  ] [source: howard]
mtr.k.torque         =  0.470; %  torque   constant       [N*m / A    ] [source: howard]

switch plant.x.bluetoothModule

case 0 % Not inserted
  switch plant.n.batteries
  case 0 
  mtr.k.v2w          =  1.000; %  transfer function (y/u) [rad / (s*V)]
                               % (measured when body is upright AND
                               %  both wheels are at equivalent speed
                               %  in a common direction.)

  case 5 
  mtr.k.v2w          =  1.000; %  transfer function (y/u) [rad / (s*V)]
                               % (measured when body is upright AND
                               %  both wheels are at equivalent speed
                               %  in a common direction.)

  case 6 
  mtr.k.v2w          =  1.000; %  transfer function (y/u) [rad / (s*V)]
                               % (measured when body is upright AND
                               %  both wheels are at equivalent speed
                               %  in a common direction.)
                             
  end

case 1 % Inserted
  switch plant.n.batteries
  case 0 
  mtr.k.v2w          =  1.000; %  transfer function (y/u) [rad / (s*V)]
                               % (measured when body is upright AND
                               %  both wheels are at equivalent speed
                               %  in a common direction.)

  case 5 
  mtr.k.v2w          =  1.000; %  transfer function (y/u) [rad / (s*V)]
                               % (measured when body is upright AND
                               %  both wheels are at equivalent speed
                               %  in a common direction.)

  case 6 
  mtr.k.v2w          =  3/3.35; %  transfer function (y/u) [rad / (s*V)]
                               % (measured when body is upright AND
                               %  both wheels are at equivalent speed
                               %  in a common direction.)

  end
  
end

mtr.k.friction       =  mtr.k.torque * (1 - mtr.k.dlambda * mtr.k.v2w)     ...
                     / (mtr.R * mtr.k.v2w); 
                           %  coefficient of friction [-          ]

%% [Init   ]: Plant: State space model term abbreviations                  

% wheel.theta and body.theta.x (pitch) (psi)
plant.q(1,1) = plant.net. m * plant.wheel.r^2                     + plant.wheel.J;
plant.q(2,1) = plant.body.m * plant.wheel.r^2 * plant.body. l.c                  ;
plant.q(3,1) = plant.body.m *                   plant.body. l.c^2 + plant.wheel.J;
plant.q(4,1) = mtr.k.torque * mtr.k.dlambda / mtr.R + mtr.k.friction             ;
plant.q(5,1) = plant.body.m * a.gravity       * plant.body. l.c                  ;
plant.q(6,1) = mtr.k.torque                 / mtr.R                              ;

plant.Q{1,1} =     [ +plant.q(1) +plant.q(2) 
                     +plant.q(2) +plant.q(3) ];
plant.Q{2,1} = 2 * [ +plant.q(4) -plant.q(4) 
                     -plant.q(4) +plant.q(4) ];
plant.Q{3,1} =     [ +0          +0
                     +0          -plant.q(5) ];
plant.Q{4,1} =     [ +plant.q(6) +plant.q(6) 
                     -plant.q(6) -plant.q(6) ];

% body.theta.y (yaw) (phi)
plant.r(1,1) =  plant.body.l.w / plant.wheel.r;

plant.R{1,1} =  0.5 * plant.wheel.m  * plant.body.l.w^2                    ...
             +  plant.body.J.y                                             ...
             +  0.5 * plant.r(1)^2 * plant.wheel.J;
plant.R{2,1} =  0.5 * plant.r(1)^2 * plant.q(4);
plant.R{3,1} =  0.5 * plant.r(1)   * mtr.k.torque / mtr.R;

% overall
plant.a{1,1} =  - plant.Q{1} \ plant.Q{3};
plant.a{2,1} =  - plant.Q{1} \ plant.Q{2};
plant.a{3,1} =  - plant.R{1} \ plant.R{2}; % note the backslash.

plant.b{1,1} =  + plant.Q{1} \ plant.Q{4};
plant.b{2,1} =  + plant.R{1} \ plant.R{3};

%% [Init   ]: Plant State Space Model: A                                   

plant.A(1,1) =  0;
plant.A(1,2) =  0;
plant.A(1,3) =  1;
plant.A(1,4) =  0;
plant.A(1,5) =  0;
plant.A(1,6) =  0;

plant.A(2,1) =  0;
plant.A(2,2) =  0;
plant.A(2,3) =  0;
plant.A(2,4) =  1;
plant.A(2,5) =  0;
plant.A(2,6) =  0;

plant.A(3,1) =  plant.a{1}(1,1);
plant.A(3,2) =  plant.a{1}(1,2);
plant.A(3,3) =  plant.a{2}(1,1);
plant.A(3,4) =  plant.a{2}(1,2);
plant.A(3,5) =  0;
plant.A(3,6) =  0;

plant.A(4,1) =  plant.a{1}(2,1);
plant.A(4,2) =  plant.a{1}(2,2);
plant.A(4,3) =  plant.a{2}(2,1);
plant.A(4,4) =  plant.a{2}(2,2);
plant.A(4,5) =  0;
plant.A(4,6) =  0;

plant.A(5,1) =  0;
plant.A(5,2) =  0;
plant.A(5,3) =  0;
plant.A(5,4) =  0;
plant.A(5,5) =  0;
plant.A(5,6) =  1;

plant.A(6,1) =  0;
plant.A(6,2) =  0;
plant.A(6,3) =  0;
plant.A(6,4) =  0;
plant.A(6,5) =  0;
plant.A(6,6) =  plant.a{3};

%% [Init   ]: Plant State Space Model: B                                   

plant.B(1,1) =  0;
plant.B(2,1) =  0;
plant.B(3,1) =  plant.b{1}(1,1);
plant.B(4,1) =  plant.b{1}(2,1);
plant.B(5,1) =  0;
plant.B(6,1) = -plant.b{2};

plant.B(1,2) =  0;
plant.B(2,2) =  0;
plant.B(3,2) =  plant.b{1}(1,2);
plant.B(4,2) =  plant.b{1}(2,2);
plant.B(5,2) =  0;
plant.B(6,2) = +plant.b{2};

%% [Init   ]: Plant State Space Model: C, D                                

plant.C      = eye  ( size( plant.A    )                     );
plant.D      = zeros( size( plant.A, 1 ), size( plant.C, 2 ) );

%% End










