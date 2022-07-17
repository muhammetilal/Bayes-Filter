clear all; close all;clc
syms nu; iteration = 20;
%% generating none & pull inputs & states of the system with n iteration
for i = 1:iteration
 u{i} = sprintf("none");%input can be "none" or "pull" 1x20
end
user_state = {"open","closed"};%two states possible "open" or "closed"
%% setting up the relation between belief and belief_bar
bel_open(1) = 0.5; bel_closed(1) = 0.5;%initial beliefs

for i = 1:length(u)
 for j = 1:length(user_state)
 [p_open(i,j),p_closed(i,j),ps_open(i,j),ps_closed(i,j)] = robot(u{i},user_state{j});
 end
 %predicton updates comes in
 bel_bar_open(i) = p_open(i,1)*bel_open(i)+p_open(i,2)*bel_closed(i);
 bel_bar_closed(i)= p_closed(i,1)*bel_open(i)+p_closed(i,2)*bel_closed(i);
 %below nu calculation is done using symbolic toolbox
 e1 = nu*ps_open(i,1)*bel_bar_open(i);
 e2 = nu*ps_open(i,2)*bel_bar_closed(i);
 e3 = e1+e2 == 1;%possibilities add up to 1
 nu_value(i) = double(solve(e3, nu));
 %measurement updates comete 
 bel_open(i+1) = nu_value(i)*ps_open(i,1)*bel_bar_open(i);
 bel_closed(i+1) = nu_value(i)*ps_open(i,2)*bel_bar_closed(i);
end


%% showing u, belief & belief_bar in a table
for i = 1:iteration
 input(i,1) = sprintf("none(%g)",i-1); % input none or pull
 belief(i+1,1) = sprintf("bel(%g)",i);
 belief(1) = "bel(0)";
end
%% printing final belief open/closed values
fprintf(1,"<strong>Final belief of the being open: </strong>")
fprintf(2,"<strong>%d</strong>\n", bel_open(end))
fprintf(1,"<strong>Final belief of the being closed: </strong>")
fprintf(2,"<strong>%d</strong>\n", bel_closed(end))
%% plotting beliefs open/closed
subplot 211
plot(1:iteration+1,belief_open,'k','linewidth',1.5); hold on
plot(1:iteration+1,belief_closed,'r','linewidth',1.5);
title('bel PLOT WITH RESPECT TO ITERATIONS','Interpreter','Latex');
ylabel('belief of case (0-1)','Interpreter','Latex');
xlabel('iterations(n=20)','Interpreter','Latex')
legend('bel(open)','bel(closed)','Interpreter','Latex')
subplot 212
plot(1:iteration,belief_bar_open,'b','linewidth',1.5); hold on
plot(1:iteration,belief_bar_closed,'g','linewidth',1.5);
title('$\bar{bel}$ PLOT WITH RESPECT TO ITERATIONS','Interpreter','Latex');
ylabel('$\bar{bel}$ of case (0-1)','Interpreter','Latex');
xlabel('iterations(n=20)','Interpreter','Latex')
legend('$\bar{bel}$(open)','$\bar{bel}$(closed)','Interpreter','Latex')
% The function that provides the possibility of being&sensing open/closed
function [p_open,p_closed,ps_open,ps_closed] = robot(in,sta)
input = {"none", "pull"};
state = {"open","closed"};
if sta == state{1}
 ps_open = .6;
 ps_closed = .4;
elseif sta == state{2}
 ps_open = .2;
 ps_closed = .8;
end
if in == input{1} && sta == state{1}
 p_open = 1;
 p_closed = 0;
elseif in == input{1} && sta == state{2}
 p_open = 0;
 p_closed = 1;
elseif in == input{2} && sta == state{1}
 p_open = 1;
 p_closed = 0;
elseif in == input{2} && sta == state{2}
 p_open = 0.8;
 p_closed = 0.2;
end
end