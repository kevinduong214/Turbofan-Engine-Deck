function atm = atmosphere( ...
    altitude_m, ...
    temperatureOverride_K, ...
    pressureOverride_Pa)
%ATMOSPHERE ISA troposphere model with optional ambient overrides.
%
% Usage:
%   atm = atmosphere(altitude_m)
%   atm = atmosphere(altitude_m, temperatureOverride_K, pressureOverride_Pa)
%
% Pass NaN or [] for either override to retain the ISA value for that
% property. The override capability supports public test-cell conditions
% without changing the altitude metadata.

validateattributes(altitude_m, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>=', 0, '<=', 11000});

if nargin < 2 || isempty(temperatureOverride_K)
    temperatureOverride_K = NaN;
end

if nargin < 3 || isempty(pressureOverride_Pa)
    pressureOverride_Pa = NaN;
end

validateattributes(temperatureOverride_K, {'numeric'}, ...
    {'scalar', 'real'});

validateattributes(pressureOverride_Pa, {'numeric'}, ...
    {'scalar', 'real'});

if ~(isnan(temperatureOverride_K) ...
        || (isfinite(temperatureOverride_K) ...
        && temperatureOverride_K > 0))
    error( ...
        "Ambient temperature override must be positive, NaN, or empty.");
end

if ~(isnan(pressureOverride_Pa) ...
        || (isfinite(pressureOverride_Pa) ...
        && pressureOverride_Pa > 0))
    error( ...
        "Ambient pressure override must be positive, NaN, or empty.");
end

%% ISA troposphere
T_sl = 288.15;       % K
P_sl = 101325;       % Pa
lapse = -0.0065;     % K/m
g = 9.80665;         % m/s^2
R = 287.05;          % J/(kg*K)
gamma = 1.40;

isaTemperature_K = ...
    T_sl + lapse * altitude_m;

isaPressure_Pa = ...
    P_sl ...
    * (isaTemperature_K / T_sl)^(-g / (lapse * R));

%% Apply optional public test-condition overrides
temperatureOverrideActive = ...
    isfinite(temperatureOverride_K);

pressureOverrideActive = ...
    isfinite(pressureOverride_Pa);

temperature_K = ...
    isaTemperature_K;

pressure_Pa = ...
    isaPressure_Pa;

if temperatureOverrideActive
    temperature_K = ...
        temperatureOverride_K;
end

if pressureOverrideActive
    pressure_Pa = ...
        pressureOverride_Pa;
end

density_kg_m3 = ...
    pressure_Pa / (R * temperature_K);

speedOfSound_m_s = ...
    sqrt(gamma * R * temperature_K);

if temperatureOverrideActive || pressureOverrideActive
    ambientSource = ...
        "ISA altitude with explicit ambient override";
else
    ambientSource = ...
        "ISA troposphere";
end

%% Package outputs
atm.temperature_K = ...
    temperature_K;

atm.pressure_Pa = ...
    pressure_Pa;

atm.density_kg_m3 = ...
    density_kg_m3;

atm.speed_of_sound_m_s = ...
    speedOfSound_m_s;

atm.gamma = ...
    gamma;

atm.R_J_kgK = ...
    R;

atm.isa_temperature_K = ...
    isaTemperature_K;

atm.isa_pressure_Pa = ...
    isaPressure_Pa;

atm.temperature_override_active = ...
    temperatureOverrideActive;

atm.pressure_override_active = ...
    pressureOverrideActive;

atm.source = ...
    ambientSource;

end
