%% [Init   ]: Motor: Driver                                                
mtr.driver. left.  pin.pos = 6;
mtr.driver. left.  pin.neg = 8;
mtr.driver. middle.pin.pos = 2;
mtr.driver. middle.pin.neg = 5;

%% [Init   ]: Motor: Encoder                                               
% not yet implemented
% mask encoder model, then use pins as mask parameters
mtr.encoder.left.  pin.A   = 19;
mtr.encoder.left.  pin.B   = 18;
mtr.encoder.middle.pin.A   = 15;
mtr.encoder.middle.pin.B   = 62;

mtr.encoder.countPerRev    = 720;
mtr.encoder.radPerRev      = 2 * pi;

%% [Init   ]: Motor: Encoder: angVel bessel filter: design parameters      
mtr.encoder.filter.T.settle = mdl.T.sample * 25; % [s]
mtr.encoder.filter.order    = 4;     % [-] [integer] [ range: 02 : 10 ]

%% [Init   ]: Motor: Encoder: angVel bessel filter: transfer function      
% divide normalize poles by settling time
mtr.encoder.filter.s.poles = poly( s.pole.bessel{mtr.encoder.filter.order} ...
                                 / mtr.encoder.filter.T.settle             ...
                                 );


% create transfer function
mtr.encoder.filter.s.tf    =   tf( mtr.encoder.filter.s.poles(end)         ...
                                 , mtr.encoder.filter.s.poles              ...
                                 );


% discretize transfer function
mtr.encoder.filter.z.tf    =  c2d( mtr.encoder.filter.s.tf                 ...
                                 , mdl.T.sample                            ...
                                 );

% break transfer function into numerator and demonintor polynomials
[ mtr.encoder.filter.s.num ...
, mtr.encoder.filter.s.den ...
] = tfdata                 ...
( mtr.encoder.filter.s.tf  ...
);

[ mtr.encoder.filter.z.num ...
, mtr.encoder.filter.z.den ...
] = tfdata                 ...
( mtr.encoder.filter.z.tf  ...
);

% convert cells to matrices
mtr.encoder.filter.s.num = mtr.encoder.filter.s.num{:};
mtr.encoder.filter.s.den = mtr.encoder.filter.s.den{:};
mtr.encoder.filter.z.num = mtr.encoder.filter.z.num{:};
mtr.encoder.filter.z.den = mtr.encoder.filter.z.den{:};

%% [Init   ]: Motor: Encoder: angVel bessel filter: state-space            

% create s-plane state space equations (canonical representation)
mtr.encoder.filter.s.ss.A        = diag( ones( mtr.encoder.filter.order - 1, 1 ), 1);
mtr.encoder.filter.s.ss.A(end,:) = mtr.encoder.filter.s.poles( end : -1 : 2 );
mtr.encoder.filter.s.ss.A(end,:) = mtr.encoder.filter.s.ss.A(end,:) ...
                                 / mtr.encoder.filter.s.poles( 1 ) * -1;

mtr.encoder.filter.s.ss.B        = [ zeros(    mtr.encoder.filter.order - 1, 1 ); 1 ];
mtr.encoder.filter.s.ss.C        = [ zeros( 1, mtr.encoder.filter.order - 1    )  1 ];
mtr.encoder.filter.s.ss.D        = 0;


% discretize s-plane state space equations (canonical representation)
[ mtr.encoder.filter.z.ss.A ... phi
, mtr.encoder.filter.z.ss.B ... gamma
] = zohe                    ...
( mtr.encoder.filter.s.ss.A ... A
, mtr.encoder.filter.s.ss.B ... B
, mdl.T.sample              ... T
);

mtr.encoder.filter.z.ss.C        = mtr.encoder.filter.s.ss.C;
mtr.encoder.filter.z.ss.D        = mtr.encoder.filter.s.ss.D;

%% [Init   ]: Gyroscope                                                    
gyro.dlpf.mode   = 0;  % [ default: 0 ]
% | # | maxValue [deg/s] | bandwidth [Hz] | delay [s] | 
% | 0 | +/- 0250         | 256            | 00.98     | 
% | 1 | +/- 0500         | 188            | 01.90     | 
% | 2 | +/- 1000         | 098            | 02.80     | 
% | 3 | +/- 2000         | 042            | 04.80     | 
% | 4 | +/- ????         | 020            | 08.30     | 
% | 5 | +/- ????         | 010            | 13.40     | 
% | 6 | +/- ????         | 005            | 18.60     | 

switch gyro.dlpf.mode
case 0; gyro.maxVal = 0250 * k_deg2rad;
case 1; gyro.maxVal = 0500 * k_deg2rad;
case 2; gyro.maxVal = 1000 * k_deg2rad;
case 3; gyro.maxVal = 2000 * k_deg2rad;
end

gyro.k_raw2actual = gyro.maxVal / k.intmax.int16;

% [source: 1. Test Cases/1. Gyro Bias Calibration]
gyro.x.bias      = -266.0779700;
gyro.y.bias      = -135.5037500;
gyro.z.bias      = -034.3493271;

gyro.x.reset     =  0;
gyro.y.reset     =  0;
gyro.z.reset     =  0;

%% [Init   ]: Gyroscope     : angVel bessel filter: design parameters      
gyro.filter.T.settle = mdl.T.sample * 25; % [s]
gyro.filter.order    = 4;     % [-] [integer] [ range: 02 : 10 ]

%% [Init   ]: Gyroscope     : angVel bessel filter: transfer function      
% divide normalize poles by settling time
gyro.filter.s.poles = poly( s.pole.bessel{gyro.filter.order} ...
                          / gyro.filter.T.settle             ...
                          );


% create transfer function
gyro.filter.s.tf    =   tf( gyro.filter.s.poles(end)         ...
                          , gyro.filter.s.poles              ...
                          );


% discretize transfer function
gyro.filter.z.tf    =  c2d( gyro.filter.s.tf                 ...
                          , mdl.T.sample                     ...
                          );

% break transfer function into numerator and demonintor polynomials
[ gyro.filter.s.num ...
, gyro.filter.s.den ...
] = tfdata          ...
( gyro.filter.s.tf  ...
);

[ gyro.filter.z.num ...
, gyro.filter.z.den ...
] = tfdata          ...
( gyro.filter.z.tf  ...
);

% convert cells to matrices
gyro.filter.s.num = gyro.filter.s.num{:};
gyro.filter.s.den = gyro.filter.s.den{:};
gyro.filter.z.num = gyro.filter.z.num{:};
gyro.filter.z.den = gyro.filter.z.den{:};

%% [Init   ]: Gyroscope     : angVel bessel filter: state-space            

% create s-plane state space equations (canonical representation)
gyro.filter.s.ss.A        = diag( ones( gyro.filter.order - 1, 1 ), 1);
gyro.filter.s.ss.A(end,:) = gyro.filter.s.poles( end : -1 : 2 );
gyro.filter.s.ss.A(end,:) = gyro.filter.s.ss.A(end,:) ...
                          / gyro.filter.s.poles( 1 ) * -1;

gyro.filter.s.ss.B        = [ zeros(    gyro.filter.order - 1, 1 ); 1 ];
gyro.filter.s.ss.C        = [ zeros( 1, gyro.filter.order - 1    )  1 ];
gyro.filter.s.ss.D        = 0;


% discretize s-plane state space equations (canonical representation)
[ gyro.filter.z.ss.A ... phi
, gyro.filter.z.ss.B ... gamma
] = zohe             ...
( gyro.filter.s.ss.A ... A
, gyro.filter.s.ss.B ... B
, mdl.T.sample       ... T
);

gyro.filter.z.ss.C        = gyro.filter.s.ss.C;
gyro.filter.z.ss.D        = gyro.filter.s.ss.D;

%% [Init   ]: Accelerometer                                                
accel.afs_sel.mode   = 0;  % [ Required: 0 ]
% | # | maxValue [g] | Sensitivity [LSB/mg] |
% | 0 | +/- 02       | 8192
% | 1 | +/- 04       | 4096
% | 2 | +/- 08       | 2048
% | 3 | +/- 16       | 1024

assert( accel.afs_sel.mode == 0 );

switch accel.afs_sel.mode
case 0; accel.maxVal = 02 * a.gravity;
case 1; accel.maxVal = 04 * a.gravity;
case 2; accel.maxVal = 08 * a.gravity;
case 3; accel.maxVal = 16 * a.gravity;
end

accel.k_raw2actual = accel.maxVal / k.intmax.int16;

%% End










