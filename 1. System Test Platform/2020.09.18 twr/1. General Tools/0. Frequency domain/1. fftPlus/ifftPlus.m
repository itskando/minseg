function [t, x] = ifftPlus...
         (f_resolution, X_f, n_sample, dim, t_offset)
%% ifftPlus.m -                                                             
%
%  Performs (unscaled) inverse discrete fourier transform on input data.
%
%%% Valid Calls:
%
%  [t, x] = ifftPlus(f_resolution, X_f,                        )
%  [t, x] = ifftPlus(f_resolution, X_f, n_sample               )
%  [t, x] = ifftPlus(f_resolution, X_f, [],       dim          )
%  [t, x] = ifftPlus(f_resolution, X_f, n_sample, dim          )
%
%  [t, x] = ifftPlus(f_resolution, X_f, [],       [],  t_offset)
%  [t, x] = ifftPlus(f_resolution, X_f, n_sample, [],  t_offset)
%  [t, x] = ifftPlus(f_resolution, X_f, [],       dim, t_offset)
%  [t, x] = ifftPlus(f_resolution, X_f, n_sample, dim, t_offset)
%
%%% Description:
%
%  Performs inverse discrete fast fourier transformation (ifft) on 
%  frequency-domain input data.
%
%  No scaling is performed on the input data.
%
%  User may optionally incorporate additional [output]-domain shift.
%
%%% Assumptions / Limitations:
%
% -The   [input]-domain samples are lineary/evenly distributed.
%  The frequency-domain bins    are lineary/evenly distributed.
%
% -The input data is not scaled. [See notes.]
%
%%% Notes:
%
% -Differences between the Matlab (i)fft and (i)fftPlus scripts:
%
%  The Matlab  fft function performs no scaling based size of input data.
%  The Matlab ifft function performs    scaling based size of input data.
%    whereas
%  The     fftPlus function performs    scaling based size of input data.
%  The    ifftPlus function performs no scaling based size of input data.
%
%    thus:
%
%  The Matlab  fft function calculates energy, per Parseval's theorem.
%  The Matlab ifft function converts input energy to amplitude by default.
%    whereas
%  The     fftPlus function calculates amplitude by default.
%  The    ifftPlus function performs no conversions.
%
%%% Recall:
%
% -The n-th derivative of the [input]-domain input data may be taken by
%  multiplying the frequency-domain data by (2*pi*f_fundamental * 1j)^(n)
%
%        (d/dt)^n( x(t) ) =  X(f) * ( 2*pi*f_fund * exp(+1j * pi/2) )^(n)
%
%  The n-th integral   of the [input]-domain input data may be taken by
%  dividing    the frequency-domain data by (2*pi*f_fundamental * 1j)^(n)
%
%    (integral)^n( x(t) ) =  X(f) / ( 2*pi*f_fund * exp(+1j * pi/2) )^(n)
%
%%% Required Inputs:
%
%  f_resolution  - frequency resolution
%                  frequency-domain equivalent of input-domain sample step
%                    unit: [varies (1/s, 1/rad, ...)]
%                    size: [1]
%                    note: [directly calculates frequency-domain bins, f]
%                          [first index of f will represent bias term, f=0]
%
%  X_f           - frequency-domain data (bias measurement, f = 0)
%                    unit: [varies (V, A, ...)] [complex]
%                    size: [varies (n.pts in dimension dim)]
%                    note: [corresponds to f]
%
%  n_sample      - number of samples provided by ifft
%                    unit: [samples/cycle]
%                    size: [1]
%                    note: [optional input]
%
%  dim           - dimension in which to perform fft
%                  dimension of X_f which corresponds to f
%                  dimension of x   which corresponds to t
%                    unit: [-] [integer]
%                    size: [1]
%                    note: [optional input]
%
%  t_offset      - offset applied to [output]-domain samples.
%                    unit: [varies (s, rad, ...)]
%                    size: [1]
%                    note: [optional input]
%                          [corresponds to [output]-domain samples t]
%                          [rounds to nearest multiple of T_sample]
%
%%% Outputs:
%
%  t             - [output]-domain samples
%                    unit: [varies (s, rad, ...)]
%                    size: [n.pts]
%
%  x             - [output]-domain data
%                    unit: [varies (samples/s, samples/rad, ...)]
%                    size: [n.pts]
%                    note: [corresponds to [output]-domain samples t]
%
%%% Dependencies:
%
%  [None.]
%

%% Future Work
%
% Remove additional for-loops for (significant) runtime optimization.

%% Verify (Empty inputs)                                                   

if isempty(f_resolution) || isempty(X_f)
    t = []; 
    x = [];
    return
end

%% Verify (validateattributes)                                             

if exist('f','var')
validateattributes(                           ...
    f_resolution,                             ...
    {'numeric'},                              ...  
    {'vector', 'real', 'increasing', '>=', 0} );
end

validateattributes(                           ...
    X_f,                                      ...
    {'numeric'},                              ...
    {}                                        );

if exist('n_sample', 'var') && ~isempty(n_sample)
validateattributes(                           ...
    n_sample,                                 ...
    {'numeric'},                              ...
    {'scalar', 'real', 'integer', 'positive'} ); 
end

if exist('dim', 'var')      && ~isempty(dim)
validateattributes(                           ...
    dim,                                      ...
    {'numeric'},                              ...
    {'scalar', 'real', 'integer', 'positive'} );
end

if exist('t_offset','var')  && ~isempty(t_offset)
validateattributes(                           ...
    t_offset,                                 ...
    {'numeric'},                              ...
    {'scalar', 'real'}                        );
end

%% Determine sizing information                                            

X_f_size = size(X_f);

% Number of dimensions:

if min( X_f_size == 1 ); n_dim = 1;
else                     n_dim = ndims(X_f);
end

if exist('dim', 'var') && ~isempty(dim)
assert( dim <= n_dim,                                   ...
      ['dim > ndims(x)\n',                              ...
       'User-specified dimension is greater than ',     ...
       'number of dimensions included with input data.' ...
      ] );
end

% Number of bins:

% NOTE: The bin for bias (f=0) is included.

if exist('dim', 'var') && ~isempty(dim); % If dim is provided, use dim
     N_bin       = X_f_size(dim);
else                                     % Else, use the dimension with the
    [N_bin, dim] = max( X_f_size );      % the greatest number of bins.
end

%% Determine number of time samples if n_sample is not provided            

if ~exist('n_sample','var') || isempty(n_sample)
n_sample = 2 * (N_bin-1); % The bin for bias (f = 0) should be and is
end                       % removed from the count.

% Nyquist quantity is used. 
% This provides the maximum number of points which provide information from
%   the frequency data, without adding redundancies.

%% Set t_offset to zero if it is not provided                              

if ~exist('t_offset','var') || isempty(t_offset)
t_offset = 0;
end

%% [output]-domain vector of samples                                       

T_cycle  = 1 / f_resolution;
T_sample = T_cycle / n_sample;

n_offset = round( t_offset / T_sample );

t        = ( (0:n_sample-1).' + n_offset ) * T_sample;

%% Shift fft dimension to first dimension                                  

X_f      = shiftdim (X_f,        dim-1    );
X_f_size = circshift(X_f_size, -(dim-1), 2);

% NOTE: This is performed to allow steps with array indexing to be
%   independent of the number of dimensions of the input data and
%   independent of the specified dimension which corresponds to f.

%% idft notes                                                              

%  fft: x[n] = sum{0,N.bin-1}{X[N] .* e^(j * -2*pi*f[N] * n ) } * 1/N
% ifft: x[n] = sum{0,N.bin-1}{X[N] .* e^(j * +2*pi*f[N] * n ) } * 1/1

% < t.discrete = n * T.sample      >
% < f.discrete = N * f.fundamental >
%
% x[t] = sum{0,N.bin-1}{X[N] .* e^(j * 2*pi*f[N]       * t            ) }
% x[t] = sum{0,N.bin-1}{X[N] .* e^(j * 2*pi*f[N]       * (n*T.sample) ) }
% x[t] = sum{0,N.bin-1}{X[N] .* e^(j * 2*pi*(f.fund*N) * (n*T.sample) ) }
%
% <   T.sample * n.sample =   T.fundamental             >
% < 1/f.sample * n.sample = 1/f.fundamental             >
% <   f.sample            =   f.fundamental * n.sample  >
%
% x[t] = sum{0,N.bin-1}{X[N] .* e^(j*2*pi*f.fundamental*T.sample * N*n ) }
% x[t] = sum{0,N.bin-1}{X[N] .* e^(j*2*pi*f.fundamental/f.sample * N*n ) }
% x[t] = sum{0,N.bin-1}{X[N] .* e^(j*2*pi              /n.sample * N*n ) }
%
% x[t] = sum{0,N.bin-1}{X[N] .* e^(j * 2*pi/n.sample * N * n) }

%% Perform idft [Intuitive code]                                           

% % Initialize
% 
% x_size   = [n_sample X_f_size(2:end)];
% x        = zeros( x_size );
% 
% %idft 
% 
% for n = 0 : n_sample-1
% for N = 0 : N_bin   -1
% 
% x(n+1,:,:) = x  (n+1,:,:)  + ...
%              X_f(N+1,:,:) .* exp( 1j * +2*pi/n_sample * N * n );
% 
% end
% end

%% Perform idft [Actual (computing-optimized) code]                        

% Initialize

x_size   = [n_sample X_f_size(2:end)];
x        = zeros( x_size );

% idft

    N = (0 : N_bin   -1).';
    N = repmat( N, [1 X_f_size(2:end)] );

for n = (0 : n_sample-1);
%disp( [num2str(n) '/' num2str(n_sample)] )
 x(n+1,:,:) = sum(X_f .* exp( 1j * +2*pi/n_sample .* N .* n),1);
end

x = real(x);

%% Revert shifted dimensions to their original state                       

x = shiftdim(x, -(dim-1) + n_dim );

% NOTE: when the shift is positive, shiftdim is cyclical
%       when the shift is negative, shiftdim pads additional dimensions
%       n_dim is added to prevent padding.

%% End
















