%% Libraries

%  Set project library paths:
libPath  = '../1. System Test Platform/1. Library/';

libPaths = genpath( libPath  ); % generates all library subpaths;
           addpath( libPaths ); % adds      all library subpaths;
         clearvars('libPath*'); % cleanup

%% Compiler

%  Prepare compiler for s-function generation for arduino:
mex -setup C++                  % set the compiler to the C++ language










