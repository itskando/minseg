close all
clearvars
clc

T.sample   = 0.001;
t.start    = -00;
t.end      = +1000;

f.cutoff   = 2;

% w.bin      = 1 / (t.end - t.start);
% w.start    = 0;
% w.span     = 1 / T.sample;

w.cutoff   = 2 * pi * f.cutoff;
T.cutoff   = 1 / f.cutoff;

assert( T.cutoff >= 2.5 * T.sample );

 t.t       = (t.start : T.sample : t.end)';
      u.t  = t.t >= 0;
      x.t  = w.cutoff * exp(-1 * w.cutoff * t.t) .* u.t;
[w.w, x.w] = fftPlus(T.sample, x.t, 1);

n.samples  = size(t.t, 1);
n.bins     = size(w.w, 1);

     % x.w  = x.w * n.bins;

figure
subplot(3,1,1)
plot(t.t, x.t)

subplot(3,1,2)
semilogx(w.w / (2*pi),             abs(x.w)   )
%semilogx(w.w / (2*pi), 20 * log10( abs(x.w) ) )

subplot(3,1,3)
semilogx(w.w / (2*pi), angle( x.w ) )
