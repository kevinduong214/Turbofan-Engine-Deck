function runOutput = create_run_output_folders( ...
    projectRoot, modelVersion)
%CREATE_RUN_OUTPUT_FOLDERS Create matching Data and Figures run folders.
%
% Folder structure:
%
%   Data/v0.4/run_01
%   Figures/v0.4/run_01
%
% The next run number is selected by checking both the Data and Figures
% version folders. This prevents mismatched run numbers.

validateattributes(projectRoot, ...
    {'char', 'string'}, {'nonempty'});

validateattributes(modelVersion, ...
    {'char', 'string'}, {'nonempty'});

projectRoot = string(projectRoot);
versionTag = "v" + string(modelVersion);

%% Model-version folders
dataVersionFolder = fullfile( ...
    projectRoot, ...
    "Data", ...
    versionTag);

figureVersionFolder = fullfile( ...
    projectRoot, ...
    "Figures", ...
    versionTag);

if ~isfolder(dataVersionFolder)
    mkdir(dataVersionFolder);
end

if ~isfolder(figureVersionFolder)
    mkdir(figureVersionFolder);
end

%% Determine next unused run number
dataRunNumbers = ...
    find_existing_run_numbers(dataVersionFolder);

figureRunNumbers = ...
    find_existing_run_numbers(figureVersionFolder);

existingRunNumbers = [
    dataRunNumbers
    figureRunNumbers
];

if isempty(existingRunNumbers)
    runNumber = 1;
else
    runNumber = max(existingRunNumbers) + 1;
end

runFolderName = ...
    string(sprintf("run_%02d", runNumber));

%% Create matching run folders
dataRunFolder = fullfile( ...
    dataVersionFolder, ...
    runFolderName);

figureRunFolder = fullfile( ...
    figureVersionFolder, ...
    runFolderName);

mkdir(dataRunFolder);
mkdir(figureRunFolder);

%% Filename identification tag
fileTag = string(sprintf( ...
    "%s_run%02d", ...
    char(versionTag), ...
    runNumber));

%% Package output information
runOutput.version_tag = versionTag;
runOutput.run_number = runNumber;
runOutput.run_folder_name = runFolderName;
runOutput.file_tag = fileTag;

runOutput.data_version_folder = ...
    dataVersionFolder;

runOutput.figure_version_folder = ...
    figureVersionFolder;

runOutput.data_folder = ...
    dataRunFolder;

runOutput.figure_folder = ...
    figureRunFolder;

end


function runNumbers = find_existing_run_numbers(parentFolder)
%FIND_EXISTING_RUN_NUMBERS Find folders named run_01, run_02, etc.

folderListing = ...
    dir(fullfile(parentFolder, "run_*"));

folderListing = ...
    folderListing([folderListing.isdir]);

runNumbers = [];

for i = 1:numel(folderListing)
    token = regexp( ...
        folderListing(i).name, ...
        '^run_(\d+)$', ...
        'tokens', ...
        'once');

    if ~isempty(token)
        runNumbers(end + 1, 1) = ...
            str2double(token{1}); %#ok<AGROW>
    end
end

end