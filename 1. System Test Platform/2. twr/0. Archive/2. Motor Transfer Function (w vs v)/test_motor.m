%% [Global]:                                                               
close all
clearvars
clc

%% [Input  ]:
load('2017.06.10 21.44.mat')

%% [Init   ]: Display signal legend                                        
for i0 = 1:length(srl.read)
  disp([num2str(i0,'%02d'), ' ', srl.read{i0}.label ]); 
end

%% [Init   ]: Common plot commands                                         

%subplot with 2d indices:
dim1     = @(n_col, row, col)        (row-1)*n_col + col; % Matrix index: 2d to 1d
subplott = @(n_row, n_col, M) subplot(n_row, n_col, dim1(n_col, M(1), M(2)) );

% axis value
msd      = @(x)    fix( log10( abs(x) ) );                      % most significant digit. [ones digit = 0th digit]
rndout   = @(x, N) sign(x) .* ceil( abs(x)*10^(-N) ) * 10^(+N); % round away from zero at specified digit.
rndOut   = @(x, N) rndout(x, msd(x) - N ); % round away from zero at N digits right from most significant digit.


%% [Output ]: Plot

figure(1)

subplott(2,1,[1 1])
stairs(srl.reads{01,1}.val, srl.reads{07,1}.val, 'b-'  , 'LineWidth', 2);
hold on
stairs(srl.reads{01,1}.val, srl.reads{08,1}.val, 'r-'  , 'LineWidth', 1);
stairs(srl.reads{01,1}.val, srl.reads{03,1}.val, 'b.', 'LineWidth', 1);
stairs(srl.reads{01,1}.val, srl.reads{04,1}.val, 'r.', 'LineWidth', 1);
hold off

xlabel(srl.read{01,1}.label)

legend( { srl.read{07,1}.label
          srl.read{08,1}.label
          srl.read{03,1}.label
          srl.read{04,1}.label } ...
      ,  'Location'              ...
      ,  'NorthEast'             ...
      )

grid minor
    
%{
subplott(2,1,[2 1])
stairs(srl.reads{01,1}.val, srl.reads{03,1}.val ./ srl.reads{07,1}.val);
hold on
stairs(srl.reads{01,1}.val, srl.reads{04,1}.val ./ srl.reads{08,1}.val);
hold off
%}

subplott(2,1,[2 1])
stairs(srl.reads{07,1}.val, srl.reads{03,1}.val, 'b.' , 'LineWidth', 3);
hold on
stairs(srl.reads{08,1}.val, srl.reads{04,1}.val, 'r.' , 'LineWidth', 1);
stairs([4.5 4.5],           [0 6.5],             'k'  , 'LineWidth', 1);
hold off

xlabel(srl.read{07,1}.label)

legend( { srl.read{03,1}.label
          srl.read{04,1}.label } ...
      ,  'Location'              ...
      ,  'NorthEast'             ...
      )

grid minor

print('motor speed vs voltage','-r180','-dpng');
