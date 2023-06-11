% PSO Algorithms

% "psofunction2" in this code is a user-defined function calculating the vector fitness 

clear all
clc

D=8;     % Dimension of position vector (adjust with the problem of interest)
m=200;   % Magnitude of population
n=D;     % Dimension of search space
N=1000;  % Magnitude of evolution (iterations)
w=0.9;   % Inertial weighting factor
c1=2;    % Cognition coefficient
c2=2;    % Social coefficient

% Set position boundary (adjust with the problem of interest)
lob(1,1:D)=[0.045 1.8 -1.025 0.38 500 0.01 -1.5 50];
upb(1,1:D)=[2.155 4.4 0.523 0.845 2000 1 -0.01 1000];
span = upb-lob;

% Initiate velocity 
v=rand(m,n)*0.1.*span;

% Initiate position vector 
x=rand(m,n)*0.1.*span;

% Initiate the best position of an individual
pi=x;

for i=1:1:m
    y(i)=psofunction2(x(i,:),dmodel); % Calculate the fitness of an individual
end
yb=y(1);
for i=2:1:m
    if double(y(i))<double(yb) % Initiate the best position of the swarm
        yb=y(i);
        pg(1,:)=pi(i,:);
    end
end

for k=1:1:N
    for i=1:1:m
        v(i,:)=(0.9-(0.9-0.4)/N*k)*v(i,:)+c1*rand*(pi(i,:)-x(i,:))+c2*rand*(pg(1,:)-x(i,:));
        x(i,:)=x(i,:)+v(i,:)*((1-k/N*0.5));
        for jj=1:D
            if x(i,jj) > upb(jj)
                x(i,jj) = upb(jj);
            end
            if x(i,jj) < lob(jj)
                x(i,jj) = lob(jj);
            end
        end
    end
    for i=1:1:m
        if psofunction2(x(i,:),dmodel)<psofunction2(pi(i,:),dmodel) % Update the best position of an individual
            pi(i,:)=x(i,:);
        end
    end
    for i=1:1:m
        if psofunction2(pi(i,:),dmodel)<psofunction2(pg(1,:),dmodel) % Update the best position of the swarm
            pg(1,:)=pi(i,:);
        end
    end
    obj(k)=psofunction2(pg(1,:),dmodel);
    
    if obj(k)<10^-6
        break
    end
end