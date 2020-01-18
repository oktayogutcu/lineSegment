p = [2,3];
q = [8,9];
lambda = 0:0.01:1;
scatter(p(1,1),p(1,2),'*')
hold on
scatter(q(1,1),q(1,2),'*')
hold on
for i = 1:length(lambda)    
    y = lambda(i).*p + (1-lambda(i)).*q;
    scatter(y(1,1),y(1,2),'.')
    hold on
end
axis([-1 10 -1 10])



