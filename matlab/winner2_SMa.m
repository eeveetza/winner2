function [pl, sigma] = winner2_SMa( f, d, hbs, hms, los)
% winner2_SMa computes path loss for suburban macro cell
% This function computes path loss according to Winner II model for
% suburban macro cell (C1)
% Input parameters:
% f       -   Frequency (GHz)
% d       -   Tx-Rx distance (m)
% hbs     -   base station height (m)
% hms     -   mobile station height (m)
% los     -   flag: true = Line of Sight, false = Non Line of Sight
% Output parameters:
%     pl      - path loss
%     sigma   - standard deviation


% Numbers refer to Report IST-4-027756 WINNER II, D1.1.2 V1.2, WINNER II
% Channel Models, Part I Channel Models

%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    24NOV22     Ivica Stevanovic, OFCOM         Initial version

% check the parameter values and issue warnings

sigma = 4;
pl = 0;

if (f < 2 || f > 6)
    warning('WINNER II C1 model is valid for the frequency range [2, 6] GHz.');
end

if (hbs <= 0 || hms <= 0)
    warning('Antenna heights in WINNER II C1 model must be larger than 0 m.');
end


if (los == 1)

    % compute the break point

    dbp = 4 * (hbs) * (hms) * f * 10.0 / 3.0; % computed accroding to the note 6) in Table 4-4

    if (d < dbp)
        sigma = 4;
        A = 23.8;
        B = 41.2;
        C = 20;

        pl = A*log10(d) + B + C*log10(f/5.0);
        
    else

        sigma = 6;

        pl = 40.0*log10(d) + 11.65 - 16.2*log10(hbs)-16.2*log10(hms) + 3.8*log10(f/5.0);

    end

else % NLOS

    sigma = 8;

    pl = (44.9 - 6.55*log10(hbs))*log10(d) + 31.46 + 5.83*log10(hbs) + 23.0*log10(f/5.0);

end


return
end

