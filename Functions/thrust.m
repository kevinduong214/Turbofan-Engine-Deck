function performance = thrust( ...
    coreExit, bypassExit, ...
    mdotCoreExhaust, mdotBypass, mdotInletAir, ...
    flightVelocity_m_s, mdotFuel)
%THRUST Calculate separate-flow turbofan net thrust and TSFC.
%
% Net thrust:
%
% F = mdot_core*Ve_core + mdot_bypass*Ve_bypass
%     - mdot_inlet*V0
%     + pressure thrust
%
% Fuel is included in the core exhaust mass flow but is not included in
% the incoming freestream air momentum.

coreMomentum_N = ...
    mdotCoreExhaust * coreExit.velocity_m_s;

bypassMomentum_N = ...
    mdotBypass * bypassExit.velocity_m_s;

inletMomentum_N = ...
    mdotInletAir * flightVelocity_m_s;

corePressureThrust_N = ...
    coreExit.pressure_thrust_N;

bypassPressureThrust_N = ...
    bypassExit.pressure_thrust_N;

coreNetThrust_N = ...
    coreMomentum_N ...
    - (mdotInletAir - mdotBypass) * flightVelocity_m_s ...
    + corePressureThrust_N;

bypassNetThrust_N = ...
    bypassMomentum_N ...
    - mdotBypass * flightVelocity_m_s ...
    + bypassPressureThrust_N;

netThrust_N = ...
    coreNetThrust_N + bypassNetThrust_N;

if netThrust_N <= 0
    error("Calculated net thrust is nonpositive.");
end

specificThrust_N_per_kg_s = ...
    netThrust_N / mdotInletAir;

tsfc_kg_N_s = ...
    mdotFuel / netThrust_N;

% Useful conventional reporting unit
tsfc_g_kN_s = ...
    tsfc_kg_N_s * 1e6;

performance.core_momentum_N = coreMomentum_N;
performance.bypass_momentum_N = bypassMomentum_N;
performance.inlet_momentum_N = inletMomentum_N;

performance.core_pressure_thrust_N = corePressureThrust_N;
performance.bypass_pressure_thrust_N = bypassPressureThrust_N;

performance.core_net_thrust_N = coreNetThrust_N;
performance.bypass_net_thrust_N = bypassNetThrust_N;
performance.net_thrust_N = netThrust_N;

performance.specific_thrust_N_per_kg_s = ...
    specificThrust_N_per_kg_s;

performance.tsfc_kg_N_s = tsfc_kg_N_s;
performance.tsfc_g_kN_s = tsfc_g_kN_s;

end