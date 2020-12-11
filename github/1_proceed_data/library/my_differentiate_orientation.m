function [AV] = my_differentiate_orientation(quat,time)
    %https://github.com/memsindustrygroup/TSim/blob/master/tool/AttitudeTrajectory.m
    %based method
    % in comparision to original file this one cen use non Nonuniform_sampling 
    % additionally, the result is presented in a senosor-related reference system
    
    % STEP 1
    N=length(quat);
    dq=zeros(size(quat,1)-1,4);
    dT=diff(time);
    for i=1:N-1
        dq(i,:)=(quat(i+1,:)-quat(i,:))/(dT(i));
    end
    dq(N,:) = (quat(N,:)-quat(N-1,:))/dT(end);
    
    % STEP 2
    for i=1:N
        R = quaternion_rates( quat(i,:)', dq(i,:)' );
        newquat(i,:) = R';
    end
    
    AV=zeros(N,3);
    
    %data rotation 
    for i=1:N
        q=quat(i,:);
        qinv=[q(1),-q(2),-q(3),-q(4)];
        Q=quatmultiply(quatmultiply(qinv,[0,newquat(i,:)]),q);
        AV(i,1:3)=Q(2:end);
    end


end