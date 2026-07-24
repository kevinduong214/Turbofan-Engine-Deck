function cfg = baseline_engine()
%BASELINE_ENGINE Provisional inputs for a notional two-spool turbofan.
% Values marked provisional will be replaced or justified using public
% literature before final analysis.

%% Metadata
cfg.meta.name = ...
    "Notional CF34-10E-class two-spool separate-flow turbofan";

cfg.meta.model_version = "0.5";

cfg.meta.condition = ...
    "Sea-level static";

cfg.meta.reference_engine = ...
    "GE CF34-10E class";

cfg.meta.calibration_status = ...
    "Core airflow calibrated to public CF34-10E7 sea-level-static thrust";

cfg.meta.model_scope = ...
    "Public-data-calibrated notional model; not an exact proprietary reproduction";

%% Reference-engine architecture
% Public CF34-10E architecture used to interpret the lumped components.
cfg.architecture.spool_count = 2;

cfg.architecture.fan_stage_count = 1;
cfg.architecture.lpc_stage_count = 3;
cfg.architecture.hpc_stage_count = 9;
cfg.architecture.hpt_stage_count = 1;
cfg.architecture.lpt_stage_count = 4;

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

%% Engine cycle parameters
% Core airflow calibrated to reproduce the public CF34-10E7
% maximum-takeoff sea-level-static thrust target.
%
% This is a model calibration result, not a publicly reported CF34 value.
cfg.engine.core_airflow_kg_s = 43.03;

% Public CF34-10E bypass ratio.
cfg.engine.bypass_ratio = 5.4;

% Public maximum overall pressure ratio.
cfg.engine.target_overall_pressure_ratio = 29.0;

% The individual component pressure-ratio split is not publicly verified.
% Fan and LPC pressure ratios remain assumptions; HPC pressure ratio is
% calculated so their product exactly satisfies the public overall ratio.
cfg.engine.fan_pressure_ratio = 1.60;
cfg.engine.lpc_pressure_ratio = 1.80;

cfg.engine.hpc_pressure_ratio = ...
    cfg.engine.target_overall_pressure_ratio ...
    / (cfg.engine.fan_pressure_ratio ...
    * cfg.engine.lpc_pressure_ratio);

% Modeled combustor exit temperature; not a publicly reported CF34 value.
cfg.engine.combustor_exit_temperature_K = 1600;

% Temporary legacy alias while existing scripts are being renamed.
cfg.engine.turbine_inlet_temperature_K = ...
    cfg.engine.combustor_exit_temperature_K;

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

%% Shaft speeds
% Public maximum-takeoff permissible CF34-10E rotor speeds from the EASA
% type-certificate data sheet. These affect preliminary mean-line sizing,
% but not the thermodynamic cycle calculation.
cfg.shaft.high_spool_rpm = 18018;
cfg.shaft.low_spool_rpm = 6325;

cfg.shaft.speed_source = ...
    "EASA TCDS maximum-takeoff permissible rotor speeds";

cfg.shaft.speed_status = ...
    "Provisional mean-line sizing inputs";

%% Preliminary HPT stage-design assumptions
% These are provisional mean-line design parameters. They will be refined
% and justified using public turbine-design literature in the report.

cfg.hpt.stage_count = ...
cfg.architecture.hpt_stage_count;

% Stage loading coefficient:
% psi = delta_h0 / U^2
cfg.hpt.loading_coefficient = 1.80;

% Flow coefficient:
% phi = Vx / U
cfg.hpt.flow_coefficient = 0.65;

% Degree of reaction
cfg.hpt.reaction = 0.50;

end