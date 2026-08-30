# CF34-10E v0.6 validation and multipoint feasibility evidence

## Release scope

Version 0.6 is a validated Automatic Power Reserve (APR) design-point
engine deck. The ICAO Engine Emissions Databank (EDB) points are retained
as a bounded diagnostic feasibility study. They are not accepted calibrated
operating points, validated predictions, or reconstructed CF34 control
schedules.

The cycle represents a public-data-calibrated notional CF34-10E-class
engine. It does not claim to reproduce proprietary engine internals.

## Quantity pedigree

- **Externally sourced:** APR and normal-takeoff ratings; UID 10GE133 fuel
  flows, rated BPR/pressure ratio, ambient test ranges, and load settings.
- **Derived:** climb-out and approach thrust targets calculated as 85% and
  30% of the EDB rated thrust Foo.
- **Calculated:** cycle outputs, residuals, effective operating quantities,
  Jacobian diagnostics, and model-derived fixed effective nozzle areas.
- **Assumed:** component efficiencies and losses, cooling fraction,
  combustor exit temperature, APR component pressure-ratio split, and use
  of the EDB ambient-range midpoint.

Public APR BPR/OPR values and UID 10GE133 EDB values have mixed pedigree.
They are not proven to describe identical internal engine states. The APR
maximum-takeoff rating is distinct from the normal-takeoff EDB
configuration.

## APR validation summary

| Quantity | Accepted v0.5 baseline | v0.6 result | Change | Acceptance |
|---|---:|---:|---:|---|
| Net thrust | 90.561525575 kN | 90.561525575 kN | 0 N | within 25 N |
| TSFC | 11.268947855 g/(kN*s) | 11.268947855 g/(kN*s) | 0 | within 0.01 g/(kN*s) |
| Core nozzle area | 0.157305086 m^2 | 0.157305086 m^2 | bit-for-bit unchanged | pass |
| Bypass nozzle area | 0.693714887 m^2 | 0.693714887 m^2 | bit-for-bit unchanged | pass |
| Core nozzle residual | effectively zero | approximately 4.3e-8 kg/s | unchanged numerically | pass |
| Bypass nozzle residual | effectively zero | approximately 8.5e-8 kg/s | unchanged numerically | pass |

## Bounded multistart local feasibility result

Residual sign is model minus target for thrust and fuel flow, and demanded
flow minus fixed-area capacity for each nozzle. All investigated points are
classified as diagnostic, and no exact solution was found within the
retained bounds.

| Diagnostic target | Thrust residual | Fuel residual | Core-nozzle residual | Bypass-nozzle residual | Active bound | Status |
|---|---:|---:|---:|---:|---|---|
| Normal takeoff EDB | -3.891195 kN | +0.020099 kg/s | +0.692600 kg/s | +0.571131 kg/s | combustor exit temperature upper | diagnostic: no exact solution found within bounds |
| Climb-out EDB | -1.358022 kN | +0.009761 kg/s | +0.151527 kg/s | -0.033924 kg/s | combustor exit temperature upper | diagnostic: no exact solution found within bounds |
| Approach EDB | -4.383310 kN | +0.050072 kg/s | +0.545319 kg/s | -14.521379 kg/s | effective bypass ratio upper | diagnostic: no exact solution found within bounds |

All selected diagnostic solutions terminated with a positive solver exit
flag, and their objectives reproduce the squared normalized residual norms.
Every deterministic start retains its termination information and any
expected model-domain evaluation failures. Solver nonconvergence is reported
separately and cannot produce a physical feasibility status.

The method uses five deterministic starts with a local derivative-free
solver. Therefore, “no exact solution found within bounds” reports the result
of this bounded diagnostic; it is not a global mathematical proof that no
root exists elsewhere in the domain.

Idle, maximum-continuous, and cruise remain holdouts and were not used to
tune the model.

## Reproduction

Run from the project root in MATLAB:

```matlab
addpath("Inputs");
addpath("Functions");
addpath("Tests");

test_v06_acceptance;
test_cf34_operating_points;
test_cf34_fixed_nozzle_diagnostics;
test_cf34_multipoint_matcher;

cfg = baseline_engine();
diagnostic = match_cf34_multipoint(cfg);
disp(diagnostic.schedule);
```

## Report-ready limitations statement

The v0.6 deck is validated only at the inherited APR design point. A
bounded reduced-order, steady-state, fixed-nozzle-area multipoint matcher
was used to assess public normal-takeoff, climb-out, and approach targets.
No admissible exact solution was found within the retained bounds by the
bounded multistart local diagnostic. Those points are therefore reported as
diagnostic no-exact-solution results rather than calibrated or validated
predictions. This result is not a global proof of root nonexistence. The
study does not include compressor or turbine maps, spool-speed matching,
surge-margin analysis, transients, CFD, or proprietary control reconstruction.
