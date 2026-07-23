function eta = calculate_efficiencies( ...
    coreExit, bypassExit, ...
    mdotCoreExhaust, mdotBypass, mdotInletAir, ...
    flightVelocity_m_s, mdotFuel, heatingValue_J_kg, ...
    netThrust_N)
%CALCULATE_EFFICIENCIES Calculate preliminary engine efficiencies.
%
% Thermal efficiency is based on the increase in exhaust kinetic-energy
% rate divided by fuel chemical-energy rate.
%
% Propulsive and overall efficiencies require nonzero flight velocity.
% At static conditions, useful propulsive power F*V0 is zero, so these
% values are returned as NaN rather than displayed misleadingly as zero.

%% Exhaust kinetic-energy rates
coreExitKineticPower_W = ...
    0.5 * mdotCoreExhaust * coreExit.velocity_m_s^2;

bypassExitKineticPower_W = ...
    0.5 * mdotBypass * bypassExit.velocity_m_s^2;

inletKineticPower_W = ...
    0.5 * mdotInletAir * flightVelocity_m_s^2;

jetKineticPower_W = ...
    coreExitKineticPower_W ...
    + bypassExitKineticPower_W ...
    - inletKineticPower_W;

fuelChemicalPower_W = ...
    mdotFuel * heatingValue_J_kg;

if jetKineticPower_W <= 0
    error("Calculated jet kinetic-power increase is nonpositive.");
end

if fuelChemicalPower_W <= 0
    error("Calculated fuel chemical power is nonpositive.");
end

thermalEfficiency = ...
    jetKineticPower_W / fuelChemicalPower_W;

thrustPower_W = ...
    netThrust_N * flightVelocity_m_s;

isStatic = abs(flightVelocity_m_s) < 1e-8;

if isStatic
    propulsiveEfficiency = NaN;
    overallEfficiency = NaN;
else
    propulsiveEfficiency = ...
        thrustPower_W / jetKineticPower_W;

    overallEfficiency = ...
        thrustPower_W / fuelChemicalPower_W;
end

%% Package results
eta.core_exit_kinetic_power_W = ...
    coreExitKineticPower_W;

eta.bypass_exit_kinetic_power_W = ...
    bypassExitKineticPower_W;

eta.inlet_kinetic_power_W = ...
    inletKineticPower_W;

eta.jet_kinetic_power_W = ...
    jetKineticPower_W;

eta.fuel_chemical_power_W = ...
    fuelChemicalPower_W;

eta.thrust_power_W = ...
    thrustPower_W;

eta.kinetic_thermal = thermalEfficiency;

% Legacy alias retained for compatibility with existing scripts.
eta.thermal = thermalEfficiency;
eta.propulsive = propulsiveEfficiency;
eta.overall = overallEfficiency;
eta.is_static_condition = isStatic;

end