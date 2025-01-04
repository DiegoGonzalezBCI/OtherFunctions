function dim = Ingenuity(data,time,num)
dim = cell(1,size(data,2));
for i = 1:round(size(data,2)/2)
    if i < size(data,2)
        A = [data(:,i) data(:,i+1)];
    else
        A = [data(:,end) data(:,1)];
    end
    x = '@(t)';
    y = '@(t)';
    C = [];
    k = 0;
    l = round(num/2);
    for n = -l:l
        k = k+1;
        B = [];
        D = [];
        %Scos = strcat('cos(-2*pi*t*',num2str(n),'/',num2str(time),')');
        %Ssin = strcat('sin(-2*pi*t*',num2str(n),'/',num2str(time),')');
        for t = 0:time/size(A,1):time
            B = cat(1,B,cos(2*pi*t*n/time));
            D = cat(1,D,sin(2*pi*t*n/time));
        end
        B(end) = [];
        D(end) = [];
        C = cat(1,C,[(dot(B,A(:,1))/size(A,1))-(dot(D,A(:,2))/size(A,1)) (dot(D,A(:,1))/size(A,1))+(dot(B,A(:,2))/size(A,1))]); % Actual Fourier Transform
        Cn = sqrt(C(k,1)^2+C(k,2)^2);
        Tn = atan(C(k,2)/C(k,1));
        if C(k,1) >= 0
            x = strcat(x,'(',num2str(Cn),'*cos((-2*pi*t*',num2str(n),'/',num2str(time),')+',num2str(Tn),'))+');
        else
            x = strcat(x,'(-',num2str(Cn),'*cos((-2*pi*t*',num2str(n),'/',num2str(time),')+',num2str(Tn),'))+');
        end
        Tn = atan(C(k,1)/C(k,2));
        if C(k,2) >= 0
            y = strcat(y,'(',num2str(Cn),'*cos((-2*pi*t*',num2str(n),'/',num2str(time),')-',num2str(Tn),'))+');
        else
            y = strcat(y,'(-',num2str(Cn),'*cos((-2*pi*t*',num2str(n),'/',num2str(time),')-',num2str(Tn),'))+');
        end
        %x = strcat(x,'((',num2str(C(k,1)),')*',Scos,'-(',num2str(C(k,2)),')*',Ssin,')+');
        %y = strcat(y,'((',num2str(C(k,2)),')*',Scos,'+(',num2str(C(k,1)),')*',Ssin,')+');
    end
        x = x(1:end-1);
        x = str2func(x);
        dim{i} = x;
    if i < size(data,2)
        y = y(1:end-1);
        y = str2func(y);
        dim{i+1} = y;
    end
end
end