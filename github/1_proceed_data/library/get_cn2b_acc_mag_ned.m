
function cn2b=get_cn2b_acc_mag_ned(acc, mag)

%https://github.com/Aceinna/gnss-ins-sim/blob/master/gnss_ins_sim/attitude/attitude.py
% function to get orienation from acc and mag
%def get_cn2b_acc_mag_ned(acc, mag):
%     '''
%     Calculate NED to body transformation matrix from acc and mag.
%     Args:
%         acc: acc measurement, numpy array of 3x1.
%         mag: mag measurement, numpy array of 3x1.
%     Returns:
%         cn2b: transformation matrix from NED to body
%     '''
    z = -acc / sqrt(dot(acc, acc));
    acc_cross_mag = cross(z, mag);
    y = acc_cross_mag / sqrt(dot(acc_cross_mag, acc_cross_mag));
    x = cross(y, z);
    cn2b = zeros([3, 3]);
    cn2b(1,1) = x(1);
    cn2b(2,1) = x(2);
    cn2b(3,1) = x(3);
    cn2b(1,2) = y(1);
    cn2b(2,2) = y(2);
    cn2b(3,2) = y(3);
    cn2b(1,3) = z(1);
    cn2b(2,3) = z(2);
    cn2b(3,3) = z(3);
% return cn2b