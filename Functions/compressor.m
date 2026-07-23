function outlet = compressor(inlet, pressureRatio, efficiency, cp, gamma)
%COMPRESSOR Calculate compressor outlet total conditions and work.
%
% Inputs:
%   inlet         Structure containing Tt_K and Pt_Pa
%   pressureRatio Compressor total-pressure ratio, Pt_out/Pt_in
%   efficiency    Isentropic compressor efficiency
%   cp            Specific heat at constant pressure, J/(kg*K)
%   gamma         Specific heat ratio
%
% Output:
%   outlet        Outlet state and compressor specific work

validateattributes(pressureRatio, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>=', 1});

validateattributes(efficiency, {'numeric'}, ...
    {'scalar', 'real', 'finite', '>', 0, '<=', 1});

% Ideal isentropic outlet temperature
TtIdeal = inlet.Tt_K * ...
    pressureRatio^((gamma - 1) / gamma);

% Actual outlet temperature
TtActual = inlet.Tt_K + ...
    (TtIdeal - inlet.Tt_K) / efficiency;

PtOutlet = inlet.Pt_Pa * pressureRatio;

specificWork = cp * (TtActual - inlet.Tt_K);

outlet.Tt_K = TtActual;
outlet.Pt_Pa = PtOutlet;
outlet.Tt_ideal_K = TtIdeal;
outlet.specific_work_J_kg = specificWork;
outlet.pressure_ratio = pressureRatio;
outlet.isentropic_efficiency = efficiency;

end