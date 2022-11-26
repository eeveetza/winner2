function [pl, sigma] = winner2_UMa( f, d, hbs, hms, los)
% winner2_UMa computes path loss for urban macro cell
% This function computes path loss according to Winner II model for
% urban macro cell (C2)
% Input parameters:
% f       -   Frequency (GHz)
% d       -   Tx-Rx distance (m)
% hbs     -   base station height (m)
% hms     -   mobile station height (m)
% los     -   flag: true = Line of Sight, false = Non Line of Sight
% Output parameters:
% pl - path loss
% sigma - standard deviation

% Numbers refer to Report IST-4-027756 WINNER II, D1.1.2 V1.2, WINNER II
% Channel Models, Part I Channel Models

%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    24NOV22     Ivica Stevanovic, OFCOM         Initial version

% check the parameter values and issue warnings

sigma = 4.0;
pl = 0.0;

if (hbs <= 0 || hms <= 0)
    error('Antenna heights for WINNER II C2 must be larger than 0 m.');
end

if (f < 2 || f > 6)
    warning('WINNER II C2 model is valid for the frequency range [2, 6] GHz.');
end


if (los == 1)

    % make sure antenna heights are larger than 1 m
    if (hbs <= 1 || hms <= 1)
        error('Antenna heights for WINNER II C2 must be larger than 1 m.');
    end
    % compute the effective antenna heights
    hbs1 = hbs - 1.0;
    hms1 = hms - 1.0;
    % compute the break point

    dbp = 4 * (hbs1) * (hms1) * f * 10.0 / 3.0; % computed accroding to the note 4) in Table 4-4

    if (d < dbp)
        sigma = 4;
        A = 26;
        B = 39;
        C = 20;

        pl = A*log10(d) + B + C*log10(f/5.0);

    else
        sigma = 6;

        pl = 40.0*log10(d) + 13.47 - 14.0*log10(hbs1)-14.0*log10(hms1) + 6.0*log10(f/5.0);

    end

else % NLOS

    sigma = 8;

    pl = (44.9 - 6.55*log10(hbs))*log10(d) + 34.46 + 5.83*log10(hbs) + 23.0*log10(f/5.0);

end


return
end

