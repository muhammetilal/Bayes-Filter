clc
clear
clear all
syms n;
bel_open(1)=0.5;
bel_closed(1)=0.5;
for i=1:19;
    for j=1:2;
%%
if j==1
    state_1='open';
elseif j==2
    state_1='closed';
end
input_1='pull';

%% probabilities
if strcmp(input_1,'none')==1 && strcmp(state_1,'open')==1
 p_open(i,j) = 1;
 p_closed(i,j) = 0;
elseif strcmp(input_1,'none')==1 && strcmp(state_1,'closed')==1
 p_open(i,j) = 0;
 p_closed(i,j) = 1;
elseif strcmp(input_1,'pull')==1 && strcmp(state_1,'open')==1
 p_open(i,j) = 1;
 p_closed(i,j) = 0;
 elseif strcmp(input_1,'pull')==1 && strcmp(state_1,'closed')==1
 p_open(i,j) = 0.8;
 p_closed(i,j) = 0.2;
end
%for sense

    end
end

%% belief prediction
for i=1:19
bel_open(i+1) = p_open(i,1)*bel_open(i)+p_open(i,2)*bel_closed(i);
bel_closed(i+1)= p_closed(i,1)*bel_open(i)+p_closed(i,2)*bel_closed(i);
end

%% belief measurement
for i=1:20
    for j=1:2
if j==1
    state_1='open';
elseif j==2
    state_1='closed';
end
    %for sense
if  strcmp(state_1,'open')
sense_p_open(i,j)=0.6;
sense_p_closed(i,j)=0.4;
elseif  strcmp(state_1,'closed')
sense_p_open(i,j)=0.2;
sense_p_closed(i,j)=0.8;
end
    end
end
syms n
for i=1:20
 a = n*sense_p_open(i,1)*bel_open(i);
 b = n*sense_p_open(i,2)*bel_closed(i);
 eq = a+b==1;
 n_val(i) = double(solve(eq, n));
 bel_sense_open(i) = n_val(i)*sense_p_open(i,1)*bel_open(i);
 bel_sense_closed(i) = n_val(i)*sense_p_open(i,2)*bel_closed(i);
end


%% final belief
%for prediction belief
fprintf('Final prediction belief for open : %d \n',bel_open(20));
fprintf('Final prediction belief for closed: %d \n',bel_closed(20));
% %for measurement belief
fprintf('Final measurement belief for open: %d \n',bel_sense_open(20));
fprintf('Final measurement belief for closed: %d \n',bel_sense_closed(20));


%% ploting
figure
plot(bel_open,'MarkerSize',6,'LineWidth',2); hold on; plot(bel_closed,'MarkerSize',6,'LineWidth',2);
title('belief prediction(motion model)');
xlabel('iteration');
ylabel('p');
legend('open','closed');
figure
plot(bel_sense_open,'MarkerSize',6,'LineWidth',2); hold on; plot(bel_sense_closed,'MarkerSize',6,'LineWidth',2);
title('belief measurement(measurement model)');
xlabel('iteration');
ylabel('p');
legend('open','closed');
figure
plot(bel_open,'MarkerSize',6,'LineWidth',2); hold on; plot(bel_sense_open,'MarkerSize',6,'LineWidth',2);
title('prediction vs measurement for open state');
xlabel('iteration');
ylabel('p');
legend('prediction belief(open)','measurament belief(open)');
