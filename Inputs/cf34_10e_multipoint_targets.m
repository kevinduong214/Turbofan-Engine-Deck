function targets = cf34_10e_multipoint_targets()
%CF34_10E_MULTIPOINT_TARGETS Public CF34-10E feasibility targets.
%
% This function consolidates publicly available CF34-10E7 rating and
% ICAO Engine Emissions Databank information for a bounded multipoint
% feasibility study. It intentionally separates directly reported values from
% values derived from a reported percentage of rated thrust.
%
% Primary ICAO EDB configuration:
%   UID 10GE133
%   CF34-10E7
%   2253M21 combustor
%   Block 2 production configuration
%
% The EDB records report fuel flow at four ICAO LTO power settings. The
% climb-out, approach, and idle thrust targets below are derived from the
% reported percentage of the 83.7 kN rated thrust, not independently
% reported thrust measurements.
%
% Public sources:
%   - EASA ICAO Aircraft Engine Emissions Databank, March 2026
%   - ICAO EDB datasheets 10GE133, 11GE146, 8GE119, and 11GE147
%   - EASA TCDS IM.E.021, Issue 06
%   - GE Aerospace CF34 public product information
%
% This is public-data feasibility material. It does not contain or claim
% proprietary GE component maps, internal geometry, or cooling schedules.

%% Metadata
targets.metadata.engine_family = "GE CF34";
targets.metadata.engine_variant = "CF34-10E7";
targets.metadata.primary_edb_uid = "10GE133";
targets.metadata.primary_combustor = "2253M21";
targets.metadata.primary_configuration = "Block 2";
targets.metadata.data_package_version = "1.0";
targets.metadata.edb_release = "03/2026";

%% Unit conversions
targets.units.lbf_to_N = 4.4482216152605;
targets.units.ft_to_m = 0.3048;

%% Certified and public engine ratings
% Maximum takeoff with automatic power reserve (APR).
targets.ratings.maximum_takeoff_apr.name = ...
    "Maximum takeoff with APR";
targets.ratings.maximum_takeoff_apr.thrust_lbf = 20360;
targets.ratings.maximum_takeoff_apr.thrust_N = ...
    targets.ratings.maximum_takeoff_apr.thrust_lbf ...
    * targets.units.lbf_to_N;
targets.ratings.maximum_takeoff_apr.flat_rating_temperature_K = ...
    303.15;
targets.ratings.maximum_takeoff_apr.pedigree = ...
    "Publicly reported TCDS rating";

% Normal takeoff rating used as Foo by the ICAO EDB record.
targets.ratings.normal_takeoff.name = ...
    "Normal takeoff / ICAO rated thrust";
targets.ratings.normal_takeoff.thrust_kN_tcds = 83.72;
targets.ratings.normal_takeoff.thrust_kN_edb = 83.70;
targets.ratings.normal_takeoff.thrust_N_edb = 83.70e3;
targets.ratings.normal_takeoff.pedigree = ...
    "Publicly reported TCDS and EDB rating";

% Maximum continuous rating.
targets.ratings.maximum_continuous.name = ...
    "Maximum continuous";
targets.ratings.maximum_continuous.thrust_lbf = 17040;
targets.ratings.maximum_continuous.thrust_N = ...
    targets.ratings.maximum_continuous.thrust_lbf ...
    * targets.units.lbf_to_N;
targets.ratings.maximum_continuous.flat_rating_temperature_K = ...
    298.15;
targets.ratings.maximum_continuous.pedigree = ...
    "Publicly reported TCDS rating";

%% Public maximum and EDB rated-point cycle descriptors
% GE public maximum values.
targets.cycle.public_maximum.bypass_ratio = 5.4;
targets.cycle.public_maximum.overall_pressure_ratio = 29.0;
targets.cycle.public_maximum.pedigree = ...
    "GE public maximum engine-level values";

% Values reported by the primary ICAO EDB record at the rated point.
targets.cycle.edb_rated_point.bypass_ratio = 5.09;
targets.cycle.edb_rated_point.pressure_ratio = 27.3;
targets.cycle.edb_rated_point.pedigree = ...
    "ICAO EDB UID 10GE133";

%% Primary ICAO LTO feasibility targets
ratedThrust_N = ...
    targets.ratings.normal_takeoff.thrust_N_edb;

powerSetting_percent = [100; 85; 30; 7];
mode = [
    "Takeoff"
    "Climb-out"
    "Approach"
    "Idle"
];

fuelFlow_kg_s = [
    0.866
    0.714
    0.237
    0.087
];

thrust_N = ...
    ratedThrust_N .* powerSetting_percent / 100;

thrustPedigree = [
    "Direct EDB rated thrust"
    "Derived from 85 percent of Foo"
    "Derived from 30 percent of Foo"
    "Derived from 7 percent of Foo"
];

recommendedUse = [
    "Diagnostic feasibility target"
    "Diagnostic feasibility target"
    "Diagnostic feasibility target"
    "Holdout"
];

tsfc_g_kN_s = ...
    fuelFlow_kg_s ./ (thrust_N / 1000) * 1000;

targets.edb.primary.uid = "10GE133";
targets.edb.primary.engine_identification = "CF34-10E7";
targets.edb.primary.combustor = "2253M21";
targets.edb.primary.rated_thrust_kN = 83.7;
targets.edb.primary.bypass_ratio = 5.09;
targets.edb.primary.pressure_ratio = 27.3;
targets.edb.primary.accessory_power_extraction_kW = 0;
targets.edb.primary.stage_bleed_percent_core_flow = 0;
targets.edb.primary.ambient_pressure_range_kPa = [97.2, 97.9];
targets.edb.primary.ambient_temperature_range_K = [296, 300];
targets.edb.primary.absolute_humidity_range_kg_kg = ...
    [0.0099, 0.0127];
targets.edb.primary.test_engine = "994-251/1";
targets.edb.primary.report = "GE Report R2006AE716";

targets.edb.primary.points = table( ...
    mode, ...
    powerSetting_percent, ...
    thrust_N, ...
    fuelFlow_kg_s, ...
    tsfc_g_kN_s, ...
    thrustPedigree, ...
    recommendedUse, ...
    'VariableNames', { ...
        'Mode', ...
        'PowerSetting_percentFoo', ...
        'Thrust_N', ...
        'FuelFlow_kg_s', ...
        'DerivedTSFC_g_kN_s', ...
        'ThrustPedigree', ...
        'RecommendedUse'});

%% Cross-configuration EDB envelope
% The E7-B row duplicates the 11GE146 test engine and is retained only as
% a reference record. It is excluded from the unique-configuration range.
variantUID = [
    "10GE133"
    "11GE146"
    "8GE119"
    "11GE147"
];

variantEngine = [
    "CF34-10E7"
    "CF34-10E7"
    "CF34-10E7"
    "CF34-10E7-B"
];

variantCombustor = [
    "2253M21"
    "2253M21-PFN"
    "SAC"
    "2253M21-PFN"
];

variantPressureRatio = [27.3; 27.2; 27.3; 27.2];
variantTakeoffFuel_kg_s = [0.866; 0.870; 0.871; 0.870];
variantClimbFuel_kg_s = [0.714; 0.717; 0.720; 0.717];
variantApproachFuel_kg_s = [0.237; 0.239; 0.244; 0.239];
variantIdleFuel_kg_s = [0.087; 0.088; 0.088; 0.088];
variantStatisticalUse = [true; true; true; false];

targets.edb.variants = table( ...
    variantUID, ...
    variantEngine, ...
    variantCombustor, ...
    repmat(5.09, 4, 1), ...
    variantPressureRatio, ...
    repmat(83.7, 4, 1), ...
    variantTakeoffFuel_kg_s, ...
    variantClimbFuel_kg_s, ...
    variantApproachFuel_kg_s, ...
    variantIdleFuel_kg_s, ...
    variantStatisticalUse, ...
    'VariableNames', { ...
        'UID', ...
        'EngineIdentification', ...
        'Combustor', ...
        'BypassRatio', ...
        'PressureRatio', ...
        'RatedThrust_kN', ...
        'TakeoffFuelFlow_kg_s', ...
        'ClimbFuelFlow_kg_s', ...
        'ApproachFuelFlow_kg_s', ...
        'IdleFuelFlow_kg_s', ...
        'IncludeInUniqueConfigurationEnvelope'});

uniqueMask = ...
    targets.edb.variants.IncludeInUniqueConfigurationEnvelope;

uniqueFuelMatrix_kg_s = [ ...
    targets.edb.variants.TakeoffFuelFlow_kg_s(uniqueMask), ...
    targets.edb.variants.ClimbFuelFlow_kg_s(uniqueMask), ...
    targets.edb.variants.ApproachFuelFlow_kg_s(uniqueMask), ...
    targets.edb.variants.IdleFuelFlow_kg_s(uniqueMask)];

targets.edb.unique_configuration_envelope.mode = mode;
targets.edb.unique_configuration_envelope.minimum_fuel_flow_kg_s = ...
    min(uniqueFuelMatrix_kg_s, [], 1)';
targets.edb.unique_configuration_envelope.maximum_fuel_flow_kg_s = ...
    max(uniqueFuelMatrix_kg_s, [], 1)';
targets.edb.unique_configuration_envelope.mean_fuel_flow_kg_s = ...
    mean(uniqueFuelMatrix_kg_s, 1)';

%% Cruise validation target
targets.cruise.altitude_ft = 35000;
targets.cruise.altitude_m = ...
    targets.cruise.altitude_ft * targets.units.ft_to_m;
targets.cruise.flight_mach = 0.8;
targets.cruise.sfc_lbm_lbf_hr = 0.64;
targets.cruise.tsfc_g_kN_s = ...
    targets.cruise.sfc_lbm_lbf_hr ...
    * 0.45359237 ...
    / (targets.units.lbf_to_N * 3600) ...
    * 1e6;
targets.cruise.recommended_use = ...
    "Holdout";
targets.cruise.pedigree = ...
    "GE public CF34-10E datasheet";

%% Data-use cautions
targets.notes = [
    "Do not replace the public maximum BPR and OPR with the EDB rated-point values as fixed constants."
    "The difference between 5.4/29.0 and 5.09/27.3 should be reproduced through off-design flow and pressure-ratio behavior."
    "EDB fuel flows retain reported test-condition ranges and should initially use uncertainty bands."
    "The EDB climb, approach, and idle thrust targets are derived from percent Foo."
    "The 11GE147 E7-B record duplicates the 11GE146 test engine and should not be double-counted."
    "No public target in this file validates internal cooling flow, component maps, or turbine inlet temperature."
];

end
