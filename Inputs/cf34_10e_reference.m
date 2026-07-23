function ref = cf34_10e_reference()
% CF34_10E_REFERENCE Public CF34-10E reference information.
%
% The performance target uses the CF34-10E7 maximum-takeoff-with-APR
% rating. This structure contains only publicly reported information and
% does not represent proprietary component maps or internal GE data.

%% Reference metadata
ref.metadata.engine_family = ...
    "GE CF34";

ref.metadata.engine_series = ...
    "CF34-10E";

ref.metadata.calibration_variant = ...
    "CF34-10E7";

ref.metadata.reference_scope = ...
    "Public-data engine-class reference";

ref.metadata.calibration_rating = ...
    "Maximum takeoff with APR, uninstalled";

ref.metadata.calibration_condition = ...
    "Sea-level static, flat-rated through 30 deg C";

%% Publicly reported performance
ref.performance.sea_level_static_thrust_lbf = ...
    20360;

ref.performance.sea_level_static_thrust_N = ...
    ref.performance.sea_level_static_thrust_lbf ...
    * 4.4482216152605;

ref.performance.normal_takeoff_thrust_lbf = ...
    18820;

ref.performance.normal_takeoff_thrust_N = ...
    ref.performance.normal_takeoff_thrust_lbf ...
    * 4.4482216152605;

ref.performance.bypass_ratio = ...
    5.4;

ref.performance.overall_pressure_ratio = ...
    29.0;

ref.performance.thrust_to_weight_ratio = ...
    5.4;

%% Publicly reported architecture
ref.architecture.spool_count = ...
    2;

ref.architecture.fan_stage_count = ...
    1;

ref.architecture.lpc_stage_count = ...
    3;

ref.architecture.hpc_stage_count = ...
    9;

ref.architecture.hpt_stage_count = ...
    1;

ref.architecture.lpt_stage_count = ...
    4;

ref.architecture.combustor_type = ...
    "Annular";

ref.architecture.control_system = ...
    "FADEC";

%% Public rotor-speed information
% These are maximum-takeoff permissible rotor speeds from the EASA TCDS.
% They are used only as provisional mean-line sizing inputs.
ref.shaft.maximum_takeoff_low_spool_rpm = ...
    6325;

ref.shaft.maximum_takeoff_high_spool_rpm = ...
    18018;

ref.shaft.reference_100_percent_N1_rpm = ...
    5954.4;

ref.shaft.reference_100_percent_N2_rpm = ...
    17160;

%% Public engine-level geometry and mass
% These GE datasheet values describe the engine-level propulsion system.
ref.geometry.fan_diameter_in = ...
    53.0;

ref.geometry.fan_diameter_m = ...
    ref.geometry.fan_diameter_in * 0.0254;

ref.geometry.maximum_diameter_in = ...
    57.0;

ref.geometry.maximum_diameter_m = ...
    ref.geometry.maximum_diameter_in * 0.0254;

ref.geometry.length_in = ...
    145.0;

ref.geometry.length_m = ...
    ref.geometry.length_in * 0.0254;

ref.mass.engine_weight_lb = ...
    3700;

ref.mass.engine_weight_kg = ...
    ref.mass.engine_weight_lb * 0.45359237;

%% Applications
ref.applications = [
    "Embraer E190"
    "Embraer E195"
    "Embraer Lineage 1000"
];

%% Data pedigree
ref.sources.performance = ...
    "GE Aerospace CF34-10E public engine datasheet";

ref.sources.architecture = ...
    "GE Aerospace CF34 comparison and EASA TCDS IM.E.021";

ref.sources.certification = ...
    "EASA Type Certificate Data Sheet IM.E.021, Issue 06";

ref.notes = ...
    "Unpublished component efficiencies, internal pressure-ratio splits, " + ...
    "turbine temperature, core flow, and cooling flow remain modeled values.";

end