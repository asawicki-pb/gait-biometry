function [quat_accel]=calcQuatFromAcceleration(accel_x, accel_y,accel_z)
    accel=[accel_x,accel_y,accel_z];
    accel_normalized=zeros(length(accel),3);
    quat_accel=zeros(length(accel),4);
    grav=[0,0,1];
    for i=1:length(accel)
        %fprintf('%d /%d\n',i,length(accel))
        n=norm(accel(i,:));
        accel_normalized(i,1:3)=accel(i,:)/n;
        alpha=acosd(dot(grav,accel_normalized(i,:)));
        c=cross(grav,accel_normalized(i,:));
        c=c/sind(alpha);
        quat_accel(i,1:4)=[cosd(alpha/2),sind(alpha/2)*c];
    end
% return quat_accel