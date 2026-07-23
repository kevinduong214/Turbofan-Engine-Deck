diary off;

clear;
clc;
close all;

%% Project paths
projectRoot = fileparts(mfilename("fullpath"));

addpath(fullfile(projectRoot, "Inputs"));
addpath(fullfile(projectRoot, "Functions"));

%% Load engine configuration
cfg = baseline_engine();

%% Case identification
bleedPercent = ...
    100 * cfg.cooling.bleed_fraction;

bleedTag = ...
    string(sprintf("%04.1f", bleedPercent));

bleedTag = ...
    replace(bleedTag, ".", "p");

caseTag = ...
    "baseline_B" + bleedTag;

%% Create Data and Figures run folders
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
    fprintf("\nTurbofan model run started\n");
    fprintf("==================================================\n");
    fprintf("Case:          %s\n", caseTag);
    fprintf("Model version: %s\n", runOutput.version_tag);
    fprintf("Run number:    %02d\n", runOutput.run_number);
    fprintf("Data folder:   %s\n", runOutput.data_folder);
    fprintf("Figure folder: %s\n\n", runOutput.figure_folder);

    %% Save exact input configuration
    configurationPath = fullfile( ...
        runOutput.data_folder, ...
        "configuration_" + fileSuffix + ".mat");

    save(configurationPath, "cfg");

    %% Run engine model
    results = run_turbofan(cfg);

    %% Display calculated results
    print_turbofan_results(results);

    %% Save complete results structure
    resultsPath = fullfile( ...
        runOutput.data_folder, ...
        "results_" + fileSuffix + ".mat");

    save(resultsPath, "results");

    %% Export Project 2 HPT boundary conditions
    [hptMatPath, hptCsvPath] = ...
        export_hpt_blade_conditions( ...
            results, ...
            runOutput.data_folder, ...
            fileSuffix);

    %% Print saved-file locations
    fprintf("Saved output files\n");
    fprintf("--------------------------------------------------\n");
    fprintf("Configuration: %s\n", configurationPath);
    fprintf("Complete data: %s\n", resultsPath);
    fprintf("HPT MAT file:  %s\n", hptMatPath);
    fprintf("HPT CSV file:  %s\n", hptCsvPath);
    fprintf("Command log:   %s\n", commandWindowPath);
    fprintf("==================================================\n");
    fprintf("Turbofan model run complete\n\n");

catch ME
    fprintf(2, ...
        "\nTurbofan model run failed:\n%s\n", ...
        ME.message);

    diary off;
    rethrow(ME);
end

diary off;