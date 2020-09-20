clearvars
clc

w.sample   = 0.01;
w.start    = +00;
w.end      = +1000;

f.cutoff   = 2;
w.cutoff   = 2 * pi * f.cutoff;

w.w        = (w.start : w.sample : w.end)';
x.w        = w.cutoff ./ (1j * w.w + w.cutoff);

figure 
subplot(2,1,1)
semilogx(w.w / (2*pi), 20 * log10( abs(x.w) ) )
xlabel('Frequency [1/s]')
grid minor

subplot(2,1,2)
semilogx(w.w / (2*pi), angle( x.w ) )
xlabel('Frequency [1/s]')
grid minor
