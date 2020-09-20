function [filter] = lpfPlus( n_order  ...
                           , T_sample ...
                           , T_settle ...
                           , x_mode   ...
                           )

%% [Init   ]: General                                                      

filter.order     = n_order;                 %     [-]
% 0: bessel      [vaccaro]
% 1: bessel      [matlab ]
% 2: butterworth [matlab ]

filter.T.sample  = T_sample;                %     [s]
filter.T.settle  = T_settle;                %     [s]

% note       : cutoff becomes significant at f.cutoff, but still exists before f.cutoff.
% recommended: f.cutoff = f.cutoffDesired * 2.0;
% or         : T.settle = T.settleDesired * 0.5;

filter.mode      = x_mode;                  %     [-]

filter.f.span    =    1 / filter.T.sample;  % [  1/s]
filter.f.nyquist =    2 * filter.f.span;    % [  1/s]
filter.f.cutoff  =    1 / filter.T.settle;  % [  1/s]

filter.w.span    = 2*pi * filter.f.span;    % [rad/s]
filter.w.nyquist = 2*pi * filter.f.nyquist; % [rad/s]
filter.w.cutoff  = 2*pi * filter.f.cutoff;  % [rad/s]

assert( filter.w.cutoff < filter.w.nyquist )

%% [Process]: Transfer function: Mode                                      
switch filter.mode

case 0 % bessel      [vaccaro]
filter.type = 'bessel [vaccaro]';

% load bessel poles
  file.path        = mfilename('fullpath');
[ file.dir, ~, ~ ] = fileparts(file.path);
  load([file.dir '/bessel poles.mat'])
  
% divide [normalized poles] by settling time
filter.s.poles    = s.pole.bessel{filter.order}                            ...
                  / filter.T.settle;

filter.s.polePoly = poly( filter.s.poles );
                   
% create transfer function
filter.s.num = filter.s.polePoly(end);
filter.s.den = filter.s.polePoly;

case 1 % bessel      [matlab]
filter.type = 'bessel';

[ filter.s.num                                                             ...
, filter.s.den                                                             ...
] = besself                                                                ...
( filter.order                                                             ...
, filter.w.cutoff                                                          ...
);

case 2 % butterworth [matlab]
filter.type = 'butterworth';

[  filter.s.num    ...
,  filter.s.den    ...
]  = butter        ...
(  filter.order    ...
,  filter.w.cutoff ... 
.../ (mdl.w.sample * 1/2)               ... (Normalize by mdl.w.sample.nyquist for z)
, 'low'            ...
, 's'              ...
);

end

%% [Process]: Transfer function: Continuous and discrete, TF and num&den   

filter.s.tf =  tf( filter.s.num                                            ...
                 , filter.s.den                                            ...
                 );

% discretize transfer function
filter.z.tf = c2d( filter.s.tf                                             ...
                 , filter.T.sample                                         ...
                 , 'tustin'                                                ...
                 );

% break transfer function into numerator and demonintor polynomials
[ filter.s.num                                                             ...
, filter.s.den                                                             ...
] = tfdata                                                                 ...
( filter.s.tf                                                              ...
);

[ filter.z.num                                                             ...
, filter.z.den                                                             ...
] = tfdata                                                                 ...
( filter.z.tf                                                              ...
);

% convert cells to matrices
filter.s.num = filter.s.num{:};
filter.s.den = filter.s.den{:};
filter.z.num = filter.z.num{:};
filter.z.den = filter.z.den{:};

%% [Process]: State-space                                                  
% unverified

%{

% create s-plane state space equations (canonical representation)
filter.s.ss.A        = diag( ones( filter.order - 1, 1 ), 1 );
filter.s.ss.A(end,:) = filter.s.poles( end : -1 : 2 );
filter.s.ss.A(end,:) = filter.s.ss.A ( end,:)                              ...
                     / filter.s.poles( 1 ) * -1;

filter.s.ss.B        = [ zeros(    filter.order - 1, 1 ); 1 ];
filter.s.ss.C        = [ zeros( 1, filter.order - 1    )  1 ];
filter.s.ss.D        =   0;


% discretize s-plane state space equations (canonical representation)
[ filter.z.ss.A   ... phi
, filter.z.ss.B   ... gamma
] = zohe          ...
( filter.s.ss.A   ... A
, filter.s.ss.B   ... B
, filter.T.sample ... T
);

filter.z.ss.C = filter.s.ss.C;
filter.z.ss.D = filter.s.ss.D;

%}

%% [End]











