% A programm made to create waves of all kind of shapes

% If you want to create an interesting wave, you should input:
% - Frequency: the number of "repetitions" of the wave in 1 second
% - Amplitude: half the y-distance between a max and min
% - Intersection: the y-coord at x = 0
% - Movement: the percentage of the wave that is already covered at x = 0

% This programm focuses on: square, triangle, and sawtooth waves, whose
% behavior is already standarized

w_type = input('Enter:\n1) Square Wave\n2) Triangle Wave\n3) Sawtooth Wave\n4) Interpolation data\n');
num = input('Enter the number of vectors or terms of the sum:\n');

if not(w_type == 4)
    f_ = input('Enter the frequency of the wave:\n');
    a_ = input('Enter the amplitude of the wave:\n');
    i_ = input('Enter the y-intersection of the wave at x = 0:\n');
    p_ = input('Enter the percentage of the wave that is already covered at x = 0:\n');
    
    time = 1/f_; % Time that takes the wave to complete 1 revolution
    x = linspace(0,time,num)'; % Domain
    data = [x, zeros(num,1)]; % Data box
    h = 100/num; % Percentage increments
    k = 1; % Index position

    switch w_type
        case 1
            data(k,2) = i_;
            p_ = p_ + h;
            k = k + 1;
            while k <= num
                if or(p_ == 50, p_ == 150)
                    data(k,2) = data(k-1,2) - 2*a_;
                elseif or(p_ == 100, p_ == 200)
                    data(k,2) = data(k-1,2) + 2*a_;
                else
                    data(k,2) = data(k-1,2);
                end
                p_ = p_ + h;
                k = k + 1;
            end   
            fun = Ingenuity(data,time,num);
            fun = fun{2};
            fplot(fun,[-time time])
        case 2
            m = 4*a_/time;
            data(k,2) = i_;
            p_ = p_ + h;
            k = k + 1;
            while k <= num
                if or(p_ <= 25, and(p_ > 100, p_ <= 125)) % positive
                    data(k,2) = m*(data(k,1) - data(k-1,1)) + data(k-1,2);
                elseif or(and(p_ > 25, p_ <= 75),and(p_ > 125, p_ <= 175)) % negative
                    data(k,2) = -m*(data(k,1) - data(k-1,1)) + data(k-1,2);
                elseif or(and(p_ > 75, p_ <= 100),and(p_ > 175, p_ <= 200)) % positive
                    data(k,2) = m*(data(k,1) - data(k-1,1)) + data(k-1,2);
                end
                p_ = p_ + h;
                k = k + 1;
            end
            fun = Ingenuity(data,time,num);
            fun = fun{2};
            fplot(fun,[-time time])
        case 3
            m = 2*a_/time;
            data(k,2) = i_;
            p_ = p_ + h;
            k = k + 1;
            while k <= num
                if or(p_ == 50, p_ == 150)
                    data(k,2) = m*(data(k,1) - data(k-1,1)) + data(k-1,2) - 2*a_;
                else
                    data(k,2) = m*(data(k,1) - data(k-1,1)) + data(k-1,2);
                end
                p_ = p_ + h;
                k = k + 1;
            end
            fun = Ingenuity(data,time,num);
            fun = fun{2};
            fplot(fun,[-time time])
    end
    
elseif w_type == 4
    data = input('Enter the data matrix of discreet points:\n');
    x = data(:,1);
    v = data(:,2);
    xq = x(1):(x(end)-x(1))/num:x(end);
    vq1 = interp1(x,v,xq);
    [dim, Cdim] = Ingenuity_mod([xq' vq1'],x(end)-x(1),num,1);
    fun = dim{2};
    fplot(fun,[x(1) x(end)])
end