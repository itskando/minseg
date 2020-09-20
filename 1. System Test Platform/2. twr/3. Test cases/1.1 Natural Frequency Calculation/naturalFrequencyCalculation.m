%% [Global]:                                                               
clc
clearvars

%% [Input  ]: General

t.start.t = 04.4; % Data oscillation start time [s]
t.end.  t = 12.0; % Data oscillation end   time [s]

%% [Init   ]: Load data                                                    

load( '2017.08.22 21.45 minseg (pendulum).mat' );

if exist('system', 'var')
clearvars('system')
end

%% [Init   ]: Provide signal legend                                        

for i0 = 1 : size(srl.read, 1)
disp([ num2str( i0, '%02d' )  ...
      ' '                     ...
       srl.read{i0,1}.label   ...
    ]);
end

disp(' ')

%% 

% index of: plant.position.phi.x (pitch).position [rad]
z.phi.x = 4;

%% [Process]: Determine start/end indices                                  
[~, t.start.z] = min( abs( srl.reads{1,1}.val - t.start.t) );
[~, t.end.z  ] = min( abs( srl.reads{1,1}.val - t.end.t  ) );

n.indices      = t.end.z - t.start.z;

%% [Process]: Determine zero crossing indices, then average time differential    

%{

% do NOT use zero crossings - gyro bias will affect them significantly

z.zeroCrossing = [];
t.zeroCrossing = [];

for i0 = 0 : (n.indices - 1)

if (  ( srl.reads{z.phi.x,1}.val(t.start.z + i0 + 0) > 0  &&  srl.reads{z.phi.x,1}.val(t.start.z + i0 + 1) < 0 ) ...
   || ( srl.reads{z.phi.x,1}.val(t.start.z + i0 + 0) < 0  &&  srl.reads{z.phi.x,1}.val(t.start.z + i0 + 1) > 0 ) ...
   )

z.zeroCrossing  = [ z.zeroCrossing;                   (t.start.z + i0 + 1) ];
t.zeroCrossing  = [ t.zeroCrossing; srl.reads{1,1}.val(t.start.z + i0 + 1) ];
end

end

T.zeroCrossing0 = diff( t.zeroCrossing  );
T.zeroCrossing  = mean( T.zeroCrossing0 );

test.f_natural  = 1 / T.zeroCrossing;
test.w_natural  = 2*pi * test.f_natural

%}

%% [Process]: Determine peak indices, then average time differential    

[ y.peak                                           ...
, z.peak                                           ...
] = findpeaks                                      ...
( srl.reads{z.phi.x,1}.val(t.start.z : t.end.z, 1) ...
);

t.peak = srl.reads{1,1}.val(t.start.z - 1 + z.peak);


T.peak0 = diff( t.peak  );
T.peak  = T.peak0(1);

test.f_natural  = 1 / T.peak;
test.w_natural  = 2*pi * test.f_natural

%% [Output ]: Common plot commands                                         

%subplot with 2d indices:
dim1     = @(n_col, row, col)        (row-1)*n_col + col; % Matrix index: 2d to 1d
subplott = @(n_row, n_col, M) subplot(n_row, n_col, dim1(n_col, M(1), M(2)) );

% axis value
msd      = @(x)    fix( log10( abs(x) ) );                      % most significant digit. [ones digit = 0th digit]
rndout   = @(x, N) sign(x) .* ceil( abs(x)*10^(-N) ) * 10^(+N); % round away from zero at specified digit.
rndOut   = @(x, N) rndout(x, msd(x) - N ); % round away from zero at N digits right from most significant digit.

%% [Output ]: Determine starting index                                     
set(groot,'defaultFigurePaperPositionMode', 'manual'  );
set(groot,'defaultFigurePaperPosition',    [0 0 20 20]);
set(groot,'defaultFigurePaperSize',        [    20 20]);

set(groot,'defaultAxesFontSize',                   24 );

figure

stairs(srl.reads{1,1}.val, srl.reads{z.phi.x,1}.val, '.-');
hold on
stairs(t.peak, y.peak, '^');
hold off

xlabel( 'Time [s]'    ); % all else
legend( {srl.read{z.phi.x,01}.label
        }...
      )

% y-axis limits
if isa(srl.reads{z.phi.x,1}.val, 'float') % float
  srl.reads{z.phi.x,1}.ymin = -rndOut(max([srl.reads{z.phi.x,1}.val_absMax])+eps, 2);
  srl.reads{z.phi.x,1}.ymax = +rndOut(max([srl.reads{z.phi.x,1}.val_absMax])+eps, 2);
else                                 % integer
  srl.reads{z.phi.x,1}.ymin = double( intmin( class(srl.reads{z.phi.x,1}.val) ) );
  srl.reads{z.phi.x,1}.ymax = double( intmax( class(srl.reads{z.phi.x,1}.val) ) );
end

ylim([ srl.reads{z.phi.x,1}.ymin, srl.reads{z.phi.x,1}.ymax ])

grid minor


file.dir  = [];%'.\';
file.name = 'naturalFrequency';

print([file.name '.pdf'], '-dpdf')

[sys.err, sys.txt] =                                              ...
 system(['pdfcrop --hires '                                       ...
         '--verbose '                                             ...
         '"' file.dir file.name '.pdf' '"'                        ...
         ' '                                                      ...
         '"' file.dir file.name '.pdf' '"'                        ...
       ]);

log.err = {};
if sys.err ~= 0
  log.err = [log.err; {0, sys.err, sys.txt}];
end

set(groot,'defaultAxesFontSize',                   10 );

%% End










