%% [Global]                                                                
close all
clearvars
clc

i0 = 1;

filter{i0}.T.sample = 1e-2;
filter{i0}.T.data   = 1e+3;
filter{i0}.T.settle = 2.5 * filter{i0}.T.sample;

filter{i0}.f.c      =    1 / filter{i0}.T.settle;

filter{i0}.f.bin    = 1 / filter{i0}.T.data;
filter{i0}.f.span   = 1 / filter{i0}.T.sample / 2;
filter{i0}.f.f      = 0 : filter{i0}.f.bin : filter{i0}.f.span;

filter{i0}.w.c      = 2*pi * filter{i0}.f.c;
filter{i0}.w.w      = 2*pi * filter{i0}.f.f;

filter{i0}.w.s      =     1j*filter{i0}.w.w              ;
filter{i0}.w.z      = exp(1j*filter{i0}.w.w * filter{i0}.T.sample);

%% Order: 1 | Analog, discrete (bilinear conversion - c2d)                 

i0 = i0 + 1;

filter{i0}.T.sample = filter{1}.T.sample;
filter{i0}.w.c.a    = filter{1}.w.c;

filter{i0}.s.num = [0 filter{i0}.w.c.a];
filter{i0}.s.den = [1 filter{i0}.w.c.a];

filter{i0}.s.tf  = tf( filter{i0}.s.num                                    ...
                     , filter{i0}.s.den                                    ...
                     );

% discretize transfer function
filter{i0}.z.tf = c2d( filter{i0}.s.tf                                     ...
                     , filter{i0}.T.sample                                 ...
                     , 'tustin'                                            ...
                     );

% break transfer function into numerator and demonintor polynomials
[ filter{i0}.s.num                                                         ...
, filter{i0}.s.den                                                         ...
] = tfdata                                                                 ...
( filter{i0}.s.tf                                                          ...
);

[ filter{i0}.z.num                                                         ...
, filter{i0}.z.den                                                         ...
] = tfdata                                                                 ...
( filter{i0}.z.tf                                                          ...
);

% convert cells to matrices
filter{i0}.s.num = filter{i0}.s.num{:};
filter{i0}.s.den = filter{i0}.s.den{:};
filter{i0}.z.num = filter{i0}.z.num{:};
filter{i0}.z.den = filter{i0}.z.den{:};

% data
filter{i0}.h.w.s  = polyval(filter{i0}.s.num, filter{1}.w.s)...
                 ./ polyval(filter{i0}.s.den, filter{1}.w.s);

filter{i0}.h.w.z  = polyval(filter{i0}.z.num, filter{1}.w.z)...
                 ./ polyval(filter{i0}.z.den, filter{1}.w.z);

%% Order: 1 | Discrete (bilinear conversion - manual)                      

i0 = i0 + 1;

filter{i0}.T.sample = filter{1}.T.sample;

filter{i0}.w.c.d = filter{1}.w.c;
filter{i0}.w.c.a = 2 / filter{i0}.T.sample                                 ...
                 * tan( filter{i0}.w.c.d * filter{i0}.T.sample / 2);

filter{i0}.s.num = [0 filter{i0}.w.c.a];
filter{i0}.s.den = [1 filter{i0}.w.c.a];

filter{i0}.s.tf  = tf( filter{i0}.s.num                                    ...
                 , filter{i0}.s.den                                        ...
                 );

% discretize transfer function
filter{i0}.z.tf = c2d( filter{i0}.s.tf                                     ...
                     , filter{i0}.T.sample                                 ...
                     , 'tustin'                                            ...
                     );

% break transfer function into numerator and demonintor polynomials
[ filter{i0}.s.num                                                         ...
, filter{i0}.s.den                                                         ...
] = tfdata                                                                 ...
( filter{i0}.s.tf                                                          ...
);

[ filter{i0}.z.num                                                         ...
, filter{i0}.z.den                                                         ...
] = tfdata                                                                 ...
( filter{i0}.z.tf                                                          ...
);

% convert cells to matrices
filter{i0}.s.num = filter{i0}.s.num{:};
filter{i0}.s.den = filter{i0}.s.den{:};
filter{i0}.z.num = filter{i0}.z.num{:};
filter{i0}.z.den = filter{i0}.z.den{:};

% data
filter{i0}.h.w.s  = polyval(filter{i0}.s.num, filter{1}.w.s)...
                 ./ polyval(filter{i0}.s.den, filter{1}.w.s);

filter{i0}.h.w.z  = polyval(filter{i0}.z.num, filter{1}.w.z)...
                 ./ polyval(filter{i0}.z.den, filter{1}.w.z);

%% Plot                                                                    

p = 0;

p = p+1;
figure(1)
subplot(2,1,1)
label.legend = {};
for i0 = 2:3
semilogx( filter{1}.f.f, 20 * log10( abs( filter{i0}.h.w.s ) ) )
hold on
semilogx( filter{1}.f.f, 20 * log10( abs( filter{i0}.h.w.z ) ) )
label.legend = [label.legend, {'s', 'z'}];
end
semilogx([filter{1}.f.c    filter{1}.f.c   ] ...
        ,[-3               0               ] ...
        , 'k'                                ...
        ,[filter{1}.f.span filter{1}.f.span] ...
        ,[-50              10              ] ...
        , 'k'                                ...
        )
legend(label.legend, 'Location', 'EastOutside')
ylim([-20 +0])
if i0 == 1; grid minor; end

subplot(2,1,2)
label.legend = {};
for i0 = 2:3
semilogx( filter{1}.f.f, angle( filter{i0}.h.w.s ) * 180/pi )
hold on
semilogx( filter{1}.f.f, angle( filter{i0}.h.w.z ) * 180/pi )
label.legend = [label.legend, {'s', 'z'}];
end
semilogx([filter{1}.f.c    filter{1}.f.c   ] ...
        ,[-180             +180            ] ...
        , 'k'                                ...
        ,[filter{1}.f.span filter{1}.f.span] ...
        ,[-180              +180           ] ...
        , 'k'                                ...
        )
legend(label.legend, 'Location', 'EastOutside')
ylim([-180 +180])
if i0 == 1; grid minor; end

%% [End    ]










