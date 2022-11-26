function L = tl_winner2(f, d, h1, h2, env, lostype, variations)
%tl_winner2 computes path loss for path loss according to WINNER II model
%
% Input parameters:
%     f       -   Frequency (GHz) - range [2, 6] GHz
%     d       -   Tx-Rx distance (m) - range [10, 5000] m, dmax = 10 km for
%                 D1 LoS and dmin = 30 m for C1 LoS and 50 m for NLoS
%     h1      -   antenna height of the first terminal (m)
%     h2      -   antenna height of the second terminal (m)
%     env     -   'RURAL', 'SUBURBAN', or 'URBAN'
%     lostype -   flag: 1 = Line of Sight, 2 = Non Line of Sight, 3 = LoS probabilities
%     variations - false: function returns median value of path loss
%                  true:  function returns Gaussian random value of path loss
% Output parameters:
%     L       - path loss (median value for variations = false,
%                          Gaussian random variable for variations = true)


% Numbers refer to Report WINNER II

%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    24NOV22     Ivica Stevanovic, OFCOM         Initial version

L = 0.0;
StdDev = 0.0;

hbs = h1;
hms = h2;

if (h1 < h2)
    hbs = h2;
    hms = h1;
end

fmin = 2;
fmax = 6;


dmin = 10;
dmax = 5000;

hbsmin = 0.0;
hmsmin = 0.0;


if (~strcmp(env, 'RURAL') && ~strcmp(env,'SUBURBAN') && ~strcmp(env,'URBAN'))
    error('The parameter env must be either ''RURAL'', ''SUBURBAN'' or ''URBAN'' ');
end

if (lostype ~=1 && lostype ~=2 && lostype ~=3)
    error('The parameter lostype must be either 1, 2, or 3 designating LoS condition, NLoS condition, or LoS probabilities, respectively.');
end

if ~islogical(variations)
    error('The parameter variations must be boolean true or false.');
end


if (strcmp(env, 'RURAL') && (lostype == 1))
    dmax = 10000;
end

if (strcmp(env, 'RURAL') && (lostype == 2 || lostype == 3))
    dmin = 50;
end

if(strcmp(env, 'SUBURBAN)'))
    if (lostype == 1)
        dmin = 30;
    else % lostype == 2 or 3
        dmin = 50;
    end
end

if (strcmp(env, 'URBAN'))
    if(lostype == 1 || lostype == 3)
        hbsmin = 1;
        hmsmin = 1;
    end
end

if (f < fmin || f > fmax)
    warning(['The chosen model is valid for frequencies in the range [' num2str(fmin) ', ' num2str(fmax)  '] GHz']);
end

if (hbs < hbsmin)

    warning(['The chosen model is valid for base station heights greater than '  num2str(hbsmin) ' m']);

end

if (hms < hmsmin)

    warning(['The chosen model is valid for mobile station heights greater than '  num2str(hmsmin) ' m']);

end

if (d < dmin || d > dmax)
    warning(['The chosen model is valid for distances in the range ['  num2str(dmin)  ', '  num2str(dmax)  '] m']);
end


prob = 1; % probability that the path is LOS

switch (lostype)
    case 2
        prob = 0;

    case 3
        switch (env)
            case 'URBAN'
                prob = min(18.0/d,1.0)*(1-10.^(-d/63.0)) + 10.^(-d/63.0);

            case 'SUBURBAN'
                prob = 10.^(-(d)/200);


            case 'RURAL'

                prob = 10.^(-(d)/1000.0);
        end
end


switch (lostype)
    case 1
        switch (env)
            case 'URBAN'
                [L, StdDev] = winner2_UMa(f, d, hbs, hms, true);


                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end

            case 'SUBURBAN' % SMa
                [L, StdDev] = winner2_SMa(f, d, hbs, hms, true);

                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end
            case 'RURAL'
                [L, StdDev] = winner2_RMa(f, d, hbs, hms, true);

                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end

        end

    case 2
        switch (env)
            case 'URBAN'
                [L, StdDev] = winner2_UMa(f, d, hbs, hms, false);


                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end

            case 'SUBURBAN' % SMa
                [L, StdDev] = winner2_SMa(f, d, hbs, hms, false);

                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end
            case 'RURAL'
                [L, StdDev] = winner2_RMa(f, d, hbs, hms, false);

                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end

        end

    case 3
        switch (env)
            case 'URBAN'
                [L1, StdDev1] = winner2_UMa(f, d, hbs, hms, true);

                [L2, StdDev2] = winner2_UMa(f, d, hbs, hms, false);

                if (variations)
                    std1 = StdDev1 * randn;
                    std2 = StdDev2 * randn;
                    L1 = L1 + std1;
                    L2 = L2 + std2;
                end

                %L = prob*L1 + (1-prob)*L2;
                p_trial = rand;
                if (p_trial < prob)
                    L = L1; %LOS
                else
                    L = L2; %NLOS
                end


            case 'SUBURBAN'
                [L1, StdDev1] = winner2_SMa(f, d, hbs, hms, true);

                [L2, StdDev2] = winner2_SMa(f, d, hbs, hms, false);

                if (variations)
                    std1 = StdDev1 * randn;
                    std2 = StdDev2 * randn;
                    L1 = L1 + std1;
                    L2 = L2 + std2;
                end

                %L = prob*L1 + (1-prob)*L2;
                p_trial = rand;
                if (p_trial < prob)
                    L = L1; %LOS
                else
                    L = L2; %NLOS
                end

            case 'RURAL'
                [L1, StdDev1] = winner2_RMa(f, d, hbs, hms, true);

                [L2, StdDev2] = winner2_RMa(f, d, hbs, hms, false);

                if (variations)
                    std1 = StdDev1 * randn;
                    std2 = StdDev2 * randn;
                    L1 = L1 + std1;
                    L2 = L2 + std2;
                end

                %L = prob*L1 + (1-prob)*L2;
                p_trial = rand;
                if (p_trial < prob)
                    L = L1; %LOS
                else
                    L = L2; %NLOS
                end
        end
end

return
end
