%% [Output ]: Common plot commands                                         

%subplot with 2d indices:
dim1     = @(n_col, row, col)        (row-1)*n_col + col; % Matrix index: 2d to 1d
subplott = @(n_row, n_col, M) subplot(n_row, n_col, dim1(n_col, M(1), M(2)) );

% axis value
msd      = @(x)    fix( log10( abs(x) ) );                      % most significant digit. [ones digit = 0th digit]
rndout   = @(x, N) sign(x) .* ceil( abs(x)*10^(-N) ) * 10^(+N); % round away from zero at specified digit.
rndOut   = @(x, N) rndout(x, msd(x) - N ); % round away from zero at N digits right from most significant digit.

%% [Output ]: Plot setup                                                   
p = 0;

disp( 'Performing plot creation:' )

for i0 = 1 : srl.read{1,1}.n.signals                                        
    
  p = p + 1;
  figure(p)
  
  % plot data
  if i0==1; stairs(                    srl.reads{i0,1}.val, '.-'); % clock
  else;     stairs(srl.reads{1,1}.val, srl.reads{i0,1}.val, '.-'); % all else
  end

  % labels
  if i0==1; xlabel( 'Samples [-]' ); % clock
  else;     xlabel( 'Time [s]'    ); % all else
  end

  ylabel( srl.read{i0,1}.label )

  % y-axis limits
  if isa(srl.reads{i0,1}.val, 'float') % float
    srl.reads{i0,1}.ymin = -rndOut(srl.reads{i0,1}.val_absMax+eps, 2);
    srl.reads{i0,1}.ymax = +rndOut(srl.reads{i0,1}.val_absMax+eps, 2);
  else                                 % integer
    srl.reads{i0,1}.ymin = double( intmin( class(srl.reads{i0,1}.val) ) );
    srl.reads{i0,1}.ymax = double( intmax( class(srl.reads{i0,1}.val) ) );
  end
  
  ylim([ srl.reads{i0,1}.ymin, srl.reads{i0,1}.ymax ])

  grid minor

end

disp( 'Plot creation complete.'   )
disp( ' '                         )


%% [Output ]: Close legacy figures                                         

% not yet implemented.
% use "a = get(groot, 'Children')" to list all figures.
% then "for all figures: if n.figure > n.figure.gcf, close n.figure"

% when implemented, stop using "close all"

%% End










