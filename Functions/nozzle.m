function outlet = nozzle( ...
    inlet, mdot, ambientPressure_Pa, pressureRecovery, gamma, R)
%NOZZLE Analyze a convergent exhaust nozzle.
%
% The nozzle model:
%   1. Applies a specified total-pressure recovery.
%   2. Checks whether the convergent nozzle is choked.
%   3. Calculates exit Mach number and static conditions.
%   4. Calculates exit area and pressure thrust.
%
% Inputs:
%   inlet               Structure containing Tt_K and Pt_Pa
%   mdot                Nozzle mass flow, kg/s
%   ambientPressure_Pa  Ambient static pressure, Pa
%   pressureRecovery    Nozzle total-pressure recovery
%   gamma               Specific heat ratio
%   R                   Specific gas constant, J/(kg*K)
%
% Output:
%   outlet              Nozzle exit state and performance

validateattributes(mdot, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'positive'});

validateattributes(ambientPressure_Pa, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'positive'});

validateattributes(pressureRecovery, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>', 0, '<=', 1});

%% Available nozzle total conditions
TtAvailable_K = inlet.Tt_K;
PtAvailable_Pa = pressureRecovery * inlet.Pt_Pa;

if PtAvailable_Pa <= ambientPressure_Pa
    error("Nozzle total pressure must exceed ambient pressure.");
end

%% Critical pressure ratio for choking
criticalNPR = ...
    ((gamma + 1) / 2)^(gamma / (gamma - 1));

nozzlePressureRatio = ...
    PtAvailable_Pa / ambientPressure_Pa;

isChoked = nozzlePressureRatio >= criticalNPR;

%% Exit state
if isChoked
    exitMach = 1.0;

    exitPressure_Pa = ...
        PtAvailable_Pa / criticalNPR;
else
    exitPressure_Pa = ambientPressure_Pa;

    exitMach = sqrt( ...
        (2 / (gamma - 1)) * ...
        (nozzlePressureRatio^((gamma - 1) / gamma) - 1));
end

exitTemperature_K = ...
    TtAvailable_K / ...
    (1 + ((gamma - 1) / 2) * exitMach^2);

exitSpeedOfSound_m_s = ...
    sqrt(gamma * R * exitTemperature_K);

exitVelocity_m_s = ...
    exitMach * exitSpeedOfSound_m_s;

exitDensity_kg_m3 = ...
    exitPressure_Pa / (R * exitTemperature_K);

exitArea_m2 = ...
    mdot / (exitDensity_kg_m3 * exitVelocity_m_s);

pressureThrust_N = ...
    (exitPressure_Pa - ambientPressure_Pa) * exitArea_m2;

%% Store results
outlet.Tt_K = TtAvailable_K;
outlet.Pt_Pa = PtAvailable_Pa;

outlet.T_K = exitTemperature_K;
outlet.P_Pa = exitPressure_Pa;
outlet.Mach = exitMach;
outlet.velocity_m_s = exitVelocity_m_s;
outlet.density_kg_m3 = exitDensity_kg_m3;
outlet.area_m2 = exitArea_m2;

outlet.mdot_kg_s = mdot;
outlet.pressure_thrust_N = pressureThrust_N;

outlet.nozzle_pressure_ratio = nozzlePressureRatio;
outlet.critical_nozzle_pressure_ratio = criticalNPR;
outlet.pressure_recovery = pressureRecovery;
outlet.is_choked = isChoked;

end