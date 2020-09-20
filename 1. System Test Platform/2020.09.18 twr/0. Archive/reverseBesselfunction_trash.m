for n = 1:10

for k = 0:n
  
s{n,1}(1,n-k+1) = factorial(2*n - k) / ( 2^(n-k) * factorial(k) * factorial(n-k) ) 

end

end