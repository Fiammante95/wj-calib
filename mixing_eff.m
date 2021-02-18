ra = 0.1;
phi = 0.4;

x = 0.85:0.00001:0.95;
y = x./(x-1)-log(1./(1-x));

x1 = x(5001);
y1 = y(5001);

x2 = x(9000);
y2 = y(9000);

b = log(y1/y2)/(x1-x2)
a = y1/exp(b*x1)

plot(x,y)

hold on

plot(x,a*exp(b*x))

%log((0.6647)*(1+0.1/0.4)^2/(1+0.1)^2)/0.9