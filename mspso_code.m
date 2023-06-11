% MSPSO Algorithm

% "psofunction2" in this code is a user-defined function calculating the vector fitness 

clear all
clc

D=8;        % Dimension of position vector (adjust with the problem of interest)
N=200;      % Magnitude of population
M=1000;     % Magnitude of evolution (iterations)
alpha=0.8;  % Parameter controlling alternative distance 
beta=2;     % Parameter controlling alternative fitness 
w=0.9;      % Inertial weighting factor
c1=2;       % Cognition coefficient
c2=2;       % Social coefficient

% Set position boundary (adjust with the problem of interest)
lob(1,1:D)=[0.045 1.8 -1.025 0.38 500 0.01 -1.5 50];
upb(1,1:D)=[2.155 4.4 0.523 0.845 2000 1 -0.01 1000];
dis=upb-lob;   % Boundary distance

for ite=1:6
    
    % Initiate population
    x=rand(N,D).*repmat(dis,[N,1])+repmat(lob,[N,1]);
    
    % Initiate velocity 
    v=rand(N,D).*repmat(dis,[N,1])*0.1;
    
    % Initiate the best position of an individual
    pb=x;
    for i=1:N
        pb_f(i)=psofunction2(x(i,:),dmodel);
    end
    
    for kk=1:M
        
        % Calculate the fitness of an individual
        for i=1:N
            fit_x(i)=psofunction2(x(i,:),dmodel);
        end
        
        % Update the best position of an individual
        for i=1:N
            if fit_x(i)<pb_f(i)
                pb(i,:)=x(i,:);
                pb_f(i)=fit_x(i);
            end
        end
        
        % Rank individuals based on their fitness
        [fit_1,index] = sort(fit_x);
        [aa bb]=size(x);
        
        for i=1:bb
            x_1(:,i)=x(index+aa*(i-1));
        end
        for i=1:bb
            pb(:,i)=pb(index+aa*(i-1));
        end
        pb_f=pb_f(index);
        for i=1:bb
            v(:,i)=v(index+aa*(i-1));
        end
        
        x_2(1,:) = x_1(1,:);
        for i=2:N
            [aa bb]=size(x_2);
            for j=1:aa
                DD1(j)=norm((x_2(j,:)-x_1(i,:))./dis);
            end
            
            if DD1 > alpha
                if psofunction2(x_1(i,:),dmodel)/psofunction2(x_2(1,:),dmodel) < beta
                    x_2(aa+1,:) = x_1(i,:);
                end
            end
            clear DD1
        end
        
        % Calculate distances between individuals with the alternative
        [aa bb]=size(x_2);
        for i=1:N
            for j=1:aa
                dd1(i,j)=norm(x_1(i,:)-x_2(j,:));
            end
        end
        
        % Update the velocity vector
        for i=1:N
            [a1a,b1b]=min(dd1(i,:));
            v(i,:)=w*v(i,:)+c1*rand*(x_2(b1b,:)-x_1(i,:))+c2*rand*(pb(i,:)-x_1(i,:));
        end
        
        % Update the position vector
        for i=1:N
            x_1(i,:)=x_1(i,:)+v(i,:);
        end
        % Control the individual position (within the boundary)
        for i=1:1:N
            for j=1:1:D
                if x_1(i,j)>upb(j)
                    x_1(i,j)=upb(j);
                elseif x_1(i,j)<lob(j)
                    x_1(i,j)=lob(j);
                end
            end
        end
        
        x=x_1;
        % Record results
        x_record(kk,1:N,1:D)=x;
        x_1record(kk,1:N,1:D)=x_1;
        x_2record(kk,1:aa,1:D)=x_2;
        
        if kk == M
            [aa bb]=size(x_2);
            x_2_num(ite)=aa;
            break
        end
        
        clear x_1
        clear x_2
        clear dd1
        
    end
    ite
    [x2_a x2_b]=size(x_2);
    x2_ite_num(ite) = x2_a;
    fin_x_2record(ite,1:aa,:)=x_2;
    
end