diary off;

clear;
clc;
close all;

%% Project paths
% This script is stored inside the Studies folder.
studyFolder = fileparts(mfilename("fullpath"));
projectRoot = fileparts(studyFolder);

addpath(fullfile(projectRoot, "Inputs"));
addpath(fullfile(projectRoot, "Functions"));

%% Study definition
cfgBase = baseline_engine();

% Provisional cooling-bleed range.
bleedFractions = linspace(0.00, 0.10, 21);
numberOfCases = numel(bleedFractions);

fixedTIT_K = ...
    cfgBase.engine.combustor_exit_temperature_K;

caseTag = "fixedTIT";

%% Create matching Data and Figures run folders
runOutput = create_run_output_folders( ...
    projectRoot, ...
    cfgBase.meta.model_version);

fileSuffix = ...
    caseTag + "_" + runOutput.file_tag;

%% Start Command Window recording
commandWindowPath = fullfile( ...
    runOutput.data_folder, ...
    "command_window_" + fileSuffix + ".txt");

diary(char(commandWindowPath));

try
    fprintf("\nFixed-TIT cooling-bleed sweep started\n");
    fprintf("==================================================\n");
    fprintf("Study:         %s\n", caseTag);
    fprintf("Model version: %s\n", runOutput.version_tag);
    fprintf("Run number:    %02d\n", runOutput.run_number);
    fprintf("Fixed TIT:     %.2f K\n", fixedTIT_K);
    fprintf("Data folder:   %s\n", runOutput.data_folder);
    fprintf("Figure folder: %s\n\n", runOutput.figure_folder);

    %% Save exact study configuration
    configurationPath = fullfile( ...
        runOutput.data_folder, ...
        "configuration_" + fileSuffix + ".mat");

    save( ...
        configurationPath, ...
        "cfgBase", ...
        "bleedFractions", ...
        "fixedTIT_K", ...
        "caseTag", ...
        "runOutput");

    %% Preallocate outputs
    bleedPercent = ...
        100 * bleedFractions(:);

    coolingFlow_kg_s = ...
        zeros(numberOfCases, 1);

    mixerPressureRecovery = ...
        zeros(numberOfCases, 1);

    mixerPressureLoss_percent = ...
        zeros(numberOfCases, 1);

    netThrust_kN = ...
        zeros(numberOfCases, 1);

    tsfc_g_kN_s = ...
        zeros(numberOfCases, 1);

    fuelFlow_kg_s = ...
        zeros(numberOfCases, 1);

    hptInletTemperature_K = ...
        zeros(numberOfCases, 1);

    hptInletPressure_kPa = ...
        zeros(numberOfCases, 1);

    hptExitTemperature_K = ...
        zeros(numberOfCases, 1);

    hptPressureRatio = ...
        zeros(numberOfCases, 1);

    coreExitVelocity_m_s = ...
        zeros(numberOfCases, 1);

    % Preserve the complete results structure from every sweep point.
    caseResults = ...
        cell(numberOfCases, 1);

    %% Run fixed-TIT cooling-bleed sweep
    for i = 1:numberOfCases
        cfg = cfgBase;

        cfg.cooling.bleed_fraction = ...
            bleedFractions(i);

        results = run_turbofan(cfg);

        caseResults{i} = results;

        coolingFlow_kg_s(i) = ...
            results.mass.mdot_cooling_air_kg_s;

        mixerPressureRecovery(i) = ...
            results.stations.station41.pressure_recovery;

        mixerPressureLoss_percent(i) = ...
            100 * results.stations.station41.pressure_loss_fraction;

        netThrust_kN(i) = ...
            results.performance.net_thrust_N / 1000;

        tsfc_g_kN_s(i) = ...
            results.performance.tsfc_g_kN_s;

        fuelFlow_kg_s(i) = ...
            results.mass.mdot_fuel_kg_s;

        hptInletTemperature_K(i) = ...
            results.stations.station41.Tt_K;

        hptInletPressure_kPa(i) = ...
            results.stations.station41.Pt_Pa / 1000;

        hptExitTemperature_K(i) = ...
            results.stations.station45.Tt_K;

        hptPressureRatio(i) = ...
            results.stations.station45.total_pressure_ratio;

        coreExitVelocity_m_s(i) = ...
            results.stations.station9.velocity_m_s;
    end

    %% Results table
    sweepTable = table( ...
        bleedPercent, ...
        coolingFlow_kg_s, ...
        mixerPressureRecovery, ...
        mixerPressureLoss_percent, ...
        netThrust_kN, ...
        tsfc_g_kN_s, ...
        fuelFlow_kg_s, ...
        hptInletTemperature_K, ...
        hptInletPressure_kPa, ...
        hptExitTemperature_K, ...
        hptPressureRatio, ...
        coreExitVelocity_m_s, ...
        'VariableNames', { ...
            'Bleed_percent', ...
            'CoolingFlow_kg_s', ...
            'MixerPressureRecovery', ...
            'MixerPressureLoss_percent', ...
            'NetThrust_kN', ...
            'TSFC_g_kN_s', ...
            'FuelFlow_kg_s', ...
            'HPT_Inlet_Tt_K', ...
            'HPT_Inlet_Pt_kPa', ...
            'HPT_Exit_Tt_K', ...
            'HPT_PtOut_PtIn', ...
            'CoreExitVelocity_m_s'});

    disp(sweepTable);

    %% Save CSV results
    csvPath = fullfile( ...
        runOutput.data_folder, ...
        "cooling_bleed_sweep_" + fileSuffix + ".csv");

    writetable(sweepTable, csvPath);

    %% Save complete MATLAB results
    resultsPath = fullfile( ...
        runOutput.data_folder, ...
        "study_results_" + fileSuffix + ".mat");

    save( ...
        resultsPath, ...
        "sweepTable", ...
        "caseResults", ...
        "cfgBase", ...
        "bleedFractions", ...
        "fixedTIT_K", ...
        "caseTag", ...
        "runOutput");

    %% Figure 1: net thrust
    fig = figure("Color", "w");

    plot( ...
        bleedPercent, ...
        netThrust_kN, ...
        "LineWidth", 1.5, ...
        "Marker", "o");

    xlabel("HPT Cooling-Bleed Fraction (%)");
    ylabel("Net Thrust (kN)");
    title("Effect of HPT Cooling Bleed on Net Thrust");
    grid on;

    save_study_figure( ...
        fig, ...
        runOutput.figure_folder, ...
        "bleed_vs_thrust_" + fileSuffix);

    %% Figure 2: TSFC
    fig = figure("Color", "w");

    plot( ...
        bleedPercent, ...
        tsfc_g_kN_s, ...
        "LineWidth", 1.5, ...
        "Marker", "o");

    xlabel("HPT Cooling-Bleed Fraction (%)");
    ylabel("TSFC (g/(kN·s))");
    title("Effect of HPT Cooling Bleed on TSFC");
    grid on;

    save_study_figure( ...
        fig, ...
        runOutput.figure_folder, ...
        "bleed_vs_TSFC_" + fileSuffix);

    %% Figure 3: HPT inlet temperature
    fig = figure("Color", "w");

    plot( ...
        bleedPercent, ...
        hptInletTemperature_K, ...
        "LineWidth", 1.5, ...
        "Marker", "o");

    xlabel("HPT Cooling-Bleed Fraction (%)");
    ylabel("Mixed HPT Inlet Total Temperature (K)");
    title("Effect of Cooling Bleed on HPT Inlet Temperature");
    grid on;

    save_study_figure( ...
        fig, ...
        runOutput.figure_folder, ...
        "bleed_vs_HPT_temperature_" + fileSuffix);

    %% Figure 4: combined system trade
    fig = figure("Color", "w");

    yyaxis left

    plot( ...
        bleedPercent, ...
        netThrust_kN, ...
        "LineWidth", 1.5, ...
        "Marker", "o");

    ylabel("Net Thrust (kN)");

    yyaxis right

    plot( ...
        bleedPercent, ...
        hptInletTemperature_K, ...
        "LineWidth", 1.5, ...
        "Marker", "s");

    ylabel("Mixed HPT Inlet Total Temperature (K)");

    xlabel("HPT Cooling-Bleed Fraction (%)");
    title("Cooling-Bleed Thermal and Performance Trade");
    grid on;

    save_study_figure( ...
        fig, ...
        runOutput.figure_folder, ...
        "system_trade_" + fileSuffix);

    %% Print saved-file locations
    fprintf("\nSaved output files\n");
    fprintf("--------------------------------------------------\n");
    fprintf("Configuration: %s\n", configurationPath);
    fprintf("Results MAT:   %s\n", resultsPath);
    fprintf("Results CSV:   %s\n", csvPath);
    fprintf("Command log:   %s\n", commandWindowPath);
    fprintf("==================================================\n");
    fprintf("Fixed-TIT cooling-bleed sweep complete\n\n");

    diary off;

catch ME
    fprintf(2, ...
        "\nFixed-TIT sweep failed.\n\n");

    fprintf(2, "%s\n", ...
        getReport(ME, ...
        'extended', ...
        'hyperlinks', ...
        'off'));

    diary off;
    rethrow(ME);
end


function save_study_figure(figHandle, figureFolder, baseName)
%SAVE_STUDY_FIGURE Apply light styling and save PNG + FIG files.

apply_light_figure_style(figHandle);

pngPath = fullfile( ...
    figureFolder, ...
    baseName + ".png");

figPath = fullfile( ...
    figureFolder, ...
    baseName + ".fig");

exportgraphics( ...
    figHandle, ...
    pngPath, ...
    "Resolution", 300, ...
    "BackgroundColor", "white");

savefig( ...
    figHandle, ...
    char(figPath));

end


function apply_light_figure_style(figHandle)
%APPLY_LIGHT_FIGURE_STYLE Force white-background publication style.

figHandle.Color = "w";

axList = findall(figHandle, "Type", "axes");

for i = 1:numel(axList)
    ax = axList(i);

    % White plot area
    ax.Color = "w";

    % Dark axes/ticks
    ax.XColor = "k";
    ax.YColor = "k";

    if isprop(ax, "ZColor")
        ax.ZColor = "k";
    end

    % Titles and labels
    ax.Title.Color = "k";
    ax.XLabel.Color = "k";
    ax.YLabel.Color = "k";

    % If yyaxis is used, force both y-axes dark
    if isprop(ax, "YAxis") && numel(ax.YAxis) > 1
        for j = 1:numel(ax.YAxis)
            ax.YAxis(j).Color = "k";
        end
    end

    % Grid appearance
    ax.GridColor = [0.75 0.75 0.75];
    ax.GridAlpha = 0.35;

    if isprop(ax, "MinorGridColor")
        ax.MinorGridColor = [0.85 0.85 0.85];
    end

    if isprop(ax, "MinorGridAlpha")
        ax.MinorGridAlpha = 0.20;
    end

    ax.Box = "on";
end

% Legends
legendList = findall(figHandle, "Type", "legend");

for i = 1:numel(legendList)
    lgd = legendList(i);
    lgd.TextColor = "k";
    lgd.Color = "w";
    lgd.EdgeColor = [0.25 0.25 0.25];
end

% Any extra text objects
textList = findall(figHandle, "Type", "text");

for i = 1:numel(textList)
    if isprop(textList(i), "Color")
        textList(i).Color = "k";
    end
end

end
