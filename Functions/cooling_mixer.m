function outlet = cooling_mixer( ...
    hotInlet, mdotHot, coolantInlet, mdotCoolant, ...
    coolingFraction, lossCoefficient, cpHot, cpCoolant)
%COOLING_MIXER Mix combustor gas with HPC bleed air before the HPT.
%
% Mixed temperature is calculated from a steady-flow enthalpy balance.
%
% Mixer total-pressure loss is represented using:
%
%   delta_Pt / Pt = K_mix * beta_cool^2
%
% This provides a smooth pressure-loss transition from zero bleed.

%% Input validation
validateattributes(mdotHot, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'positive'});

validateattributes(mdotCoolant, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'nonnegative'});

validateattributes(coolingFraction, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>=', 0, '<', 1});

validateattributes(lossCoefficient, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'nonnegative'});

validateattributes(cpHot, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'positive'});

validateattributes(cpCoolant, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'positive'});

%% Cooling-fraction consistency check
mdotOriginalCoreAir = ...
    hotInlet.mdot_air_kg_s + mdotCoolant;

calculatedCoolingFraction = ...
    mdotCoolant / mdotOriginalCoreAir;

fractionTolerance = 1e-10;

if abs( ...
        calculatedCoolingFraction - coolingFraction) ...
        > fractionTolerance

    error( ...
        "Cooling fraction is inconsistent with the supplied mass flows.");
end

%% Verify that coolant can be injected
if mdotCoolant > 0 && coolantInlet.Pt_Pa <= hotInlet.Pt_Pa
    error( ...
        "Coolant supply total pressure must exceed " + ...
        "the hot-gas total pressure.");
end

%% Mixed mass flow
mdotMixed = mdotHot + mdotCoolant;

%% Energy balance
enthalpyRateHot_W = ...
    mdotHot * cpHot * hotInlet.Tt_K;

enthalpyRateCoolant_W = ...
    mdotCoolant * cpCoolant * coolantInlet.Tt_K;

enthalpyRateIn_W = ...
    enthalpyRateHot_W + enthalpyRateCoolant_W;

% Mixture is represented using the hot-gas specific heat.
TtMixed_K = ...
    enthalpyRateIn_W / (mdotMixed * cpHot);

%% Smooth mixer pressure loss
mixingLossFraction = ...
    lossCoefficient * coolingFraction^2;

if mixingLossFraction >= 1
    error("Cooling-mixer pressure loss is nonphysical.");
end

pressureRecovery = ...
    1 - mixingLossFraction;

PtMixed_Pa = ...
    hotInlet.Pt_Pa * pressureRecovery;

%% Energy residual
enthalpyRateOut_W = ...
    mdotMixed * cpHot * TtMixed_K;

energyResidual_W = ...
    enthalpyRateOut_W - enthalpyRateIn_W;

%% Package results
outlet.Tt_K = TtMixed_K;
outlet.Pt_Pa = PtMixed_Pa;

outlet.mdot_hot_kg_s = mdotHot;
outlet.mdot_coolant_kg_s = mdotCoolant;
outlet.mdot_mixed_kg_s = mdotMixed;

outlet.cooling_fraction = coolingFraction;
outlet.loss_coefficient = lossCoefficient;
outlet.pressure_loss_fraction = mixingLossFraction;
outlet.pressure_recovery = pressureRecovery;

outlet.energy_residual_W = energyResidual_W;

end