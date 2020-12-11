function [PROCEED,timestamp] =  extractData(filename)
    ORIGIN= readtable(filename); 
    N=size(ORIGIN,1);
    load('filters.mat')
    % MAG
    m=[ORIGIN.mag_x,ORIGIN.mag_y,ORIGIN.mag_z];
    %% ACCEL
    a=[ORIGIN.accel_x,ORIGIN.accel_y,ORIGIN.accel_z];

    ax_LP10 = filter(b_10,a_10,ORIGIN.accel_x);
    ay_LP10 = filter(b_10,a_10,ORIGIN.accel_y);
    az_LP10 = filter(b_10,a_10,ORIGIN.accel_z);
    a_LP10=[ax_LP10,ay_LP10,az_LP10];

    %% Quat
    quat_a=calcQuatFromAcceleration(a(:,1),a(:,2),a(:,3));
    quat_a_LP10=calcQuatFromAcceleration(ax_LP10,ay_LP10,az_LP10);

    % quat from ANDROID Euler Angles

    quat_ANDOIRD=zeros([N,4]);
    for i=1:N
        qyaw=[cos(ORIGIN.azimuth(i)/2),0 ,0 ,sin(ORIGIN.azimuth(i)/2)];
        qpitch=[cos(ORIGIN.pitch(i)/2),0,sin(ORIGIN.pitch(i)/2),0];    
        qroll=[cos(ORIGIN.roll(i)/2),sin(ORIGIN.roll(i)/2),0 ,0 ];
        quat_ANDOIRD(i,1:4)=quatmultiply(quatmultiply(qyaw,qpitch),qroll);
    end
    
%     show_orientation_ANDROID(quat_ANDOIRD)
    
    
    % quat from Accel and Mag (Aceinna)
    N=size(ORIGIN,1);
    quat_ACEINNA=zeros([N,4]);
    for i=1:N
        dcm=get_cn2b_acc_mag_ned([a(i,1),a(i,2),a(i,3)],[m(i,1),m(i,2),m(i,3)]);
        quat_ACEINNA(i,1:4)=dcm2quat(dcm);
    end
    %% ACCEL estimation
    a_ANDROID=zeros([N,3]);
    for i=1:N
        q=quat_ANDOIRD(i,:);       %quaternion w danym kroku
        R=quat2dcm(q)';
        a_ANDROID(i,1:3)=R*[0;0;1];
    end

    a_ACEINNA=zeros([N,3]);
    for i=1:N
        q=quat_ACEINNA(i,:);       %quaternion w danym kroku
        R=quat2dcm(q)';
        a_ACEINNA(i,1:3)=R*[0;0;1];
    end
    %% EULER
    %%Quat to Euler
    Euler_a=quatMatrix2EulerMatrix(quat_a);
    Euler_a_LP10=quatMatrix2EulerMatrix(quat_a_LP10);
    Euler_ANDROID=quatMatrix2EulerMatrix(quat_ANDOIRD);
    Euler_ACEINNA=quatMatrix2EulerMatrix(quat_ACEINNA);
    %% GYRO ESTIMATION
    Gyro_a=rad2deg(my_differentiate_orientation(quat_a, ORIGIN.timestamp/1000));
    Gyro_a_LP10=rad2deg(my_differentiate_orientation(quat_a, ORIGIN.timestamp/1000));
    Gyro_ANDROID=rad2deg(my_differentiate_orientation(quat_ANDOIRD, ORIGIN.timestamp/1000));
    Gyro_ACEINNA=rad2deg(my_differentiate_orientation(quat_ACEINNA, ORIGIN.timestamp/1000));

    % Euler_oigin=[rad2deg(data.azimuth),rad2deg(data.pitch),rad2deg(data.roll)];
    % show_orientation_ANDROID(quat_ACEINNA)
    %% CREATE TABLE
    Z=zeros([N,3]);
    PROCEED=table(a,a_LP10,a_ANDROID,a_ACEINNA,Z,Euler_a,Euler_a_LP10,Euler_ANDROID,Euler_ACEINNA,Z,Gyro_a,Gyro_a_LP10,Gyro_ANDROID,Gyro_ACEINNA,Z,m);
%     0,1,2 3,4,5 6,7,8 9,10,11 
%     a,a_LP10,a_ANDROID,a_ACEINNA,
%     12,13,14
%     Z,
%     15,16,17 18,19,20 21,22,23 24 25 26
%     Euler_a,Euler_a_LP10,Euler_ANDROID,Euler_ACEINNA,
%     27 28 29
%     Z,
%     30,31,32 33,34,35 36,37,38 39,40,41,
%     Gyro_a,Gyro_a_LP10,Gyro_ANDROID,Gyro_ACEINNA,
%     42,43,44
%     Z,
%     45,46,47
%     m
%     dat=data[250:-250,(3,4,5,12,12,12,33,34,35,12,12,12,45,46,47,12,12,12,15,16,17)] #z zerami
%     df=pd.DataFrame(dat, columns=pd.Index(('ax','ay','az','z','z','z','gx','gy','gz','z','z','z','mx','my','mz','z','z','z','Yaw','Pitch','Roll')))
    timestamp=(ORIGIN.timestamp-ORIGIN.timestamp(1))/1000;
    
end