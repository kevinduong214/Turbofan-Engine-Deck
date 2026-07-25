function print_turbofan_results(results)
%PRINT_TURBOFAN_RESULTS Display cycle and performance results.

cfg = results.cfg;
atm = results.atm;
s = results.stations;
m = results.mass;
p = results.power;
perf = results.performance;

fprintf("\n%s\n", cfg.meta.name);
fprintf("Model version: %s\n", cfg.meta.model_version);

if isfield(results, "operating_point")
    fprintf("Operating point:      %s\n", ...
        char(results.operating_point.name));

    fprintf("Calibration role:     %s\n", ...
        char(results.operating_point.calibration_role));

    fprintf("Ambient source:       %s\n", ...
        char(results.atm.source));
end

fprintf("--------------------------------------------------\n");
fprintf("Altitude:             %.0f m\n", cfg.flight.altitude_m);
fprintf("Flight Mach number:   %.2f\n", cfg.flight.Mach);
fprintf("Ambient temperature:  %.2f K\n", atm.temperature_K);
fprintf("Ambient pressure:     %.2f kPa\n", atm.pressure_Pa / 1000);
fprintf("Flight velocity:      %.2f m/s\n", s.station0.velocity_m_s);
fprintf("Core airflow:         %.2f kg/s\n", m.mdot_core_air_kg_s);
fprintf("Bypass airflow:       %.2f kg/s\n", m.mdot_bypass_air_kg_s);
fprintf("Total airflow:        %.2f kg/s\n\n", m.mdot_total_air_kg_s);



%% Station table
stationName = ...
    ["0"; "2"; "21"; "13"; "25"; "3"; ...
     "4"; "41"; "45"; "5"; "8"; "18"];

totalTemperature_K = [
    s.station0.Tt_K
    s.station2.Tt_K
    s.station21.Tt_K
    s.station13.Tt_K
    s.station25.Tt_K
    s.station3.Tt_K
    s.station4.Tt_K
    s.station41.Tt_K
    s.station45.Tt_K
    s.station5.Tt_K
    s.station8.Tt_K
    s.station18.Tt_K
];

totalPressure_kPa = [
    s.station0.Pt_Pa
    s.station2.Pt_Pa
    s.station21.Pt_Pa
    s.station13.Pt_Pa
    s.station25.Pt_Pa
    s.station3.Pt_Pa
    s.station4.Pt_Pa
    s.station41.Pt_Pa
    s.station45.Pt_Pa
    s.station5.Pt_Pa
    s.station8.Pt_Pa
    s.station18.Pt_Pa
] / 1000;

stationTable = table( ...
    stationName, ...
    totalTemperature_K, ...
    totalPressure_kPa, ...
    'VariableNames', {'Station', 'Tt_K', 'Pt_kPa'});

disp("Engine station results:");
disp(stationTable);

%% Cooling
fprintf("HPT cooling system\n");
fprintf("--------------------------------------------------\n");
fprintf("Cooling-bleed fraction:   %.2f %%\n", ...
    100 * results.cooling.bleed_fraction);
fprintf("Cooling-air flow:         %.3f kg/s\n", ...
    m.mdot_cooling_air_kg_s);
fprintf("Combustor air flow:       %.3f kg/s\n", ...
    m.mdot_combustor_air_kg_s);
fprintf("Combustor exit Tt:        %.2f K\n", s.station4.Tt_K);
fprintf("Mixed HPT inlet Tt:       %.2f K\n", s.station41.Tt_K);
fprintf("Mixed HPT inlet Pt:       %.2f kPa\n", ...
    s.station41.Pt_Pa / 1000);

fprintf("Mixer pressure recovery:  %.5f\n", ...
    s.station41.pressure_recovery);

fprintf("Mixer total-Pt loss:      %.3f %%\n", ...
    100 * s.station41.pressure_loss_fraction);

fprintf("Mixer energy residual:    %.6f W\n\n", ...
    results.cooling.mixer_energy_residual_W);

%% Fuel
fprintf("Combustor and fuel flow\n");
fprintf("--------------------------------------------------\n");
fprintf("Fuel-air ratio:           %.5f\n", ...
    s.station4.fuel_air_ratio);
fprintf("Fuel flow:                %.3f kg/s\n", ...
    m.mdot_fuel_kg_s);
fprintf("HPT gas flow:             %.3f kg/s\n\n", ...
    m.mdot_hpt_kg_s);

%% Turbines
fprintf("Turbine performance\n");
fprintf("--------------------------------------------------\n");
fprintf("HPT temperature drop:     %.2f K\n", ...
    s.station41.Tt_K - s.station45.Tt_K);
fprintf("HPT Pt-out/Pt-in:         %.4f\n", ...
    s.station45.total_pressure_ratio);
fprintf("HPT shaft power:          %.3f MW\n", ...
    p.hpt_W / 1e6);
fprintf("LPT temperature drop:     %.2f K\n", ...
    s.station45.Tt_K - s.station5.Tt_K);
fprintf("LPT Pt-out/Pt-in:         %.4f\n", ...
    s.station5.total_pressure_ratio);
fprintf("LPT shaft power:          %.3f MW\n\n", ...
    p.lpt_W / 1e6);

%% Nozzles
fprintf("Nozzle performance\n");
fprintf("--------------------------------------------------\n");
fprintf("Core nozzle choked:       %s\n", ...
    string(s.station9.is_choked));
fprintf("Core exit velocity:       %.2f m/s\n", ...
    s.station9.velocity_m_s);
fprintf("Core exit pressure:       %.2f kPa\n", ...
    s.station9.P_Pa / 1000);
fprintf("Core exit area:           %.4f m^2\n\n", ...
    s.station9.area_m2);

fprintf("Bypass nozzle choked:     %s\n", ...
    string(s.station19.is_choked));
fprintf("Bypass exit velocity:     %.2f m/s\n", ...
    s.station19.velocity_m_s);
fprintf("Bypass exit pressure:     %.2f kPa\n", ...
    s.station19.P_Pa / 1000);
fprintf("Bypass exit area:         %.4f m^2\n\n", ...
    s.station19.area_m2);

%% Engine performance
fprintf("Engine performance\n");
fprintf("--------------------------------------------------\n");
fprintf("Core-stream thrust:       %.3f kN\n", ...
    perf.core_net_thrust_N / 1000);
fprintf("Bypass-stream thrust:     %.3f kN\n", ...
    perf.bypass_net_thrust_N / 1000);
fprintf("Net engine thrust:        %.3f kN\n", ...
    perf.net_thrust_N / 1000);
fprintf("Specific thrust:          %.2f N/(kg/s)\n", ...
    perf.specific_thrust_N_per_kg_s);
fprintf("TSFC:                     %.3f g/(kN*s)\n\n", ...
    perf.tsfc_g_kN_s);

%% Engine efficiency
eta = results.efficiency;

fprintf("Preliminary efficiency metrics\n");
fprintf("--------------------------------------------------\n");

fprintf("Jet kinetic power increase: %.3f MW\n", ...
    eta.jet_kinetic_power_W / 1e6);

fprintf("Fuel chemical power:        %.3f MW\n", ...
    eta.fuel_chemical_power_W / 1e6);

fprintf("Kinetic thermal efficiency: %.3f %%\n", ...
    100 * eta.kinetic_thermal);

if eta.is_static_condition
    fprintf("Propulsive efficiency:      N/A at static condition\n");
    fprintf("Overall efficiency:         N/A at static condition\n\n");
else
    fprintf("Propulsive efficiency:      %.3f %%\n", ...
        100 * eta.propulsive);

    fprintf("Overall efficiency:         %.3f %%\n\n", ...
        100 * eta.overall);
end

%% Preliminary HPT sizing
hpt = results.hpt_sizing;

fprintf("Preliminary HPT mean-line sizing\n");
fprintf("--------------------------------------------------\n");

fprintf("HPT stage count:          %d\n", ...
    hpt.stage_count);

fprintf("Loading coefficient:      %.3f\n", ...
    hpt.loading_coefficient);

fprintf("Flow coefficient:         %.3f\n", ...
    hpt.flow_coefficient);

fprintf("Degree of reaction:       %.3f\n", ...
    hpt.reaction);

fprintf("High-spool speed:         %.0f rpm\n", ...
    hpt.shaft_speed_rpm);

fprintf("Mean blade speed:         %.2f m/s\n", ...
    hpt.blade_speed_m_s);

fprintf("Axial gas velocity:       %.2f m/s\n", ...
    hpt.axial_velocity_m_s);

fprintf("Mean blade radius:        %.4f m\n", ...
    hpt.mean_radius_m);

fprintf("Rotor-inlet blade span:   %.4f m\n", ...
    hpt.blade_span_inlet_m);

fprintf("Rotor-exit blade span:    %.4f m\n", ...
    hpt.blade_span_exit_m);

fprintf("Inlet hub radius:         %.4f m\n", ...
    hpt.hub_radius_inlet_m);

fprintf("Inlet tip radius:         %.4f m\n", ...
    hpt.tip_radius_inlet_m);

fprintf("Exit hub radius:          %.4f m\n", ...
    hpt.hub_radius_exit_m);

fprintf("Exit tip radius:          %.4f m\n", ...
    hpt.tip_radius_exit_m);

fprintf("Rotor inlet alpha:        %.2f deg\n", ...
    hpt.alpha1_deg);

fprintf("Rotor exit alpha:         %.2f deg\n", ...
    hpt.alpha2_deg);

fprintf("Rotor inlet beta:         %.2f deg\n", ...
    hpt.beta1_deg);

fprintf("Rotor exit beta:          %.2f deg\n", ...
    hpt.beta2_deg);

fprintf("Rotor inlet static T:     %.2f K\n", ...
    hpt.rotor_inlet_static_temperature_K);

fprintf("Rotor inlet static P:     %.2f kPa\n", ...
    hpt.rotor_inlet_static_pressure_Pa / 1000);

fprintf("Rotor exit static T:      %.2f K\n", ...
    hpt.rotor_exit_static_temperature_K);

fprintf("Rotor exit static P:      %.2f kPa\n", ...
    hpt.rotor_exit_static_pressure_Pa / 1000);

fprintf("Rotor static pressure drop: %.2f kPa\n", ...
    hpt.static_pressure_drop_Pa / 1000);

fprintf("Rotor inlet absolute Mach:  %.3f\n", ...
    hpt.rotor_inlet_absolute_mach);

fprintf("Rotor inlet relative Mach:  %.3f\n", ...
    hpt.rotor_inlet_relative_mach);

fprintf("Rotor exit absolute Mach:   %.3f\n", ...
    hpt.rotor_exit_absolute_mach);

fprintf("Rotor exit relative Mach:   %.3f\n", ...
    hpt.rotor_exit_relative_mach);

fprintf("Maximum mean-line Mach:     %.3f (%s)\n", ...
    hpt.maximum_mach, ...
    char(hpt.maximum_mach_location));

fprintf("Aerodynamic status:         %s\n", ...
    char(hpt.aerodynamic_status));

if hpt.exceeds_supersonic_threshold
    fprintf(2, ...
        "HPT aerodynamic warning: At least one preliminary " + ...
        "mean-line Mach number is at or above %.2f.\n\n", ...
        hpt.supersonic_mach_threshold);

elseif hpt.exceeds_transonic_threshold
    fprintf(2, ...
        "HPT aerodynamic warning: At least one preliminary " + ...
        "mean-line Mach number is at or above %.2f.\n\n", ...
        hpt.transonic_mach_threshold);

else
    fprintf("\n");
end

%% Balance checks
fprintf("Balance checks\n");
fprintf("--------------------------------------------------\n");
fprintf("High-spool residual:      %.6f W\n", ...
    results.residuals.high_spool_W);
fprintf("Low-spool residual:       %.6f W\n", ...
    results.residuals.low_spool_W);
fprintf("Mass-flow residual:       %.9f kg/s\n", ...
    results.residuals.mass_kg_s);
fprintf("Mixer-energy residual:    %.6f W\n\n", ...
    results.cooling.mixer_energy_residual_W);

fprintf("Compression-system power\n");
fprintf("--------------------------------------------------\n");
fprintf("Fan power required:       %.3f MW\n", p.fan_W / 1e6);
fprintf("LPC power required:       %.3f MW\n", p.lpc_W / 1e6);
fprintf("HPC power required:       %.3f MW\n", p.hpc_W / 1e6);
fprintf("Total compression:        %.3f MW\n\n", ...
    p.total_compression_W / 1e6);

if isfield(results.residuals, ...
        "core_nozzle_capacity_kg_s")

    fprintf("Core nozzle capacity residual:   %.9f kg/s\n", ...
        results.residuals.core_nozzle_capacity_kg_s);

    fprintf("Bypass nozzle capacity residual: %.9f kg/s\n", ...
        results.residuals.bypass_nozzle_capacity_kg_s);
end

end