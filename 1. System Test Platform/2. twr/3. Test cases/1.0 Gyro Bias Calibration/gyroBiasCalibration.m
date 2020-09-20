%% [Global]:                                                               
clc
clearvars

%% [Input  ]: General

t.start.t = 2; % Data steady-state start time [s]

%% [Init   ]: Load data                                                    

load( '2017.06.15 13.41 minseg gyro bias calibration.mat' );

%% [Init   ]: Provide signal legend                                        

for i0 = 1 : size(srl.read, 1)
disp([ num2str( i0, '%02d' )  ...
      ' '                     ...
       srl.read{i0,1}.label   ...
    ]);
end

disp(' ')

%% [Process]: Determine starting index                                     
[~, t.start.z] = min( srl.reads{1,1}.val - t.start.t);

%% [Process]: Determine average value gyroscope outputs at steady state    
test.gyro_x_bias = mean( srl.reads{02,01}.val( t.start.z : end, 1 ) )
test.gyro_y_bias = mean( srl.reads{03,01}.val( t.start.z : end, 1 ) )
test.gyro_z_bias = mean( srl.reads{04,01}.val( t.start.z : end, 1 ) )

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

stairs(srl.reads{1,1}.val, srl.reads{02,01}.val, '.-');

xlabel( 'Time [s]'    ); % all else
legend( {srl.read{02,01}.label
        }...
      )

% y-axis limits
if isa(srl.reads{02,1}.val, 'float') % float
  srl.reads{02,1}.ymin = -rndOut(max([srl.reads{02,1}.val_absMax])+eps, 2);
  srl.reads{02,1}.ymax = +rndOut(max([srl.reads{02,1}.val_absMax])+eps, 2);
else                                 % integer
  srl.reads{02,1}.ymin = double( intmin( class(srl.reads{02,1}.val) ) );
  srl.reads{02,1}.ymax = double( intmax( class(srl.reads{02,1}.val) ) );
end

ylim([ srl.reads{02,1}.ymin, srl.reads{02,1}.ymax ])

grid minor


file.dir  = [];
file.name = 'gyroBias';

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










