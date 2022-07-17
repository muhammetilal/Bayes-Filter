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