%% Script for plotting response and calculating power
close all
clear power power_eff 

%% Plot waves
waves.plotEta(simu.rampTime);
hold on
plot([25 25],[1.5*min(waves.waveAmpTime(:,2)),1.5*max(waves.waveAmpTime(:,2))])
legend('\eta','rampTime','powerCalcTime')
try 
    waves.plotSpectrum();
catch
end
xlim([0 inf])

%% Plot RY response for Float
output.plotResponse(1,5);   
xlim([0 inf])

%% Plot RY forces for Float
plotForces(output,1,5)
xlim([0 inf])

%% Calculate and Plot Power 
            ii = find(Output_power.time==25);   
            t = Output_power.time(ii:end);
            t_end = round( t( end ) / 5 )*5;
            p = Output_power.signals.values(ii:end);
            u = cmd_ptoM.signals.values(ii:end);
            energy_gen = Output_energy.signals.values(ii:end);
            mp = mean( p );
            mp_s = num2str( mp );
            E_extr = num2str( energy_gen(end) );
            min_power = min(p);
            max_power = max(p);
            estimated_excMoment = squeeze(estimated_states.signals.values(5,1,:));
            estimated_armposition = squeeze(estimated_states.signals.values(1,1,:));
            estimated_armvelocity = squeeze(estimated_states.signals.values(2,1,:)); 
            
            
            switch(controllerType)
                case 1
                    Cont = ['Resistive(', num2str(prop_gain),')'];
                    txtEnergy = [ ' Resistive, ','  prop gain = ', num2str(prop_gain), '   SS = ', num2str(SeaState),'  Energy Extracted = ',  E_extr, ' J'];
                    txtPower = [ 'Resistive  ', 'Mean Power = ', mp_s, ' w,','  Energy Extracted = ',  E_extr, ' J,  ',' Prop. Gain = ', num2str(prop_gain)];
                case 2
                    Cont = 'NMPC';
                    txtEnergy = [ ' NMPC, Np = ', num2str(Np), '      SS = ', num2str(SeaState),'  Energy Extracted = ',  E_extr, ' J'];
                    txtPower = [ ' NMPC ', '   Mean Power = ', mp_s, ' w,','  Energy Extracted = ',  E_extr, ' J, ', ' Np = ', num2str(Np)];
            end 
            fprintf('\nSimulation for Sea State %d, run with a %s controller,\nExtracted Energy: %5.2f [J] with mean power %5.2f [mW].\n',SeaState,Cont,energy_gen(end),1000*mp)
            fig1    = figure('Name','Energy extracted using different control strategies','Units','Normalized','OuterPosition',[0 0 1 1],'DefaultAxesFontSize',18);
            fig2    = figure('Name','Control Input and Power','Units','Normalized','OuterPosition',[0 0 1 1],'DefaultAxesFontSize',14);
            
            % Energy
            figure(fig1)
                lyl = 0;      %lower y limit
                uyl = energy_gen(end)+2;      %upper y limit
                plot( t, energy_gen,'-bo', 'MarkerIndices', length(t), 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','b', 'MarkerFaceColor', 'b');   
                hold on; grid on; grid minor
                xlabel('Time [s]')
                ylabel( 'Energy [J]' ); 
                xlim([20 t_end+5])
                ylim( [ lyl uyl ] )
                xticks( 0 : 10 : t_end + 5 )
                yticks( lyl : 10 : uyl )
                set(gca, 'LooseInset', [ 0, 0, 0, 0 ] );
                txt = [num2str(round(energy_gen(end),1)),' J'];     text(t(end)*0.96,0.95*energy_gen(end),txt,'Color','black','FontSize',18)
                txt1 = ['Mean Power NMPC = ', mp_s, ' [w]'];
                text(40,(uyl-10),txt1,'Color','blue','FontSize',18,'EdgeColor', 'blue','LineWidth',2, 'Margin', 10);
            
            % Control and instantaneous power
            tL = tiledlayout(fig2,2,1,'TileSpacing','compact','TileIndexing','rowmajor');
            nexttile(tL,1)
                stairs( t, u,'-b','LineWidth',1); hold on; grid on; 
                ylabel('Control input [Nm]');                                                                               
                ylim([-15 15]);
                xlim([20 t_end+5])
                yticks([-15,-12,-10,-5,0,5,10,12,15]);       
                yticklabels({'-15','-12', '-10', '-5', '0', '5', '10', '12','15' })
                plot( [ t(1), t(end) ], 12*[ 1, 1 ], 'r--', 'LineWidth', 1 );
                plot( [ t(1), t(end) ], -12*[ 1, 1 ], 'r--', 'LineWidth', 1 ); 
                title( "pto Moment", FontSize=16 );

            nexttile(tL,2)
                plot( t, p,'-b','LineWidth',1); hold on; grid on; 
                plot( [ t(1), t( end ) ], mp*[ 1, 1 ], 'r--', 'LineWidth', 2 ); hold on;  
                xlabel('Time [s]')
                ylabel( 'Power [w]' ); 
                ylim([-0.1 2]);
                xlim([20 t_end+5])
                title( txtPower, FontSize=16);
            %% Calculate Evaluation Criteria (EC)
            pto_force = cmd_force.signals.values(ii:end);
            pto_displacement = motor_displacement.signals.values(ii:end);
            f_98 = prctile(abs(pto_force),98);
            f_max = 60;
            z_98 = prctile(abs(pto_displacement),98);
            z_max = 0.08;
            power_average = mean(p);
            power_abs_average = mean(abs(p));
            P98 = prctile(abs(p),98);
            EC = power_average/(2 + f_98/f_max + z_98/z_max - power_abs_average/P98);
            fprintf('\nEC = %5.2f with a mean power %5.2f.\n',EC*1000,1000*power_average);
            %%
            clear estimated_armvelocity estimated_excMoment estimated_armposition energy_gen fig1 fig2