% Un programa que modele las ecuaciones de un doble pendulo y que además
% otorgue su phace space
m1 = input('Give me the mass of the first pendulum:\n')';
l1 = input('Give me the length of the rod of the first pendulum:\n')';
t1 = input('Give me the initial angle of the first pendulum:\n')';
v1 = input('Give me the initial angular speed of the first pendulum:\n')';
m2 = input('Give me the mass of the second pendulum:\n')';
l2 = input('Give me the length of the rod of the second pendulum:\n')';
t2 = input('Give me the initial angle of the second pendulum:\n')';
v2 = input('Give me the initial angular speed of the second pendulum:\n')';
time = input('Give me the time for the animation\n');
whal = input('Click 1 for animation\nClick 2 for phace space\n');
data = [];
s = length(m1);
h = 0.01;
M = m1+m2;
g = 9.81;
if whal == 1
    hold on
    plot(0,0)
    sgtitle('Animation')
    for i = 0:h:time
        hold on
        xlim([-max(l1)-max(l2) max(l1)+max(l2)])
        ylim([-max(l1)-max(l2) max(l1)+max(l2)])
        t1_ = t1 + h*v1;
        t2_ = t2 + h*v2;
        a1 = (m2.*g.*sin(t2).*cos(t1-t2)-l1.*m2.*(v1.^2).*(sin(2.*t1-2.*t2)/2)-m2.*l2.*(v2.^2).*sin(t1-t2)-M.*g.*sin(t1))./(M.*l1-m2.*l1.*(cos(t1-t2).^2));
        v1 = v1 + h*a1;
        a2 = (l1.*(v1.^2).*sin(t1-t2)-g.*sin(t2)-l1.*a1.*cos(t1-t2))./l2;
        v2 = v2 + h*a2;
        t1 = t1_;
        t2 = t2_;
        data = cat(3,data,[t1 t2 v1 v2 a1 a2]);
        CoordX1 = l1.*sin(t1);
        CoordY1 = -l1.*cos(t1);
        CoordX2 = CoordX1 + l2.*sin(t2);
        CoordY2 = CoordY1 - l2.*cos(t2);
        for j = 1:s
            plot([0 CoordX1(j)],[0 CoordY1(j)],'Color','k')
            plot([CoordX1(j) CoordX2(j)],[CoordY1(j) CoordY2(j)],'Color','k')
            plot(CoordX1(j),CoordY1(j),'ob','MarkerSize',10); % To plot the general animation
            plot(CoordX2(j),CoordY2(j),'or','MarkerSize',10); % To plot the general animation
        end
        pause(0.01)
        hold off
        plot(0,0)
    end
elseif whal == 2
    c = color(1:s);
    whal_ = input('Click 1 to model theta 1\nClick 2 to model theta 2\n');
    ff = input('Click 1 to transform data into functions\nClick 2 not to do so\n');
    plot3(0,0,0)
    hold on
    sgtitle('Phace Space')
    xlabel('Theta')
    ylabel('Angular speed')
    zlabel('Angular aceleration')
    for i = 0:h:time
        t1_ = t1 + h*v1;
        t2_ = t2 + h*v2;
        a1 = (m2.*g.*sin(t2).*cos(t1-t2)-l1.*m2.*(v1.^2).*(sin(2.*t1-2.*t2)/2)-m2.*l2.*(v2.^2).*sin(t1-t2)-M.*g.*sin(t1))./(M.*l1-m2.*l1.*(cos(t1-t2).^2));
        v1 = v1 + h*a1;
        a2 = (l1.*(v1.^2).*sin(t1-t2)-g.*sin(t2)-l1.*a1.*cos(t1-t2))./l2;
        v2 = v2 + h*a2;
        t1 = t1_;
        t2 = t2_;
        data = cat(3,data,[t1 t2 v1 v2 a1 a2]);
        if whal_ == 1
            for j = 1:s
            plot3(t1(j),v1(j),a1(j),'.','MarkerSize',5,'Color',c(j,:))
            end
        elseif whal_ == 2
            for j = 1:s
            plot3(t2(j),v2(j),a2(j),'.','MarkerSize',5,'Color',c(j,:))
            end
        end
        hold on
        pause(0.01)
    end
    if ff == 1
        fun = {};
        data = permute(data,[3 2 1]);
        for k = 1:s
            for j = 1:3
                fun{end+1} = Ingenuity(data(:,2*j-1:2*j,k),time,time/h);
            end
        end
        ty = linspace(0,time,time/h);
        for u = 1:s
            fun1 = fun{3*u-2};
            fun2 = fun{3*u-1};
            fun3 = fun{3*u};
            if whal_ == 1
                fun1 = fun1{1};
                fun2 = fun2{1};
                fun3 = fun3{1};
            else
                fun1 = fun1{2};
                fun2 = fun2{2};
                fun3 = fun3{2};
            end
            plot3(fun1(ty),fun2(ty),fun3(ty),'-','MarkerSize',5,'Color',c(u,:))
        end
        functions = cell(1,length(fun)/3);
        for i = 1:length(fun)/3
            functions{i} = fun(3*i-2:3*i)';
        end
    end
end