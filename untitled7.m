clc
clear
syms n;
bel_opn(1)=0.5;
bel_clsd(1)=0.5;
ite = 20
state={'open','closed'};
inp={'open','pull'};
for x=1:(ite-1);
    for j=1:2;
if j==1
    door=1;
elseif j==2
    door=2;
end

input='pull';

 if strcmp(input,'none')==1 && door==1 % probability for none and open sensor ratio 
 p_open(x,j) = 1;
 p_closed(x,j) = 0;
elseif strcmp(input,'none')==1 && door==2
 p_open(x,j) = 0;
 p_closed(x,j) = 1;
elseif strcmp(input,'pull')==1 && door==1
 p_open(x,j) = 1;
 p_closed(x,j) = 0;
 elseif strcmp(input,'pull')==1 && door==2
 p_open(x,j) = 0.8;
 p_closed(x,j) = 0.2;
 end
    end
    bel_opn(x+1) = p_open(x,1)*bel_opn(x)+p_open(x,2)*bel_clsd(x);
bel_clsd(x+1)= p_closed(x,1)*bel_opn(x)+p_closed(x,2)*bel_clsd(x);
end





for i=1:ite
    for l=1:2
if l==1
    door=1;
elseif l==2
    door=2;
end  
if  door==1 % belief measurement
p_open_sense(i,l)=0.6;
p_closed_sens(i,l)=0.4;
elseif  door==2
p_open_sense(i,l)=0.2;
p_closed_sens(i,l)=0.8;
end
    end
    syms n     
 x = n*p_open_sense(i,1)*bel_opn(i);
 y = n*p_open_sense(i,2)*bel_clsd(i);
 eq = x+y==1;
 n_value(i) = solve(eq, n);
 opensens(i) = n_value(i)*p_open_sense(i,1)*bel_opn(i);
 closedsens(i) = n_value(i)*p_open_sense(i,2)*bel_clsd(i);
    end
figure

plot(bel_opn,"r"); hold on; plot(bel_clsd,"b");
title('bel predic');
xlabel('iteration');
ylabel('prediction');
figure
plot(opensens,"r"); hold on; plot(closedsens,"b");
title('bel sense measurement');
xlabel('iteration');
ylabel('prediction');