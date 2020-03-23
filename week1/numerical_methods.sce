function ydot=f(x, y)
    ydot = - y + 13 * x ^ 2 + 7 * x - 99;
endfunction

function y_build_in = build_in(y0, x0, x)
    y_build_in = ode(y0,x0,x,f);
endfunction

function y = analytical(x)
    y = 13*x^2  - 19 * x + 81 * exp(-x) - 80
endfunction

function y_n= by_element_euler(x, x_prev, y_prev)
    y_n = y_prev + (x - x_prev) * f(x_prev, y_prev);
endfunction

function  y_euler = euler(y0, x0, x)
    y_euler = zeros(length(x));
    y_euler(1) = y0;
    for i = 2:length(x)
        y_euler(i) = by_element_euler(x(i), x(i - 1),   y_euler(i - 1));
    end
    y_euler = mtlb_t(y_euler);
endfunction

function y_n= by_element_runge(x, x_prev, y_prev)
    h = x - x_prev
    k1 = f(x_prev, y_prev)
    k2 = f(x_prev + h / 2, y_prev + h / 2 * k1)
    k3 = f(x_prev + h / 2, y_prev + h / 2 * k2)
    k4 = f(x_prev + h , y_prev + h * k3)
    y_n = y_prev + h / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
endfunction

function  y_runge = runge(y0, x0, x)
    y_runge = zeros(length(x));
    y_runge(1) = y0;
    for i = 2:length(x)
        y_runge(i) = by_element_runge(x(i), x(i - 1),   y_runge(i - 1));
    end
    y_runge = mtlb_t(y_runge);
endfunction

function err= count_error( y_base, y_numerical)
    err = abs(y_base - y_numerical);
endfunction

function num_methods(x0, y0)
    step_sizes = [0.1 0.5 1]
    for i=1:3
        x = 0:step_sizes(i):4;
        y_build_in = ode(y0,x0,x,f);
        y_euler = euler(y0, x0, x);
        y_runge = runge(y0, x0, x);
        subplot(2, 2, i);
        plot(x, y_build_in, 'd', x, y_euler, 'b', x, y_runge, 'r');
        xlabel('x', 'fontsize', 4);
        ylabel('y', 'fontsize', 4);
        legend(['Scilab_numerical';'Euler';'Runge'], pos=2);
        title("Solutions of the equation y'' = -y + 13x^2 + 7x -99  with numerical methods for step size: "  + string(step_sizes(i)), 'fontsize', 3);
    end
    show_window(1);
endfunction

function cmp_errors(x0, y0, fun, method_name, window_n)
    step_sizes = [0.1 0.5 1]
    for i=1:3
        x = 0:step_sizes(i):4;
        y_analytical = analytical(x);
        y_numerical = fun(y0, x0, x);
        
        subplot(3, 2, 2 * i - 1);
        plot(x, y_analytical,  x,  y_numerical);
        xlabel('x', 'fontsize', 4);
        ylabel('y', 'fontsize', 4);
        legend(['Analytical'; method_name],  pos=2);
        title(method_name + ' and analytival sulutions for  step size: ' + string(step_sizes(i)), 'fontsize', 4);
        
        subplot(3, 2, 2 * i);
        errors = count_error(y_numerical, y_analytical);
        mean_err = mean(errors);
        plot(x, errors, x,  (ones(1:length(x))) * mean_err);
        xlabel('x', 'fontsize', 4);
        ylabel('error', 'fontsize', 4);
        legend(['Error'; 'Mean error'], pos=2);
        title(method_name + ' error for step size : ' + string(step_sizes(i)), 'fontsize', 4);
    end
    if window_n < 4 then
        show_window(window_n);
    end
endfunction

y0=1;
x0=0;
num_methods(x0, y0);
cmp_errors(x0, y0, build_in, 'Scilab build-in', 2);
cmp_errors(x0, y0, euler, 'Euler', 3);
cmp_errors(x0, y0, runge, 'Runge-Kutta', 4);
