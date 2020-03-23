function res = conv(coef, signal)
    res = coef * signal(length(signal):-1:1)';
endfunction

function y_k=count_out(x, y, b, a)
    y_k = conv(b, x) +  conv(a, y);
endfunction

function filt = count_next(filter1, x_s)
    tmp  = count_out(x_s(filter1.k+1:1: filter1.k+3), filter1.y_s(filter1.k+1:1:filter1.k+2), filter1.b_s,  filter1.a_s);
    filter1.y_s(filter1.k + 3)  = tmp;
    filter1.k = filter1.k + 1;
    filt = filter1
endfunction

function filter_synthetic_signals(highpass_filter, lowpass_filter)
    
    //x_s = [0 0 0.5 0.56 0.58 0.575 0.56 ] // slow changing
    x_s = [0 0 1 0.5 0.9 0.5 1 0.6 1] // fast changing
    for i = 1:5
        lowpass_filter = count_next(lowpass_filter, x_s);
    end
    for i = 1:5
        highpass_filter = count_next(highpass_filter, x_s);
    end
    disp('Input signal: ');
    disp(x_s);
    disp('Lowpass: ');
    disp(lowpass_filter.y_s);
    disp('Highpass: ');
    disp(highpass_filter.y_s);
endfunction

function res = filtering(filter1, x_s)
    len = length(x_s) - 2
    for i = 1: len
        filter1.y_s(filter1.k + 3)  = count_out(x_s(filter1.k+1:1: filter1.k+3), filter1.y_s(filter1.k+1:1:filter1.k+2), filter1.b_s,  filter1.a_s);
        filter1.k = filter1.k + 1;  
    end
    res = filter1.y_s
endfunction

lowpass_filter = struct('b_s', 'a_s', 'y_s', 'k');
lowpass_filter.b_s =  [0.00008765554875401547 0.00017531109750803094 0.00008765554875401547];
lowpass_filter.a_s = [1.9733442497812987  -0.9736948719763];
lowpass_filter.y_s = [0 0];
lowpass_filter.k = 0;

highpass_filter = struct('b_s', 'a_s', 'y_s', 'k');
highpass_filter.b_s =  [0.40495734254626874  -0.8099146850925375  0.4049573425462687];
highpass_filter.a_s = [-0.3769782747249014 -0.19680764477614976];
highpass_filter.y_s = [0 0];
highpass_filter.k = 0;
//filter_synthetic_signals(highpass_filter, lowpass_filter);

x = loadwave('data/violin.wav'); 
//playsnd(x);

len = length(x);
x = cat(2, [0 0 ], x);
lowpass_filter.k = 0;
lowpass_filter.y_s = [0 0];
highpass_filter.k = 0;
highpass_filter.y_s = [0 0];
low_res = filtering( lowpass_filter, x);
high_res = filtering(highpass_filter, x);
savewave('data/my_violin_filter_low', low_res, 44100);
savewave('data/my_violin_filter_high', high_res, 44100);
tmp = 1:1: len;

clf;
subplot(3, 2, 1);
xlabel('Samples');
ylabel('Amplitude');
title('Original signal');
plot( x(3: len+2 ));

subplot(3, 2, 3);
xlabel('Samples');
ylabel('Amplitude');
title('Lowpass filtering');
plot(low_res(3: len+2 ));

subplot(3, 2, 5);
xlabel('Samples');
ylabel('Amplitude');
title('Highpass filtering');
plot(high_res(3: len+2));

subplot(3, 2, 2);
xlabel('Samples');
ylabel('Amplitude');
title('Original signal');
plot(x(3: len+2 ));

subplot(3, 2, 4);
xlabel('Samples');
ylabel('Amplitude');
title('Lowpass filtering given');
plot(loadwave('data/proc_low.wav'));

subplot(3, 2, 6);
xlabel('Samples');
ylabel('Amplitude');
title('Highpass filtering given');
plot(loadwave('data/proc_high.wav'));

