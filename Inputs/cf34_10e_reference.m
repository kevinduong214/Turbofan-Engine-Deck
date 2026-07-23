function ref = cf34_10e_reference()
%CF34_10E_REFERENCE Publicly reported CF34-10E reference information.
%
% This structure contains public calibration targets and architecture data.
% It does not represent proprietary GE component maps or internal design
% information.

%% Reference metadata
ref.metadata.engine_family = ...
    "GE CF34";

ref.metadata.engine_model = ...
    "CF34-10E";

ref.metadata.reference_scope = ...
    "Public-data engine-class reference";

ref.metadata.calibration_use = ...
    "Cycle-model scaling, architecture comparison, and validation";

%% Publicly reported performance
ref.performance.reference_condition = ...
    "Maximum power at sea level";

ref.performance.sea_level_static_thrust_lbf = ...
    20000;

ref.performance.sea_level_static_thrust_N = ...
    ref.performance.sea_level_static_thrust_lbf ...
    * 4.4482216152605;

ref.performance.overall_pressure_ratio = ...
    29.0;

%% Publicly reported architecture
ref.architecture.fan_stage_count = ...
    1;

ref.architecture.booster_stage_count = ...
    3;

ref.architecture.hpc_stage_count = ...
    9;

ref.architecture.hpt_stage_count = ...
    1;

ref.architecture.lpt_stage_count = ...
    4;

ref.architecture.spool_count = ...
    2;

%% Publicly reported external dimensions
ref.geometry.maximum_diameter_in = ...
    57.0;

ref.geometry.maximum_diameter_m = ...
    ref.geometry.maximum_diameter_in * 0.0254;

ref.geometry.length_in = ...
    145.5;

ref.geometry.length_m = ...
    ref.geometry.length_in * 0.0254;

%% Applications
ref.applications = [
    "Embraer E190"
    "Embraer E195"
    "Embraer Lineage 1000"
];

%% Data pedigree
ref.sources.ge_product_information = ...
    "GE Aerospace CF34 Engine Family product information";

ref.sources.certification_reference = ...
    "EASA.IM.E.021 GE CF34-10E series engine type certificate";

ref.notes = ...
    "Parameters not publicly verified remain model assumptions or calibration variables.";

end