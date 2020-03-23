//funcprot(0)
//clear all;

function y=conv_direct(x,h)
    m = length(x);
    n = length(h);
    for i = 1: n + m -1
        conv_sum = 0;
        for j = 1:i
            if ( ( (i-j+1)<=n ) & (j<=m) )
                conv_sum = conv_sum + x(j)*h(i-j+1);
            end;
            y(i) = conv_sum;
        end;
    end;
endfunction;

function y=conv_freqdom(x,h)
    m = length(x);
    n = length(h);
    
    N = n + m-1;
    x = [x zeros(1,N-m)];
    h = [h zeros(1,N-n)];
    f1 = fft(x)
    f2 = fft(h)
    f3 = f1 .* f2 ;
    f4 = ifft(f3)
    y = f4
endfunction;



function y=conv_timetest(x,h)

endfunction



function main(irc_path, snd_path, convol_path,freqdom_path)
// here goes sound convolution application
    [irc, Fs_irc, bits_irc] =wavread(irc_path)
    [snd, Fs_snd, bits_snd]=wavread(snd_path)

    snd = snd(1,:)
    snd = snd ./ max(snd(:))    

    irc = irc(1,:)    
    
    irc= irc ./ max(irc(:))     
   
    disp(Fs_irc,'irc fs', Fs_snd, 'snd_fs',44100,'fs')
    disp(size(snd),'snd size')
    disp(size(irc),'irc size')
    playsnd(snd, Fs_snd)
    playsnd(irc, Fs_irc) 
    

    tic()
    //y = conv_direct(snd,irc)
    t = toc()
    //mprintf('Convolution snd*irc using Direct Formula Method took time = %f ms',1000*t)
    //disp('')
    //disp(y')
    //playsnd(y',44100)
    //wavwrite(y, Fs_snd, bits_snd, "results/direct.wav")
    

    tic()
    y = convol(snd,irc)
    t=toc()
    mprintf('Convolution snd*irc using Built-In ""convol"" took time = %f ms',1000*t)
    disp('')
    y = y ./ max(y(:))
    //disp(y)
    playsnd(y, Fs_snd)
    wavwrite(y, Fs_snd, bits_snd, convol_path)

    clf;
    figure(0)
    subplot(3, 1, 1);
    xlabel('Samples');
    ylabel('Amplitude');
    title('Original Sound');
    plot(snd);
    
    subplot(3, 1, 2);
    xlabel('Samples');
    ylabel('Amplitude');
    title('IRC');
    plot(irc);
    
    subplot(3, 1, 3);
    xlabel('Samples');
    ylabel('Amplitude');
    title('Convolved by built-in <convol> Sound [sound*IRC]');
    plot(y);
    
    tic()
    y = conv_freqdom(snd,irc)
    t=toc()
    mprintf('Convolution snd*irc using Frequency Domain multiplication took time = %f ms',1000*t)
    disp('')
    y = y'
    y = y ./ max(y(:))
    //disp(y)
    playsnd(y,Fs_snd)
    wavwrite(y, Fs_snd, bits_snd, freqdom_path)
    
    figure(1)
    subplot(3, 1, 1);
    xlabel('Samples');
    ylabel('Amplitude');
    title('Original Sound');
    plot(snd);
    
    subplot(3, 1, 2);
    xlabel('Samples');
    ylabel('Amplitude');
    title('IRC');
    plot(irc);
    
    subplot(3, 1, 3);
    xlabel('Samples');
    ylabel('Amplitude');
    title('Convolved Sound by <frequency domain multiplication> [sound*IRC]');
    plot(y);
    

endfunction

main('data/irc/canteen.wav','data/raw/voice.wav',"data/results/convol_c_voice.wav","data/results/freqdom_c_voice.wav")
main('data/irc/peregovor.wav','data/raw/voice.wav',"data/results/convol_p_voice.wav","data/results/freqdom_p_voice.wav")

main('data/irc/canteen.wav','data/raw/violin.wav',"data/results/convol_c_violin.wav","data/results/freqdom_c_violin.wav")

main('data/irc/canteen.wav','data/raw/drums.wav',"data/results/convol_c_drums.wav","data/results/freqdom_c_drums.wav")

main('data/irc/canteen.wav','data/raw/our.wav',"data/results/convol_c_our.wav","data/results/freqdom_c_our.wav")


