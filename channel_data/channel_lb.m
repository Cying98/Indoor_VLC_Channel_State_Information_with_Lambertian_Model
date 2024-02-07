led_loc=[1 1 4 4 2 2 3 3 1 1 2 2 3 3 4 4 0.2 0.2 0.2 0.2 1   2   3   4   4.8 4.8 4.8 4.8 4   3   2   1;
         1 4 1 4 2 3 2 3 2 3 1 4 1 4 2 3 1   2   3   4   0.2 0.2 0.2 0.2 1   2   3   4   4.8 4.8 4.8 4.8;
         3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3   3   3   3   3   3   3   3   3   3   3   3   3   3   3   3   ];
users_loc=[1.5  3.5  1.5  3.5  2.5  2.5  2.5  2.5  1.5  1.7  3.2  4.5  2.2  2.4  2.2  3.4;
           1.5  3.5  3.5  1.5  2.5  0.5  1.5  3.5  3.8  3.4  4    4.8  2.8  3.8  4.2  4.2;
           0.85 0.85 0.85 0.85 0.85 0.85 0.85 0.85 0.85 0.85 0.85 0.85 0.85 0.85 0.85 0.85];

N_T=size(led_loc,2);    % led数
N_R=size(users_loc,2);  % 用户数

d_users=zeros(N_R,N_T); % 用户与LED的距离
H_users=zeros(N_R,N_T); % 用户与LED的CSI
delta_h=3-0.85;

for i=1:N_R
    for j=1:N_T
        d_users(i,j)=sqrt(sum((led_loc(:,j)-users_loc(:,i)).^2));
    end
end

A_pd=1e-4;                          % PD的面积
phi_t_users=acos(delta_h./d_users); % 相对于发射机轴的发射角
phi_r_users=phi_t_users;            % 相对于接收机轴的入射角
phi_c=pi/3;                         % PD的视场
Ts=1;                               % 光学滤镜增益
w=1;                                % 折射率
g=w^2/(sin(phi_c))^2;               % 光集中器的增益

for i=1:N_R
    for j=1:N_T
        if phi_r_users(i,j)>phi_c
            H_users(i,j)=0;
        else
%             m=1;                    % 朗伯辐射阶数
            m=-log(2)/log(cos(pi/3));
            R0=(m+1)/2/pi*(cos(phi_r_users(i,j)))^m; % 郎伯辐射强度
            H_users(i,j)=A_pd*R0*Ts*g*cos(phi_r_users(i,j))/d_users(i,j)^2;
        end
    end
end

eve_loc=[1.35,1.32,0.85]';
N_E=1;                  % 窃听者
d_eve=zeros(1,N_T);     % 窃听与LED的距离
H_eve=zeros(1,N_T);     % 窃听与LED的CSI

for i=1:N_T
    d_eve(1,i)=sqrt(sum((led_loc(:,i)-eve_loc).^2));
end
phi_t_eve=acos(delta_h./d_eve); % 相对于发射机轴的发射角
phi_r_eve=phi_t_eve;            % 相对于接收机轴的入射角

for j=1:N_T
    if phi_r_eve(1,j)>phi_c
        H_eve(1,j)=0;
    else
%         m=1;                    % 朗伯辐射阶数
        R0=(m+1)/2/pi*(cos(phi_r_eve(1,j)))^m; % 郎伯辐射强度
        H_eve(1,j)=A_pd*R0*Ts*g*cos(phi_r_eve(1,j))/d_eve(1,j)^2;
    end
end