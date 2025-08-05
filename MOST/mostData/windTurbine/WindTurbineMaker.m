function WindTurbineMaker()
    %% SETTING
    WindTurbine_type='IEA15MW'; % Choice bestween 'NREL5MW'--'10MW'--'IEA15MW'
    
    %% MAIN 
    cd turbine_properties
    eval(['WTproperties_' WindTurbine_type])
    eval(['BladeData_' WindTurbine_type])
    cd ..
    cd control
    eval(['Steady_States_' WindTurbine_type])
    eval(['Controller_' WindTurbine_type])
    cd ..
    cd aeroloads
    eval(['AeroLoads_' WindTurbine_type])
    cd ..
end
