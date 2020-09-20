%% [Global ]:                                                              
clc
clearvars
%close all

% close all loaded simulink models and libraries.
% close_system( find_system('SearchDepth', 0) )

% close and delete all serial connections
if ~isempty(instrfindall)
  fclose   (instrfindall);
  delete   (instrfindall);
end

%% [Global ]: Add subdirectories to Matlab path                            
root.dir     = cd;
root.sub.dir = ...
{ 
  [root.dir '/1. General Tools/'                                    ]
  [root.dir '/1. General Tools/0. Frequency domain'                 ]
  [root.dir '/1. General Tools/0. Frequency domain/0. Bessel poles' ]
  [root.dir '/1. General Tools/0. Frequency domain/1. fftPlus'      ]
  [root.dir '/1. General Tools/0. Frequency domain/2. Filters'      ]
  [root.dir '/1. Subscripts'                                        ]
  [root.dir '/2. Model metadata'                                    ]
  [root.dir '/3. Data'                                              ]
};

root.n.sub.dir = size( root.sub.dir, 1 );
for i0 = 1 : root.n.sub.dir
  addpath(   root.  sub.dir{ root.n.sub.dir - (i0 - 1), 1 } )
end

%% [Global ]: Add subdirectories to Simulink path                          
Simulink.fileGenControl( 'set'                                                   ...
                       , 'CacheFolder',   [ root.dir '/2. Model metadata/Work' ] ...
                       , 'CodeGenFolder', [ root.dir '/2. Model metadata/Code' ] ...
                       , 'createDir',       true                                 ...
                       )

% This dumps simulink compilation byproducts out of sight.
% example: slprj folder.
                     
%% End










