function [f, X_f] = fftPlus(T_sample, x, dim, T_fundamental)
% fftPlus.m                                                                
%
%  Performs fft on input data.
%  Transforms raw fft output to scaled, one-sided data.
%
%%% Valid Calls:
%
%  [f, X_f] = fftPlus(T_sample, x                    )
%  [f, X_f] = fftPlus(T_sample, x, dim               )
%  [f, X_f] = fftPlus(T_sample, x, [],  T_fundamental)
%  [f, X_f] = fftPlus(T_sample, x, dim, T_fundamental)
% 
%%% Description:
%
%  Performs fast Fourier transform in the specified dimension.
%
%  Removes redundant symmetries (past the Nyquist frequency) and 
%  correctly scales the data.
%
%%% Assumptions / Limitations:
%
% -The   [input]-domain samples are lineary/evenly distributed.
%  The frequency-domain bins    are lineary/evenly distributed.
%
% -The output data is normalized by the input size; thus it represents 
%  amplitude rather than energy (per Parseval's theorem).
%
%%% Notes: 
%
% -If the dimension of the input data in which the fft is to be performed 
%  is not specified, the fft is taken in the in the dimension with the 
%  greatest size.
%
% -Although a frequency-domain bin corresponding to (near-)bias is provided
%  by the fft, without an providing an infinite period of data (T=inf), 
%  its fourier equivalent (f=0), cannot be determined with fidelity through 
%  the use of an fft.
%
%  If a fundamental period (T_fundamental) is provided, the function 
%  extracts the bias by calculating the mean of the data and replaces the
%  data in the frequency bin for bias (f=0) with this information. 
%
%  If the fundamental period is specified as finite, then the mean 
%  calculation truncates any input data samples which form a partial cycle.  
%
%  If T_fundamental = inf, the mean considers all input data.  This is not
%  recommended if the data includes relatively few complete cycles.
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
%        (d/dt)^n( x(t) ) =  X(f) * ( 2*pi*f_fund. * exp(+1j * pi/2) )^(n)
%
%  The n-th integral   of the [input]-domain input data may be taken by
%  dividing    the frequency-domain data by (2*pi*f_fundamental * 1j)^(n)
%
%    (integral)^n( x(t) ) =  X(f) / ( 2*pi*f_fund * exp(+1j * pi/2) )^(n)
%
%%% Inputs:
%
%  T_sample      - sampling period (inverse of sampling frequency)
%                  [  T.sample = 1 / f.sample]
%
%                  [  T.sample * n.sample.cycle =   T.fundamental]
%                  [1/f.sample * n.sample.cycle = 1/f.fundamental]
%                  [  f.sample = n.sample.cycle *   f.fundamental]
%
%                    unit: [varies (s/sample, rad/sample, ...)]
%                    size: [1]
%                    note: [corresponds to x]
%
%  x             - [input]-domain data
%                    unit: [varies (V, A, ...)] 
%                    size: [varies (n.pts in dimension dim)]
%
%  dim           - dimension in which to perform fft
%                  dimension of X which corresponds to f
%                  dimension of x   which corresponds to t
%                    unit: [-] [integer]
%                    size: [1]
%                    note: [optional input]
%
%  T_fundamental - fundamental cycle period 
%                  inverse of fundamental frequency
%                  [  T.fundamental = 1 / f.fundamental]
%
%                  [see T_sample for further relations.]
%
%                    unit: [varies (s/sample, rad/sample, ...)]
%                    size: [1]
%                    note: [optional input]
%                          [corresponds to x]
%
%%% Outputs:
%
%  f             - frequency-domain bins
%                    unit: [varies (1/s, 1/rad, ...)]
%                    size: [ceil( (n.pts+1)/2 )]
%
%  X_f           - frequency-domain data
%                    unit: [varies (V, A, ...)] [complex]
%                    size: [varies( ceil( (n.pts+1)/2 ) in dimension dim)]
%                    note: [corresponds to f]
%
%%% Dependencies:
%
%  [None.]
%

%% Verify (Empty inputs)                                                   

if isempty(T_sample) || isempty(x)
    f   = []; 
    X_f = [];
    return
end

%% Verify (validateattributes)                                             

validateattributes(                           ...
    x,                                        ...
    {'numeric'},                              ...  
    {}                                        );

validateattributes(                           ...
    T_sample,                                 ...
    {'numeric'},                              ...
    {'scalar', 'real', 'positive'}            );

if exist('dim', 'var') && ~isempty(dim)
validateattributes(                           ...
    dim,                                      ...
    {'numeric'},                              ...
    {'scalar', 'real', 'integer', 'positive'} );
end

if exist('T_fundamental', 'var')
validateattributes(                           ...
    T_fundamental,                            ...
    {'numeric'},                              ...
    {'scalar', 'real', 'postive'}             );
end

%% Determine sizing information                                            

x_size = size(x);

% Number of dimensions:

if min( x_size == 1 ); n_dim = 1;
else                   n_dim = ndims(x);
end

if exist('dim', 'var') && ~isempty(dim)
assert( dim <= n_dim,                                   ...
      ['dim > ndims(x)\n',                              ...
       'User-specified dimension is greater than ',     ...
       'number of dimensions included with input data.' ...
      ] );
end


% Number of samples:

if exist('dim', 'var') && ~isempty(dim); % If dim is provided, use dim
     n_sample       = x_size(dim);
else                                     % Else, use the dimension with the
    [n_sample, dim] = max( x_size );     % the greatest number of samples.
end

%% Shift fft dimension to first dimension                                  

  x      = shiftdim(x,      dim-1);
% x_size = shiftdim(x_size, dim-1);

% NOTE: This is performed to allow steps with array indexing to be
%   independent of the number of dimensions of the input data and
%   independent of the specified dimension which corresponds to f.

%% Perform fft                                                             

X_f = fft(x, n_sample, 1); % Energy, per Parseval's theorem.
X_f = X_f / n_sample;      % Actual amplitude.

% Number of bins:

N_bin = size(X_f, 1); 

% Bins are the frequency-domain equivalent of [input]-domain samples.

% The number of bins resulting from the raw fft is equal to the number of 
%  samples provided in the input data.               % [N_bin = n_sample]

%% Remove symmetries                                                       

% NOTE: The fft command provides a symmetric result.
%
%   The first point, which represents the zero-frequency bin (bias),
%   is never mirrored by the symmetry.
%
%   If the number of symmetric points is odd,
%   then the symmetry midpoint is not mirrored by the symmetry.

% Calculate the number of unique bins: 
N_bin = 1 + ceil( (N_bin-1)/2 ); % the right-side symmetries are excluded.
% This is the bias-point plus 1/2 of all other points [rounded up].

% Truncate the symmetry:
X_f  = X_f(1:N_bin,:,:);

% Double the magnitude of the points whose symmetries were truncated:

if rem(n_sample-1,2)   % Odd  number of nonzero frequency points
     X_f(2:N_bin-1,:,:) = X_f(2:N_bin-1,:,:) * 2;
else                   % Even number of nonzero frequency points
     X_f(2:N_bin  ,:,:) = X_f(2:N_bin  ,:,:) * 2;
end

% NOTE: As stated above The zero frequency is never doubled, and
%       if the number of nonzero frequency points is odd,
%       then the final frequency point is also not doubled.

%% Extract bias                                                            

if exist('T_fundamental', 'var')

n_sample_cycle     = T_fundamental / T_sample; % number of samples/cycle
n_sample_noPartial = n_sample - mod(n_sample, n_sample_cycle);
        % total number of samples, after truncation of any partial cycle

if T_fundamental == inf; X_bias = mean( x( 1:n_sample          ,:,:), dim);
else                     X_bias = mean( x( 1:n_sample_noPartial,:,:), dim);
end

X_f(1,:,:) = X_bias;

end

%% Revert shifted dimensions to their original state                       

X_f = shiftdim(X_f, -(dim-1) + n_dim );

% NOTE: when the shift is positive, shiftdim is cyclical
%       when the shift is negative, shiftdim pads additional dimensions
%       n_dim is added to prevent padding.

%% Determine the span of frequency bins                                    

  T_cycle      = T_sample * n_sample;

% f_sample     = 1 / T_sample;
  f_resolution = 1 / T_cycle;

  f            = (0:N_bin-1).' * f_resolution;

% f_resolution is the frequency-domain equivalent of
%  the [input]-domain sample       period, T_sample.

% f_resolution is the frequency-domain equivalent of
%  the [input]-domain data-logging period, T_cycle.

%% End




















