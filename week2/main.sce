b = chdir('/home/elena/Documents/week2/lab_2');
exec('ADC.sce');
function noise=get_sinus(sin_freq, fs, sin_ampl)
    step_size = sin_freq*(2*%pi)/fs;
    part_len = size(recorded_data, "r") / fs
    samples = (1:fs*part_len)*step_size;
    noise = mtlb_t(sin_ampl*sin(samples));
endfunction
function try_frequencies(n, record,fs, sin_ampl)
    f =figure(n);
    clf;
    counter = 1;
    for sin_freq = 120:10:210
        noise = get_sinus(sin_freq, fs, sin_ampl);
        cleaned = record - noise;
        subplot(4,3,counter);
        plot(cleaned);
        xlabel('samples');
        ylabel('Amplitude');
        title('Cleaned record for sin frequency ' + string(sin_freq));
        counter = counter + 1;
    show_window(n);
    xname('Frame number ' + string(n));
    end
endfunction
quant_levels = (-1:0.001:0.5);
sin_ampl = 0.1;
fs_s =[32000, 22050, 32050, 22050, 32050, 32000, 32000 ,22050, 22050, 22050, 32000, 32000,  22050, 32000];
freq_s =[200, 150, 180, 120, 210, 180, 140, 120, 150, 210, 150, 190, 140, 210];
// The part required to find frequences
/*
for n=1:14
    fs = fs_s(n);
    recorded_data = ADC(n, quant_levels, fs);
    shift = mean(recorded_data);
    try_frequencies(n, recorded_data, fs);
end
*/



result = [];
original_s = [];
for n=1:14
    recorded_data = ADC(n, quant_levels, fs_s(n));
    shift = mean(recorded_data);
    recorded_data = recorded_data - shift;
    cleaned = recorded_data - get_sinus(freq_s(n), fs_s(n), sin_ampl);
    result(n).entries = cleaned;
    original_s(n).entries = recorded_data;
    //playsnd(cleaned, fs_s(n));
end
for n=1:14
    playsnd(result(n).entries, fs_s(n));
end