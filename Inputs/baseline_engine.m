function cfg = baseline_engine()
%BASELINE_ENGINE Inputs for the validated notional CF34-10E-class APR deck.
% Automatic Power Reserve (APR) is the accepted maximum-takeoff design point;
% EDB denotes the ICAO Engine Emissions Databank diagnostic data.

%% Metadata
cfg.meta.name = ...
    "Notional CF34-10E-class two-spool separate-flow turbofan";

cfg.meta.model_version = ...
    "0.6";

cfg.meta.condition = ...
    "Maximum-takeoff APR design point, sea-level static";

cfg.meta.reference_engine = ...
    "GE CF34-10E class";

cfg.meta.calibration_status = ...
    "Validated APR design point; bounded EDB multipoint study retained as an infeasibility diagnostic";

cfg.meta.release_status = ...
    "Validated APR design-point engine deck";

cfg.meta.apr_regression_foundation = ...
    "v0.5 accepted APR numerical baseline";

cfg.meta.multipoint_status = ...
    "Diagnostic feasibility study; no accepted EDB off-design calibration";

cfg.meta.validation_scope = ...
    "APR cycle and fixed effective nozzle areas only";

cfg.meta.model_scope = ...
    "Public-data-calibrated notional model; not an exact proprietary reproduction";

cfg.meta.development_branch = ...
    "cf34-10e-multipoint-calibration";

%% Reference-engine architecture
% Public architecture used to interpret the lumped cycle components.
cfg.architecture.spool_count = 2;

cfg.architecture.fan_stage_count = 1;
cfg.architecture.lpc_stage_count = 3;
cfg.architecture.hpc_stage_count = 9;
cfg.architecture.hpt_stage_count = 1;
cfg.architecture.lpt_stage_count = 4;

%% Active operating point
cfg = apply_cf34_operating_point( ...
    cfg, ...
    "maximum_takeoff_apr");

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

%% Corrected-parameter reference state
cfg.reference.temperature_K = ...
    288.15;

cfg.reference.pressure_Pa = ...
    101325;

cfg.reference.description = ...
    "Standard-day reference for dimensional corrected flow and speed";

%% Engine cycle parameters
% Calibrated model value for the public maximum-takeoff SLS thrust target;
% it is not a publicly reported CF34 airflow.
cfg.engine.core_airflow_kg_s = 43.03;

% Public maximum engine-level targets.
cfg.engine.bypass_ratio = 5.4;

cfg.engine.target_overall_pressure_ratio = 29.0;

% The assumed component split is constrained to the public overall ratio.
cfg.engine.fan_pressure_ratio = 1.60;
cfg.engine.lpc_pressure_ratio = 1.80;

cfg.engine.hpc_pressure_ratio = ...
    cfg.engine.target_overall_pressure_ratio ...
    / (cfg.engine.fan_pressure_ratio ...
    * cfg.engine.lpc_pressure_ratio);

% Modeled combustor exit temperature; not a public CF34 value.
cfg.engine.combustor_exit_temperature_K = 1600;

% Compatibility alias; combustor_exit_temperature_K is authoritative.
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

%% Fixed effective nozzle geometry
% Areas captured from the calibrated maximum-takeoff APR design point.
% These are model-derived geometry values, not publicly reported CF34 data.
cfg.geometry.core_nozzle_area_m2 = ...
    0.157305086;

cfg.geometry.bypass_nozzle_area_m2 = ...
    0.693714887;

cfg.geometry.nozzle_area_source = ...
    "Captured from accepted v0.5 APR design-point calibration";

cfg.geometry.nozzle_area_status = ...
    "Fixed effective areas for APR validation and multipoint feasibility diagnostics";

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
% beta_cool = mdot_coolant/mdot_core; coolant returns before the HPT.
cfg.cooling.bleed_fraction = 0.05;

%% Cooling-mixer pressure-loss model
% Assumed correlation: delta_Pt/Pt = K_mix*beta_cool^2.
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

cfg.hpt.stage_count = ...
cfg.architecture.hpt_stage_count;

% Modeled coefficients selected by psi-phi screening and sensitivity analysis;
% they are not publicly reported CF34 data.
cfg.hpt.loading_coefficient = 1.20;
cfg.hpt.flow_coefficient = 0.45;
cfg.hpt.reaction = 0.50;

cfg.hpt.design_status = ...
    "Preliminary v0.5 mean-line design";

cfg.hpt.selection_basis = ...
    "Design-space screening and 54-scenario ranking sensitivity study";

end
