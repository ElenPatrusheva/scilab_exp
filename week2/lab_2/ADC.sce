function [converted_y] = ADC(n, window_bound, selected_rate)

//load('data/data'+string(n))
filename = 'data/data'+string(n) + '_v2'
M = csvRead(filename)
Fs = M(1);
y = M(2:size(M,1))';
windows_n = size(window_bound, 2)
converted_y = zeros(size(y,2));
i = 0;
for window_y = window_bound;
    i = i+1;
    converted_y(y > window_y) = window_y;
end

rate_step = Fs/selected_rate;
converted_y = converted_y(1:rate_step:size(y,2))

disp('AD converted')

endfunction
