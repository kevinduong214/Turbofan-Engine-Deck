function atm = atmosphere(altitude_m)
%ATMOSPHERE ISA troposphere model for altitudes from 0 to 11 km.

validateattributes(altitude_m, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>=', 0, '<=', 11000});

T_sl = 288.15;       % K
P_sl = 101325;       % Pa
lapse = -0.0065;     % K/m
g = 9.80665;         % m/s^2
R = 287.05;          % J/(kg*K)
gamma = 1.40;

T = T_sl + lapse * altitude_m;
P = P_sl * (T / T_sl)^(-g / (lapse * R));
rho = P / (R * T);
a = sqrt(gamma * R * T);

atm.temperature_K = T;
atm.pressure_Pa = P;
atm.density_kg_m3 = rho;
atm.speed_of_sound_m_s = a;
atm.gamma = gamma;
atm.R_J_kgK = R;

end