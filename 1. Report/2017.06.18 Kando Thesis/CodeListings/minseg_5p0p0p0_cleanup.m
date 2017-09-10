%% [Cleanup]: Remove alternate subdirectories from Matlab path             

Simulink.fileGenControl('reset')

%% [Cleanup]: Remove alternate subdirectories from Simulink path           

for i0 = 1 : root.n.sub.dir
  rmpath(   root.  sub.dir{ root.n.sub.dir - (i0 - 1), 1 } )
end

%% End










