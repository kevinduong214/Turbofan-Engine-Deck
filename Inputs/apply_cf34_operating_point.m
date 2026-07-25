function cfg = apply_cf34_operating_point(cfg, pointId)
%APPLY_CF34_OPERATING_POINT Apply a named public CF34-10E condition.
%
% Usage:
%   cfg = baseline_engine();
%   cfg = apply_cf34_operating_point(cfg, "normal_takeoff_edb");
%
% This function updates only external operating-condition fields and public
% targets. It does not create off-design component behavior.

validateattributes(cfg, {'struct'}, {'scalar'});

point = cf34_10e_operating_point(pointId);

%% Store the full operating-point record
cfg.operating_point = point;

%% Apply flight and ambient conditions
cfg.flight.altitude_m = ...
    point.altitude_m;

cfg.flight.Mach = ...
    point.flight_mach;

cfg.flight.ambient_temperature_override_K = ...
    point.ambient_temperature_override_K;

cfg.flight.ambient_pressure_override_Pa = ...
    point.ambient_pressure_override_Pa;

%% Store external load definitions
% These fields are metadata until the cycle model explicitly applies
% customer bleed and accessory power extraction.
cfg.external_loads.external_bleed_fraction = ...
    point.external_bleed_fraction;

cfg.external_loads.accessory_power_extraction_W = ...
    point.accessory_power_extraction_W;

%% Update descriptive metadata
cfg.meta.condition = ...
    point.name;

cfg.meta.operating_point_id = ...
    point.id;

cfg.meta.operating_point_role = ...
    point.calibration_role;

%% Guard against silently ignoring unsupported nonzero loads
if point.external_bleed_fraction ~= 0
    error( ...
        "Operating point %s requests nonzero external bleed, " + ...
        "but external bleed is not yet applied by run_turbofan.", ...
        point.id);
end

if point.accessory_power_extraction_W ~= 0
    error( ...
        "Operating point %s requests nonzero accessory extraction, " + ...
        "but accessory power is not yet applied by run_turbofan.", ...
        point.id);
end

end
