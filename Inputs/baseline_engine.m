function cfg = baseline_engine()
%BASELINE_ENGINE Provisional inputs for a notional two-spool turbofan.
% Values marked provisional will be replaced or justified using public
% literature before final analysis.

%% Metadata
cfg.meta.name = "Notional two-spool separate-flow turbofan";
cfg.meta.model_version = "0.4";
cfg.meta.condition = "Sea-level static";

%% Flight condition
cfg.flight.altitude_m = 0;
cfg.flight.Mach = 0.0;

%% Working-fluid assumptions
cfg.thermo.R_J_kgK = 287.05;

cfg.thermo.gamma_cold = 1.40;
cfg.thermo.cp_cold_J_kgK = ...
    cfg.thermo.gamma_cold * cfg.thermo.R_J_kgK / ...
    (cfg.thermo.gamma_cold - 1);

cfg.thermo.gamma_hot = 1.33;
cfg.thermo.cp_hot_J_kgK = ...
    cfg.thermo.gamma_hot * cfg.thermo.R_J_kgK / ...
    (cfg.thermo.gamma_hot - 1);

%% Engine architecture — provisional values
cfg.engine.core_airflow_kg_s = 45;
cfg.engine.bypass_ratio = 5.0;

cfg.engine.fan_pressure_ratio = 1.60;
cfg.engine.lpc_pressure_ratio = 1.80;
cfg.engine.hpc_pressure_ratio = 10.0;

cfg.engine.turbine_inlet_temperature_K = 1600;

%% Component efficiencies
cfg.eff.diffuser_pressure_recovery = 0.995;
cfg.eff.fan_isentropic = 0.90;
cfg.eff.lpc_isentropic = 0.89;
cfg.eff.hpc_isentropic = 0.88;
cfg.eff.combustor = 0.99;
cfg.eff.hpt_isentropic = 0.91;
cfg.eff.lpt_isentropic = 0.92;

%% Nozzle total-pressure recoveries
% Losses are represented as reductions in available nozzle total pressure.
cfg.loss.core_nozzle_pressure_recovery = 0.98;
cfg.loss.bypass_nozzle_pressure_recovery = 0.98;

%% Mechanical efficiencies
cfg.mech.hpt = 0.99;
cfg.mech.lpt = 0.99;

%% Pressure losses
cfg.loss.combustor_pressure_ratio = 0.95;
cfg.loss.bypass_duct_pressure_ratio = 0.99;
cfg.loss.core_duct_pressure_ratio = 0.99;

%% Fuel
cfg.fuel.lower_heating_value_J_kg = 43.0e6;

%% HPT cooling-bleed fraction
% Fraction of HPC exit air extracted before the combustor and returned
% to the core flow immediately upstream of the HPT.
%
% beta_cool = mdot_coolant / mdot_core
%
% Examples:
%   0.00 = uncooled reference case
%   0.05 = 5% cooling-bleed case
cfg.cooling.bleed_fraction = 0.05;

%% Cooling-mixer pressure-loss model
% Provisional correlation:
%
%   delta_Pt / Pt = K_mix * beta_cool^2
%
% where beta_cool is expressed as a decimal fraction.
%
% With K_mix = 1:
%   beta_cool = 0.05 -> 0.25% total-pressure loss
%   beta_cool = 0.10 -> 1.00% total-pressure loss
%
% This correlation will be refined or justified using public literature.
cfg.loss.cooling_mixer_loss_coefficient = 1.0;

%% Shaft speeds — provisional bridge inputs
cfg.shaft.high_spool_rpm = 12000;
cfg.shaft.low_spool_rpm = 4000;

%% Preliminary HPT stage-design assumptions
% These are provisional mean-line design parameters. They will be refined
% and justified using public turbine-design literature in the report.

cfg.hpt.stage_count = 1;

% Stage loading coefficient:
% psi = delta_h0 / U^2
cfg.hpt.loading_coefficient = 1.80;

% Flow coefficient:
% phi = Vx / U
cfg.hpt.flow_coefficient = 0.65;

% Degree of reaction
cfg.hpt.reaction = 0.50;

end