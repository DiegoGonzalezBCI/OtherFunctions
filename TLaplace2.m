% The laplace transform
% Similarly as fourier transform, the laplace is an operator which allows
% us to know the exact coeficients of a given function, this time defined
% as a conbination of both sinusoidal and exponential. 

% The Steps are as follows:
% - Let f(t) be a function defined as the product of a finite sum of both
% sinusoidal and exponential; let F be a matrix data represanting it.
% - Let g(t) be a function defined as a consecutive-changing exponential.
% - Let fg(t) be the product of both f and g for any given alpha. 
% - Apply the fourier transform to fg(t).
% - The domain at which g(t) shall extend stops when its Fourier Transform
% reaches a greater value than the main coefficient.

whal = input('Enter 1 for predefined function and 0 for data:\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if whal == 1
    % Para funciones pre-definidas:
    % f = @(t)5*exp(-t).*cos(2*pi*3*t); % Se usa un coseno para encontrar la intersección en y
    % f = @(t)exp(-0.5*t).*(cos(2*pi*3*t)+cos(2*pi*5*t)+cos(2*pi*7*t)+cos(2*pi*9*t));
    % f = @(t)exp(-0.5*t).*(cos(2*pi*3*t)+cos(2*pi*5*t));
    f = @(t)exp(-0.05*t).*(cos(2*pi*3*t)+cos(2*pi*5*t)+cos(2*pi*7*t));
    t = linspace(0,50,10000)'; % Es preferible usar un dominio grande, ya que esto nos permite extraer la mayor cantidad de información de la señal original, sobre todo cuando esta no es periódica
    % Nota que alpha y el tiempo deben ir de la mano para que la Transformada
    % funcione, ya que usar alpha negativo corresponde con tiempos positivos y
    % viceversa.
    f_ = f(t);
    % Se encuentra la intersección por el eje y:
    intersection = f(0);
elseif whal == 0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Para funciones de datos:
    % Toma en cuenta que si los datos contienen información fuera del dominio
    % de convergencia, la Transformada no funcionará.
    data = importdata('entrada.csv');
    data = data.data;
    whal1 = input('Enter an option:\n1.- Sin interpolación sin dummy\n2.- Sin interpolación con dummy\n3.- Con interpolación sin dummy\n4.- Con interpolación con dummy\n');
    switch whal1
        case 4
    % Interpolation  con dummy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    num = 1000; 
    x1 = data(:,1); 
    v1 = data(:,2); 
    xq = x1(1):(x1(end)-x1(1))/num:x1(end); 
    vq1 = interp1(x1,v1,xq); 
    t = xq'; 
    dummy1 = @(t)cos(2*pi*3*t); 
    dummy2 = dummy1(t).*vq1'; 
    f_ = dummy2;
        case 2
    % Sin interpolación con dummy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t = data(:,1); 
    dummy1 = @(t)cos(2*pi*3*t); 
    dummy2 = dummy1(t).*data(:,2); 
    f_ = dummy2;
        case 1
    % Sin interpolación Sin dummy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t = data(:,1); 
    f_ = data(:,2); 
        case 3
    % Con interpolación sin dummy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Se aplica una extrapolación de la forma:
    % f(x_n+1) = f(x_n) + delta_x*derivada_de_f(x_n)
    % donde delta_x es arbitrariamente grande debido a la linealidad del sistema
    der_f = (data(end,2)-data(end-1,2))/(data(2,1)-data(1,1));
    data(end+1,:) = [data(end,1) + 0.5, data(end,2) + 0.5*der_f];
    data(end+1:end+9,:) = [[12 13 14 15 16 17 18 19 20]' data(end,2)*ones(9,1)];
    num = 1000; 
    x1 = data(:,1); 
    v1 = data(:,2); 
    xq = x1(1):(x1(end)-x1(1))/num:x1(end); 
    vq1 = interp1(x1,v1,xq); 
    t = xq'; 
    f_ = vq1';
    end
    % Se encuentra la intersección por el eje y:
    for i = 1:length(t)
        if and(t(i)>-0.01, t(i)<0.01)
            intersection = f_(i);
            break
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = [];
plot3(0,0,0)
hold on
sgtitle('Discrete Laplace Transform','FontSize',15)
xlabel('Frequency','FontSize',15);
ylabel('Alpha','FontSize',15);
zlabel('Magnitude','FontSize',15);
fin = 0;
frequencies = []; % Initialize an array to store detected frequencies
amplitudes = []; % Initialize amplitudes array

dom = 5; % Dominio de búsqueda en alpha (de -alpa a alpha)
frecMax = 10; % Dominio del búsqueda en frecuencia
frecMin = -10;
h = 0.001; % Tamaño de Paso
c = zeros(1,2*round(dom/h)); % Se crea el dominio intercalado de C
cont1 = 0;
cont2 = 1;
for i = 1:round(dom/h)
    c(i+cont1) = i*h;
    c(i+cont2) = -i*h;
    cont1 = cont1 + 1;
    cont2 = cont2 + 1;
end
c = [0 c];

% Compute the alpha and all frequencies
for a = c 
    g = @(t)exp(-a*t);
    g_ = g(t);
    fg = [t f_.*g_];
    M = [];
    for n = frecMin:h:frecMax 
        E = exp(-2*pi*1i*n*t);
        M = cat(1,M,dot(fg(:,2),E)/length(t)); 
    end
    d = cat(2,d,M);
    plot3(frecMin:h:frecMax,ones(size(M,1),1)*a,2*abs(M)./intersection) % Para compensar la magnitud negativa y positiva
    hold on
    pause(0.001)
    for k = 1:length(M)
        if 2*abs(M(k)) >= abs(intersection)
            fin = 1;
            detected_freq = frecMin + h * (k - 1); % Compute the frequency
            frequencies = [frequencies, detected_freq]; % Store the frequency
            amplitudes = [amplitudes, 2*abs(M(k))./intersection]; % Store the amplitude
        end
    end
    if fin == 1
        break
    end
end


% K tiene la información para reconstruir la señal
% Ciertas señales pueden tener distinta frecuencia
% frec = h*k-abs(frecMin);

% new_signal = @(t) intersection * exp(a * t) .* sum(amplitudes' .* cos(2 * pi * frequencies' * t), 1);
new_signal = @(t) exp(a * t) .* sum(amplitudes(length(amplitudes)/2 + 1 : end)' .* cos(2 * pi * frequencies(length(frequencies)/2 + 1 : end)' * t), 1);
figure
plot(t, new_signal(t'),'x')
hold on
if whal == 1
    fplot(f,[t(1) t(end)])
    disp('Original Signal: ')
    disp(f)
    disp('Reconstructed Signal: ')
    disp(new_signal)
elseif whal == 0
    plot(t,f_)
end
legend('Reconstructed signal','Original Signal','FontSize',15)
title('Best approximation','FontSize',15)
