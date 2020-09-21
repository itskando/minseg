%% Libraries

switch 0
case 1 % one time use: add startup to permanent path
 path.start = '/Users/kando/Git/twoWheeledRobot/0. global';
 addpath( path.start );
 savepath
end

%  Set library paths for project:
path.lib  = '../1. System Test Platform/1. Library/';

path.libs = genpath  (  path.lib  ); % generates all library subpaths;
            addpath  (  path.libs ); % adds      all library subpaths;
            clearvars( 'path'     ); % cleanup

%% Compiler

%  Prepare compiler for s-function generation for arduino:
mex -setup C++                  % set the compiler to the C++ language










