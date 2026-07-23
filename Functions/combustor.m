function outlet = combustor( ...
    inlet, mdotAir, targetTt_K, pressureRatio, efficiency, ...
    heatingValue_J_kg, cpAir, cpGas)
%COMBUSTOR Calculate fuel flow and combustor exit total conditions.
%
% Energy balance per unit mass of combustor inlet air:
%
% cp_air*Tt_in + eta_b*f*LHV = (1 + f)*cp_gas*Tt_out
%
% Inputs:
%   inlet              Structure containing Tt_K and Pt_Pa
%   mdotAir            Combustor inlet air mass flow, kg/s
%   targetTt_K         Desired combustor exit total temperature, K
%   pressureRatio      Combustor total-pressure ratio, Pt_out/Pt_in
%   efficiency         Combustion efficiency
%   heatingValue_J_kg  Fuel lower heating value, J/kg
%   cpAir              Air specific heat, J/(kg*K)
%   cpGas              Combustion-gas specific heat, J/(kg*K)
%
% Output:
%   outlet             Combustor exit state and fuel-flow results

validateattributes(mdotAir, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'positive'});

validateattributes(targetTt_K, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>', inlet.Tt_K});

validateattributes(pressureRatio, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>', 0, '<=', 1});

validateattributes(efficiency, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>', 0, '<=', 1});

% Fuel-air ratio from steady-flow energy balance
numerator = ...
    cpGas * targetTt_K - cpAir * inlet.Tt_K;

denominator = ...
    efficiency * heatingValue_J_kg - cpGas * targetTt_K;

if denominator <= 0
    error("Invalid combustor energy balance: denominator is nonpositive.");
end

fuelAirRatio = numerator / denominator;

if fuelAirRatio <= 0
    error("Calculated fuel-air ratio is nonpositive.");
end

mdotFuel = fuelAirRatio * mdotAir;
mdotGas = mdotAir + mdotFuel;

outlet.Tt_K = targetTt_K;
outlet.Pt_Pa = pressureRatio * inlet.Pt_Pa;

outlet.fuel_air_ratio = fuelAirRatio;
outlet.mdot_air_kg_s = mdotAir;
outlet.mdot_fuel_kg_s = mdotFuel;
outlet.mdot_gas_kg_s = mdotGas;

outlet.pressure_ratio = pressureRatio;
outlet.combustion_efficiency = efficiency;

end