function [EulerAngles] = quatMatrix2EulerMatrix(quatMatrix)

    N=max(size(quatMatrix(:,1)));   % liczba pomiarow
    Yaw=zeros(size(quatMatrix,1),1);
    Pitch=zeros(size(quatMatrix,1),1);
    Roll=zeros(size(quatMatrix,1),1);
    for i=1:N
        q0=quatMatrix(i,1);q1=quatMatrix(i,2);
        q2=quatMatrix(i,3);q3=quatMatrix(i,4);

        Yaw(i,1)=atan2d(2*(q0*q3+q1*q2),1-2*(q2*q2+q3*q3));
  
        Pitch(i,1)= asind(-2*(q1*q3 - q0*q2));
        Roll(i,1) = atan2d(2*(q2*q3 + q0*q1), ...
                     q0*q0 - q1*q1 - q2*q2 + q3*q3);  
             
    end         
    EulerAngles=[Yaw,Pitch,Roll];