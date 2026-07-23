diary off;

clear;
clc;
close all;

%% Project paths
studyFolder = fileparts(mfilename("fullpath"));
projectRoot = fileparts(studyFolder);

addpath(fullfile(projectRoot, "Inputs"));
addpath(fullfile(projectRoot, "Functions"));

%% Load model and public reference
cfg = baseline_engine();
ref = cf34_10e_reference();

caseTag = "cf34_precalibration";

%% Create matching Data and Figures run folders
runOutput = create_run_output_folders( ...
    projectRoot, ...
    cfg.meta.model_version);

fileSuffix = ...
    caseTag + "_" + runOutput.file_tag;

%% Start Command Window recording
commandWindowPath = fullfile( ...
    runOutput.data_folder, ...
    "command_window_" + fileSuffix + ".txt");

diary(char(commandWindowPath));

try
    fprintf("\nCF34-10E pre-calibration comparison started\n");
    fprintf("==================================================\n");
    fprintf("Model version: %s\n", runOutput.version_tag);
    fprintf("Run number:    %02d\n", runOutput.run_number);
    fprintf("Reference:     %s\n", ref.metadata.engine_model);
    fprintf("Data folder:   %s\n\n", runOutput.data_folder);

    %% Save exact comparison inputs
    configurationPath = fullfile( ...
        runOutput.data_folder, ...
        "configuration_" + fileSuffix + ".mat");

    save( ...
        configurationPath, ...
        "cfg", ...
        "ref", ...
        "caseTag", ...
        "runOutput");

    %% Run current model without calibration changes
    results = run_turbofan(cfg);

    %% Calculate comparable model metrics
    modelThrust_N = ...
        results.performance.net_thrust_N;

    modelOverallPressureRatio = ...
        cfg.engine.fan_pressure_ratio ...
        * cfg.engine.lpc_pressure_ratio ...
        * cfg.engine.hpc_pressure_ratio;

    referenceThrust_N = ...
        ref.performance.sea_level_static_thrust_N;

    referenceOverallPressureRatio = ...
        ref.performance.overall_pressure_ratio;

    thrustError_percent = ...
        100 * (modelThrust_N - referenceThrust_N) ...
        / referenceThrust_N;

    oprError_percent = ...
        100 * (modelOverallPressureRatio ...
        - referenceOverallPressureRatio) ...
        / referenceOverallPressureRatio;

    %% Numerical comparison table
    metric = [
        "Sea-level static thrust"
        "Overall pressure ratio"
    ];

    modelValue = [
        modelThrust_N / 1000
        modelOverallPressureRatio
    ];

    referenceValue = [
        referenceThrust_N / 1000
        referenceOverallPressureRatio
    ];

    error_percent = [
        thrustError_percent
        oprError_percent
    ];

    units = [
        "kN"
        "-"
    ];

    comparisonTable = table( ...
        metric, ...
        modelValue, ...
        referenceValue, ...
        error_percent, ...
        units, ...
        'VariableNames', { ...
            'Metric', ...
            'ModelValue', ...
            'ReferenceValue', ...
            'Error_percent', ...
            'Units'});

    fprintf("Numerical calibration comparison\n");
    fprintf("--------------------------------------------------\n");
    disp(comparisonTable);

    %% Architecture comparison table
    component = [
        "Fan"
        "Booster"
        "High-pressure compressor"
        "High-pressure turbine"
        "Low-pressure turbine"
    ];

    referenceStageCount = [
        ref.architecture.fan_stage_count
        ref.architecture.booster_stage_count
        ref.architecture.hpc_stage_count
        ref.architecture.hpt_stage_count
        ref.architecture.lpt_stage_count
    ];

    modelRepresentation = [
        "Single lumped fan component"
        "Single lumped LPC component"
        "Single lumped HPC component"
        string(cfg.hpt.stage_count) + "-stage mean-line HPT"
        "Single lumped LPT thermodynamic component"
    ];

    architectureTable = table( ...
        component, ...
        referenceStageCount, ...
        modelRepresentation, ...
        'VariableNames', { ...
            'Component', ...
            'ReferenceStageCount', ...
            'ModelRepresentation'});

    fprintf("Architecture comparison\n");
    fprintf("--------------------------------------------------\n");
    disp(architectureTable);

    %% Save comparison CSV files
    performanceCsvPath = fullfile( ...
        runOutput.data_folder, ...
        "performance_comparison_" + fileSuffix + ".csv");

    writetable( ...
        comparisonTable, ...
        performanceCsvPath);

    architectureCsvPath = fullfile( ...
        runOutput.data_folder, ...
        "architecture_comparison_" + fileSuffix + ".csv");

    writetable( ...
        architectureTable, ...
        architectureCsvPath);

    %% Save complete MATLAB comparison
    resultsPath = fullfile( ...
        runOutput.data_folder, ...
        "comparison_results_" + fileSuffix + ".mat");

    save( ...
        resultsPath, ...
        "results", ...
        "cfg", ...
        "ref", ...
        "comparisonTable", ...
        "architectureTable", ...
        "caseTag", ...
        "runOutput");

    %% Summary
    fprintf("Pre-calibration summary\n");
    fprintf("--------------------------------------------------\n");
    fprintf("Model thrust:       %.3f kN\n", ...
        modelThrust_N / 1000);

    fprintf("Reference thrust:   %.3f kN\n", ...
        referenceThrust_N / 1000);

    fprintf("Thrust error:       %+.3f %%\n", ...
        thrustError_percent);

    fprintf("Model OPR:          %.3f\n", ...
        modelOverallPressureRatio);

    fprintf("Reference OPR:      %.3f\n", ...
        referenceOverallPressureRatio);

    fprintf("OPR error:          %+.3f %%\n\n", ...
        oprError_percent);

    fprintf("Saved output files\n");
    fprintf("--------------------------------------------------\n");
    fprintf("Configuration:      %s\n", configurationPath);
    fprintf("Comparison MAT:     %s\n", resultsPath);
    fprintf("Performance CSV:    %s\n", performanceCsvPath);
    fprintf("Architecture CSV:   %s\n", architectureCsvPath);
    fprintf("Command log:        %s\n", commandWindowPath);
    fprintf("==================================================\n");
    fprintf("CF34-10E pre-calibration comparison complete\n\n");

    diary off;

catch ME
    fprintf(2, ...
        "\nCF34-10E comparison failed.\n\n");

    fprintf(2, "%s\n", ...
        getReport( ...
            ME, ...
            'extended', ...
            'hyperlinks', ...
            'off'));

    diary off;
    rethrow(ME);
end