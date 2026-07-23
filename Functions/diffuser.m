function [station0, station2] = diffuser(atm, Mach, pressureRecovery)
%DIFFUSER Calculate freestream total conditions and diffuser exit state.
%
% Inputs:
%   atm              Atmosphere structure
%   Mach             Flight Mach number
%   pressureRecovery Diffuser total-pressure recovery, Pt2/Pt0
%
% Outputs:
%   station0         Freestream static and total conditions
%   station2         Fan-inlet total conditions

validateattributes(Mach, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>=', 0});

validateattributes(pressureRecovery, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>', 0, '<=', 1});

gamma = atm.gamma;

% Isentropic conversion from static to stagnation conditions
temperatureRatio = 1 + ((gamma - 1) / 2) * Mach^2;

Tt0 = atm.temperature_K * temperatureRatio;

Pt0 = atm.pressure_Pa * ...
    temperatureRatio^(gamma / (gamma - 1));

V0 = Mach * atm.speed_of_sound_m_s;

% Freestream station
station0.T_K = atm.temperature_K;
station0.P_Pa = atm.pressure_Pa;
station0.Tt_K = Tt0;
station0.Pt_Pa = Pt0;
station0.Mach = Mach;
station0.velocity_m_s = V0;

% Diffuser exit / fan inlet
station2.Tt_K = Tt0;
station2.Pt_Pa = pressureRecovery * Pt0;
station2.pressure_recovery = pressureRecovery;

end