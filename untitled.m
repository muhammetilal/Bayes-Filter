
%% motion model %
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


%% measurement model
%creating measurement model
meas_mod_rel= [0.11 0.11 0.11; 0.11 0.12 0.11; 0.11 0.11 0.11]; %probobality matrix
% p(y_t | x_t)
meas_mod = zeros(N,N);
% fill in non-boundary measurements
for i=2:n-1
    for j=2:n-1
        cur = i+(j-1)*n;
        meas_mod(cur-n+[-1:1:1],curl)

