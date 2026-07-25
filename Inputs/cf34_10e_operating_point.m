function point = cf34_10e_operating_point(pointId)
%CF34_10E_OPERATING_POINT Return one public-data calibration condition.
%
% Usage:
%   point = cf34_10e_operating_point("maximum_takeoff_apr");
%   point = cf34_10e_operating_point("normal_takeoff_edb");
%   point = cf34_10e_operating_point("climb_out_edb");
%   point = cf34_10e_operating_point("approach_edb");
%   point = cf34_10e_operating_point("idle_edb");
%   point = cf34_10e_operating_point("maximum_continuous");
%   point = cf34_10e_operating_point("cruise_holdout");
%
% This function defines external operating conditions and public targets.
% It does not prescribe component pressure ratios, efficiencies, corrected
% flows, spool speeds, fuel schedules, or internal cooling flow.

targets = cf34_10e_multipoint_targets();

pointId = lower(string(pointId));

%% Common defaults
point.id = pointId;
point.engine_variant = targets.metadata.engine_variant;

point.altitude_m = 0;
point.flight_mach = 0;

point.ambient_temperature_override_K = NaN;
point.ambient_pressure_override_Pa = NaN;

point.external_bleed_fraction = 0;
point.accessory_power_extraction_W = 0;

point.target_thrust_N = NaN;
point.target_fuel_flow_kg_s = NaN;
point.target_tsfc_g_kN_s = NaN;

point.power_setting_percent_Foo = NaN;
point.calibration_role = "";
point.ambient_basis = "";
point.source = "";
point.notes = "";

%% Public operating points
switch pointId
    case "maximum_takeoff_apr"
        point.name = ...
            "Maximum takeoff with APR";

        point.target_thrust_N = ...
            targets.ratings.maximum_takeoff_apr.thrust_N;

        point.calibration_role = ...
            "Inherited v0.5 design-point calibration";

        point.ambient_basis = ...
            "Sea-level ISA reference condition";

        point.source = ...
            "EASA TCDS / GE public rating";

        point.notes = ...
            "Flat-rated through 303.15 K; the initial reference run uses ISA sea level.";

    case "normal_takeoff_edb"
        point.name = ...
            "ICAO EDB normal takeoff";

        point.power_setting_percent_Foo = 100;

        point.target_thrust_N = ...
            targets.edb.primary.points.Thrust_N(1);

        point.target_fuel_flow_kg_s = ...
            targets.edb.primary.points.FuelFlow_kg_s(1);

        point.target_tsfc_g_kN_s = ...
            targets.edb.primary.points.DerivedTSFC_g_kN_s(1);

        point.ambient_temperature_override_K = ...
            mean(targets.edb.primary.ambient_temperature_range_K);

        point.ambient_pressure_override_Pa = ...
            1000 * mean(targets.edb.primary.ambient_pressure_range_kPa);

        point.calibration_role = ...
            "Multi-point calibration";

        point.ambient_basis = ...
            "Midpoint of reported EDB test-condition range";

        point.source = ...
            "ICAO EDB UID " + targets.edb.primary.uid;

        point.notes = ...
            "Zero customer bleed and zero accessory power extraction.";

    case "climb_out_edb"
        point.name = ...
            "ICAO EDB climb-out";

        point.power_setting_percent_Foo = 85;

        point.target_thrust_N = ...
            targets.edb.primary.points.Thrust_N(2);

        point.target_fuel_flow_kg_s = ...
            targets.edb.primary.points.FuelFlow_kg_s(2);

        point.target_tsfc_g_kN_s = ...
            targets.edb.primary.points.DerivedTSFC_g_kN_s(2);

        point.ambient_temperature_override_K = ...
            mean(targets.edb.primary.ambient_temperature_range_K);

        point.ambient_pressure_override_Pa = ...
            1000 * mean(targets.edb.primary.ambient_pressure_range_kPa);

        point.calibration_role = ...
            "Multi-point calibration";

        point.ambient_basis = ...
            "Midpoint of reported EDB test-condition range";

        point.source = ...
            "ICAO EDB UID " + targets.edb.primary.uid;

        point.notes = ...
            "Thrust is derived from 85 percent of rated Foo.";

    case "approach_edb"
        point.name = ...
            "ICAO EDB approach";

        point.power_setting_percent_Foo = 30;

        point.target_thrust_N = ...
            targets.edb.primary.points.Thrust_N(3);

        point.target_fuel_flow_kg_s = ...
            targets.edb.primary.points.FuelFlow_kg_s(3);

        point.target_tsfc_g_kN_s = ...
            targets.edb.primary.points.DerivedTSFC_g_kN_s(3);

        point.ambient_temperature_override_K = ...
            mean(targets.edb.primary.ambient_temperature_range_K);

        point.ambient_pressure_override_Pa = ...
            1000 * mean(targets.edb.primary.ambient_pressure_range_kPa);

        point.calibration_role = ...
            "Multi-point calibration";

        point.ambient_basis = ...
            "Midpoint of reported EDB test-condition range";

        point.source = ...
            "ICAO EDB UID " + targets.edb.primary.uid;

        point.notes = ...
            "Thrust is derived from 30 percent of rated Foo.";

    case "idle_edb"
        point.name = ...
            "ICAO EDB idle";

        point.power_setting_percent_Foo = 7;

        point.target_thrust_N = ...
            targets.edb.primary.points.Thrust_N(4);

        point.target_fuel_flow_kg_s = ...
            targets.edb.primary.points.FuelFlow_kg_s(4);

        point.target_tsfc_g_kN_s = ...
            targets.edb.primary.points.DerivedTSFC_g_kN_s(4);

        point.ambient_temperature_override_K = ...
            mean(targets.edb.primary.ambient_temperature_range_K);

        point.ambient_pressure_override_Pa = ...
            1000 * mean(targets.edb.primary.ambient_pressure_range_kPa);

        point.calibration_role = ...
            "Hold-out validation";

        point.ambient_basis = ...
            "Midpoint of reported EDB test-condition range";

        point.source = ...
            "ICAO EDB UID " + targets.edb.primary.uid;

        point.notes = ...
            "Thrust is derived from 7 percent of rated Foo.";

    case "maximum_continuous"
        point.name = ...
            "Maximum continuous";

        point.target_thrust_N = ...
            targets.ratings.maximum_continuous.thrust_N;

        point.calibration_role = ...
            "Hold-out validation";

        point.ambient_basis = ...
            "Sea-level ISA reference condition";

        point.source = ...
            "EASA TCDS public rating";

        point.notes = ...
            "Flat-rated through 298.15 K; initial reference run uses ISA sea level.";

    case "cruise_holdout"
        point.name = ...
            "Maximum cruise SFC hold-out";

        point.altitude_m = ...
            targets.cruise.altitude_m;

        point.flight_mach = ...
            targets.cruise.flight_mach;

        point.target_tsfc_g_kN_s = ...
            targets.cruise.tsfc_g_kN_s;

        point.calibration_role = ...
            "Hold-out validation";

        point.ambient_basis = ...
            "ISA atmosphere at reported altitude";

        point.source = ...
            targets.cruise.pedigree;

        point.notes = ...
            "Do not use for fitting until off-design matching is operational.";

    otherwise
        error( ...
            "Unknown CF34-10E operating-point ID: %s", ...
            pointId);
end

end
