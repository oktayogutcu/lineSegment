%lines
tic
clear all
close all
q = 0;
distances = [];
lines = [4,1,3,5;
         6,3,7,7;
         7,2,10,3;
         13,2,18,6;
         14,8,16,9];
lambda = 0:0.01:1;
d2=[0,0;1,0];
d1=[0,0;0,0];
start = [8,10];
figure
scatter(start(1),start(2),75,'rx','LineWidth',2)
hold on
for i =1:size(lines,1)
line = lines(i,:);
point1 = [line(1) line(2)];
point2 = [line(3) line(4)];
plot([point1(1,1);point2(1,1)],[point1(1,2);point2(1,2)],'c','linewidth',3)
hold on
scatter(point1(1),point1(2),'yellow','filled');
hold on
scatter(point2(1),point2(2),'yellow','filled');
hold on
lambda = rand;
u(i,:) = lambda.*point1 + (1-lambda).*point2;

scatter(u(i,1),u(i,2),75,'rx','LineWidth',2)
hold on
end
axis([-1 20 -1 15])

syms x
syms y
iteration = 8;

for p = 1:iteration
    if p >=2
        u = newU;
    end
    
    for i = 1:size(lines,1)
    if i == 1
    dots1 = [start u(i,:)];
    else
    dots1 = [u(i-1,:) u(i,:)];    
    end

    point1 = [dots1(1) dots1(2)];
    point2 = [dots1(3) dots1(4)];
    plot([point1(1,1);point2(1,1)],[point1(1,2);point2(1,2)],'m--')
    hold on


    % lambda = rand;
    % omg1 =lambda.*point1 + (1-lambda).*point2;
    lambda = rand;
    omg1 = lambda.*point1 + (1-lambda).*point2;
        if i>1 
            d1 = pdist([point1(1),point1(2);omg1(1),omg1(2)]);
            d2 = pdist([point1(1),point1(2);omgP(i-1,1),omgP(i-1,2)]);
            while (d1 < d2)
                lambda = rand;
                omg1 = lambda.*point1 + (1-lambda).*point2;
                d1 = pdist([point1(1),point1(2);omg1(1),omg1(2)]);
            end        
        end

    omg(i,:) = omg1;

    if i ~= size(lines,1)
        dots2 = [u(i,:) u(i+1,:)];
    else
        dots2 = [u(i,:) start];
    end

    point1 = [dots2(1) dots2(2)];
    point2 = [dots2(3) dots2(4)];
    plot([point1(1,1);point2(1,1)],[point1(1,2);point2(1,2)],'m--')
    if(p == iteration)
     plot([point1(1,1);point2(1,1)],[point1(1,2);point2(1,2)],'b-','LineWidth',3)   
    end
    hold on
    lambda = rand;
    omg2 = lambda.*point1 + (1-lambda).*point2;
    omgP(i,:) = omg2;

    scatter(omg(i,1),omg(i,2),'bo')
    hold on

    scatter(omgP(i,1),omgP(i,2),'r*')
    hold on

    x1 = omg(i,1);
    y1 = omg(i,2);

    x2 = omgP(i,1);
    y2 = omgP(i,2);

    x3 = lines(i,1);
    y3 = lines(i,2);

    x4 = lines(i,3);
    y4 = lines(i,4);

    % eqn1 = y == ((y2-y1)/(x2-x1))*(x-x1) + y1;
    % eqn2 = y == ((y4-y3)/(x4-x3))*(x-x3) + y3;



    eqn = ((y4-y3)/(x4-x3))*(x-x3) + y3 == ((y2-y1)/(x2-x1))*(x-x1) + y1;
    solx = solve(eqn,x);
    solx = double(solx);
    eqn2 = y == ((y4-y3)/(x4-x3))*(solx-x3) + y3;
    soly = solve(eqn2,y);
    soly = double(soly);
    
    usty = y2;
    alty = y1;
    if(y1>y2)
        usty = y1;
        alty = y2;
    end
    ustx = x2;
    altx = x1;
    if(x1>x2)
        ustx = x1;
        altx = x2;
    end
    control = 0;
    if(~(((ustx>solx && altx<solx) && (usty>soly && alty<soly))))
       control = control +1; 
    end
    
    usty = y4;
    alty = y3;
    if(y3>y4)
        usty = y3;
        alty = y4;
    end
    ustx = x4;
    altx = x3;
    if(x3>x4)
        ustx = x3;
        altx = x4;
    end
    if(~(((ustx>solx && altx<solx) && (usty>soly && alty<soly))))
       control = control +1; 
    end

    if(control ==1 || control ==2)
        firstW = pdist([x3,y3;omg(i,1),omg(i,2)]);
        firstWp = pdist([x3,y3;omgP(i,1),omgP(i,2)]);
        secW = pdist([x4,y4;omg(i,1),omg(i,2)]);
        secWp = pdist([x4,y4;omgP(i,1),omgP(i,2)]);

        solx = x3;
        soly = y3;

        if((firstW+firstWp)>=(secW+secWp))
            solx = x4;
            soly = y4;
        end
%         scatter(10+q,10,500,'red','x') 
%         hold on
%         q = q+5;
    end

    scatter(solx,soly,50,'black','+')
    hold on

    newU(i,1) = solx;
    newU(i,2) = soly;

    end
    axis([-1 20 -1 15])
    dist = 0;
    for k = 1:size(lines,1)-1
    dist =dist + pdist([newU(k,1),newU(k,2);newU(k+1,1),newU(k+1,2)]);
    end
    distances = [distances dist];
end
toc