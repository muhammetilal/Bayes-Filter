clc;clear;clear all;
%% crearting AVI object
makemovie = 0;
if (makemovie)
    vidObj=VideoWriter('bayes.avi');
    vidObj.Quality = 100;
    vidObj.FrameRate = 3;
    open(vidObj);
end

%% sim parameters
T=20; %simulation length
n=10; % grid size
N=n^2; % state size
x=zeros(N,T+1); % state vector
pos=[5 5]; % initial position
x(pos(1)+n*(pos(2)-1)) = 1;
u=zeros(1,T); % input vector
y=zeros(N,T); % measurement vector

%% motion model
mot_mod=zeros(N,N,4);
for i=1:n %row
    for j=1:n %column
        cur = i + (j-1)*n; %current index
% move up
if j>1
    mot_mod(cur-n,cur,1) = 0.6; %60 can go  %it changes the index
    mot_mod(cur,cur,1) = 0.4; %40 can not go, it will stay

else
    mot_mod(cur,cur,1) = 1;
end
%move right
if (i<n)
        mot_mod(cur+1,cur,2) = 0.6;
            mot_mod(cur,cur,2) = 0.4;
else
     mot_mod(cur,cur,2) = 1;
end
%move down
if (j<n)
        mot_mod(cur+n,cur,3) = 0.6;
            mot_mod(cur,cur,3) = 0.4;
else
     mot_mod(cur,cur,3) = 1;
end
%move left
if (i>1)
        mot_mod(cur-1,cur,4) = 0.6;
            mot_mod(cur,cur,4) = 0.4;
else
     mot_mod(cur,cur,4) = 1;
end
    end
end

%%  measurement model
%creating measurement model
meas_mod_rel= [0.11 0.11 0.11; 0.11 0.12 0.11; 0.11 0.11 0.11]; %probobality matrix
% p(y_t | x_t)
meas_mod = zeros(N,N);
% fill in non-boundary measurements
for i=2:n-1
    for j=2:n-1
        cur = i+(j-1)*n;
        meas_mod(cur-n+[-1:1:1],cur) = meas_mod_rel(1,:);
        meas_mod(cur+[-1:1:1],cur) = meas_mod_rel(2,:);
        meas_mod(cur+n+[-1:1:1],cur) = meas_mod_rel(3,:);
    end
end

%% fill in boundaries by dropping impossible measurements
scale = 1-sum(meas_mod_rel(1,:));
for i=2:n-1
    %top
    cur=i;
    meas_mod(cur+[-1:1:1],cur) = meas_mod_rel(2,:)/scale;
    meas_mod(cur+n+[-1:1:1],cur) = meas_mod_rel(3,:)/scale;
    %right
    cur=i*n;
    meas_mod(cur-1+n*[-1:1:1],cur) = meas_mod_rel(:,1)/scale;
    meas_mod(cur+n*[-1:1:1],cur) = meas_mod_rel(:,2)/scale;
    %bottom
    cur= (n-1)*n+i;
    meas_mod(cur-n+[-1:1:1],cur) = meas_mod_rel(1,:)/scale;
    meas_mod(cur+[-1:1:1],cur) = meas_mod_rel(2,:)/scale;
    %left
    cur= (i-1)*n+1;
    meas_mod(cur+n*[-1:1:1],cur) = meas_mod_rel(:,2)/scale;
    meas_mod(cur+1+n*[-1:1:1],cur) = meas_mod_rel(:,3)/scale;
end

%fill in corners, assume fixed
meas_mod([1 2 n+1 n+2],1) = 0.25;
meas_mod([n-1 n 2*n-1 2*n], n) = 0.25;
meas_mod([n*(n-2)+1 n*(n-2)+2 n*(n-1)+1 n*(n-1)+2], n*(n-1)+1) = 0.25;
meas_mod([n*(n-1)-1 n*(n-1) n*(n-1) n*n],n*n) = 0.25;

%%  initial belief for vehicle states
%0=no obstacle, 1= obstacle
bel = 1/N^2*ones(N,1);
belp=bel;
figure;clf;hold on;
beliefs = reshape(bel,n,n);
imagesc(beliefs);
plot(pos(2),pos(1),'ro','MarkerSize',6,'LineWidth',2);
colormap(summer);
title('Ture state and beliefs')

%% MAIN LOOP
for t=1:T
   %% simulation
   %select motion input
   u(t)=ceil(4*rand(1));
   thresh=rand(1);
   new_x = find(cumsum(squeeze(mot_mod(:,:,u(t)))*x(:,t))> thresh,1);
   %move vehicle
   x(new_x,t+1) = 1;
   %take measurement
   thresh= rand(1);
   new_y = find(cumsum(meas_mod(:,:)*x(:,t+1))>thresh,1);
   y(new_y,t) = 1;
   %store for ploting
   curx = reshape(x(:,t+1)',n,n);
   [xi,xj]=find(curx>0);
   xp(:,t) = [xi;xj];
   cury = reshape(y(:,t)',n,n);
   [yi ,yj] = find(cury>0);
   yp(:,t)= [yi ; yj];
   xt(t)=new_x;
   yt(t)= new_y;
   %% bayesian estimation
   %prediction update
   belp= squeeze(mot_mod(:,:,u(t)))*bel;
   %measurement update
   bel=meas_mod(new_y,:)'.*belp;
   bel=bel/norm(bel); % to normalize

   [pmax y_bel(t)]=max(bel);

  %% plot beliefs
  beliefs = reshape(bel,n,n);
  imagesc(beliefs);
  plot(xj,xi,'ro','MarkerSize',6,'LineWidth',2);
  plot(yj,yi,'ro','MarkerSize',4,'LineWidth',1);
  colormap(summer);
  title('True states and beliefs');
  if (makemovie) writeVideo(vidObj, getframe(gca));
  end
end

if (makemovie) close (vidObj);
end
figure;clf;hold on;
plot(xt);
plot(yt,'r--');
plot(y_bel, 'g:');
title('State, measurament and max belief');
xlabel('time');
ylabel('location');
