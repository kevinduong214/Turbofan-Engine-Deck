function outlet = turbine( ...
    inlet, mdotGas, requiredShaftPower_W, ...
    isentropicEfficiency, mechanicalEfficiency, cp, gamma)
%TURBINE Determine turbine exit conditions from shaft-power demand.
%
% Shaft power delivered:
%
% P_shaft = eta_mech * mdot * cp * (Tt_in - Tt_out)
%
% Turbine isentropic efficiency:
%
% eta_t = (Tt_in - Tt_out) / (Tt_in - Tt_out_isentropic)
%
% Inputs:
%   inlet                 Structure containing Tt_K and Pt_Pa
%   mdotGas               Turbine gas mass flow, kg/s
%   requiredShaftPower_W  Required delivered shaft power, W
%   isentropicEfficiency  Turbine isentropic efficiency
%   mechanicalEfficiency Mechanical shaft efficiency
%   cp                    Hot-gas specific heat, J/(kg*K)
%   gamma                 Hot-gas specific heat ratio
%
% Output:
%   outlet                Turbine exit state and performance

validateattributes(mdotGas, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'positive'});

validateattributes(requiredShaftPower_W, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'nonnegative'});

validateattributes(isentropicEfficiency, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>', 0, '<=', 1});

validateattributes(mechanicalEfficiency, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>', 0, '<=', 1});

% Actual gas-path temperature drop needed to deliver shaft power
deltaTActual_K = requiredShaftPower_W / ...
    (mechanicalEfficiency * mdotGas * cp);

TtOutlet_K = inlet.Tt_K - deltaTActual_K;

if TtOutlet_K <= 0
    error("Turbine power demand produces a nonphysical outlet temperature.");
end

% Corresponding isentropic temperature drop
deltaTIsentropic_K = deltaTActual_K / isentropicEfficiency;
TtOutletIsentropic_K = inlet.Tt_K - deltaTIsentropic_K;

if TtOutletIsentropic_K <= 0
    error("Turbine expansion produces a nonphysical isentropic temperature.");
end

% Isentropic total-pressure relation
PtOutlet_Pa = inlet.Pt_Pa * ...
    (TtOutletIsentropic_K / inlet.Tt_K)^(gamma / (gamma - 1));

gasPower_W = mdotGas * cp * deltaTActual_K;
deliveredShaftPower_W = mechanicalEfficiency * gasPower_W;

outlet.Tt_K = TtOutlet_K;
outlet.Pt_Pa = PtOutlet_Pa;
outlet.Tt_ideal_K = TtOutletIsentropic_K;

outlet.temperature_drop_K = deltaTActual_K;
outlet.specific_work_J_kg = cp * deltaTActual_K;
outlet.gas_power_W = gasPower_W;
outlet.shaft_power_W = deliveredShaftPower_W;

outlet.total_pressure_ratio = PtOutlet_Pa / inlet.Pt_Pa;
outlet.isentropic_efficiency = isentropicEfficiency;
outlet.mechanical_efficiency = mechanicalEfficiency;

end