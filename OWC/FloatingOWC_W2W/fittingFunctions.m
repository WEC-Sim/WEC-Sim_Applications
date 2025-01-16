function  [psi, etaTurb, phi, piVar] = fittingFunctions()
    % Curve splitting
    psi1 = [0.008, 0.009];
    mu_turb1 = [0, 0.100];
    m1 = (mu_turb1(2) - mu_turb1(1)) / (psi1(2) - psi1(1));
    q1 = mu_turb1(1) - m1 * psi1(1);

    psi2 = [0.009, 0.0128];
    mu_turb2 = [0.100, 0.200];
    m2 = (mu_turb2(2) - mu_turb2(1)) / (psi2(2) - psi2(1));
    q2 = mu_turb2(1) - m2 * psi2(1);

    psi3 = [0.0128, 0.0199];
    mu_turb3 = [0.200, 0.300];
    m3 = (mu_turb3(2) - mu_turb3(1)) / (psi3(2) - psi3(1));
    q3 = mu_turb3(1) - m3 * psi3(1);

    psi4 = [0.0199, 0.0404];
    mu_turb4 = [0.300, 0.500];
    m4 = (mu_turb4(2) - mu_turb4(1)) / (psi4(2) - psi4(1));
    q4 = mu_turb4(1) - m4 * psi4(1);

    psi5 = [0.0404, 0.0634, 0.0878];
    mu_turb5 = [0.500, 0.595, 0.500];
    pp = polyfit(psi5, mu_turb5, 2);

    psi6 = [0.0878, 0.1141];
    mu_turb6 = [0.500, 0.300];
    m6 = (mu_turb6(2) - mu_turb6(1)) / (psi6(2) - psi6(1));
    q6 = mu_turb6(1) - m6 * psi6(1);

    psi7 = [0.1141, 0.1192];
    mu_turb7 = [0.300, 0.273];
    m7 = (mu_turb7(2) - mu_turb7(1)) / (psi7(2) - psi7(1));
    q7 = mu_turb7(1) - m7 * psi7(1);

    psi9 = [0.2122, 0.3];
    mu_turb9 = [0.0016, 0.0];
    m9 = (mu_turb9(2) - mu_turb9(1)) / (psi9(2) - psi9(1));
    q9 = mu_turb9(1) - m9 * psi9(1);

    psi10 = [0.1, 0.114];
    Pi_turb = [0.3156, 0.3170];
    m10 = (Pi_turb(2) - Pi_turb(1)) / (psi10(2) - psi10(1));
    q10 = Pi_turb(1) - m10*psi10(1);

    m = [m1, m2, m3, m4, 0, m6, m7, 0, m9, m10];
    q = [q1, q2, q3, q4, 0, q6, q7, 0, q9, q10];

    % Compute the dimensionless functions
    psi = linspace(-0.3, 0.3, 5000);
    etaTurb = zeros('like',psi);
    phi = zeros('like',psi);
    piVar = zeros('like',psi);

    for ii = 1:length(psi)
        PSI = abs(psi(ii));

        if PSI >= .008 && PSI < 0.009
            ETA_turb = m(1) * PSI + q(1);
        elseif PSI  >= .009 && PSI < 0.0128
            ETA_turb = m(2) * PSI + q(2);
        elseif PSI  >= .0128 && PSI < 0.0199
            ETA_turb = m(3) * PSI + q(3);
        elseif PSI >= .0199 && PSI <= 0.0404
            ETA_turb = m(4) * PSI + q(4);
        elseif PSI > .0404 && PSI < 0.0878
            ETA_turb = pp(1) * PSI^2 + pp(2) * PSI + pp(3);
        elseif PSI >= .0878 && PSI < 0.1141
            ETA_turb = m(6) * PSI + q(6);
        elseif PSI >= .1141 && PSI <= 0.1192
            ETA_turb = m(7) * PSI + q(7);
        elseif PSI >= .1192 && PSI <= 0.2122
            ETA_turb = 200.6*exp(PSI*-55.35);
        elseif PSI > .2122 && PSI <= 0.3
            ETA_turb = m(9) * PSI + q(9);
        else
            ETA_turb = 0;
        end

        etaTurb(ii) = ETA_turb;

    end

    for ii = 1:length(psi)
        PSI = abs(psi(ii));

        if PSI >= 0 && PSI <= 0.1
            PHI = 0.7750*PSI;
        else
            corr = 0.00167;
            PHI = -2.503*PSI^2 + 1.608*PSI - 0.05664 - corr;
        end

        phi(ii) = PHI;

        if PSI > .1 && PSI <= 0.114
            piVar(ii) = (m(10) * PSI + q(10)) / 100;
        else
            piVar(ii) = etaTurb(ii) * PSI * PHI;
        end
    end
end