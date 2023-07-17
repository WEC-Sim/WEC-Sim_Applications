%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2023 MOREnergy Lab

% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef windturbineClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``windTurbineClass`` creates a ``wind turbine`` object saved to the MATLAB
    % workspace. The ``windTurbineClass`` includes properties and methods used
    % to define MOST's wind turbine input. 
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'public', GetAccess = 'public') %input file
        name                       = []                      % (`string`) Specifies the windturbine name. 
        control                    = 0;                      % Type of control: 0-->baseline, 1-->ROSCO   
        aeroloadsName              = '';                     % Name of aeroloads file       
        turbineName                = '';                     % Name of file including wind turbine properties  
        roscoName                  = '';                     % Name of file for ROSCO properties
        omega0                     = [];                     % Initial rotor speed
    end
    
    properties (SetAccess = 'private', GetAccess = 'public')
        aeroloads                  = struct(...              % Rotor loads structure
            'FX',                  0, ...                    % Thrust forces look-up table
            'FY',                  [0 0 0], ...              % Tangential forces look-up table
            'MX',                  [0 0 0], ...              % Torque look-up table
            'MY',                  0, ...                    % Bending moments look-up table      
            'SS',                  0, ...                    % Steady states
            'ctrl',                0, ...                    % Control parameters for baseline blade pitch control
            'thetaerr',            0, ...                    % Blade pitch difference with steady-state for look-up table
            'omegaerr',            0, ...                    % Rotor speed difference with steady-state for look-up table
            'V',                   [0 0 0]);                 % Wind speed for look-up table    
        genEff                     = [];                     % Generator efficiency
        geometryFileTower          = '';                     % Tower geometry file
        geometryFileNacelle        = '';                     % Nacelle geometry file
        geometryFileHub            = '';                     % Hub geometry file
        geometryFileBlade          = '';                     % Blade geometry file
        tower                      = struct(...              % Tower structure properties
            'mass',                0, ...                    % Mass of tower
            'inertia',             [0 0 0], ...              % Moments of inertia of tower
            'inertiaProduct',      [0 0 0], ...              % Product of inertia of tower
            'height',              0, ...                    % Height of tower        
            'offset',              0, ...                    % Lower point of tower relative to Sea Water Level
            'centerGravityRel',    [0 0 0]);                 % Center of Gravity relative to tower offset
        nacelle                    = struct(...              % Nacelle structure properties
            'mass',                0, ...                    % Mass of nacelle
            'inertia',             [0 0 0], ...              % Moments of inertia of nacelle
            'inertiaProduct',      [0 0 0], ...              % Product of inertia of nacelle
            'reference',           [0 0 0], ...              % Nacelle reference point for hub
            'tiltangle',           [0 0 0], ...              % Tilt angle of nacelle (deg)
            'centerGravityRel',    [0 0 0]);                 % Center of Gravity relative to tower top
        hub                        = struct(...              % Hub structure properties
            'mass',                0, ...                    % Mass of hub             
            'inertia',             [0 0 0], ...              % Moments of inertia of hub
            'inertiaProduct',      [0 0 0], ...              % Product of inertia of hub
            'reference',           [0 0 0], ...              % Hub reference point for blades
            'precone',             [0 0 0], ...              % Hub precone angle (deg)
            'hubheight',           [0 0 0], ...              % Hub height relative to Sea Water Level
            'centerGravityRel',    [0 0 0]);                 % Center of Gravity relative to nacelle reference
        blade                      = struct(...              % Blade structure properties
           'mass',                 0, ...                    % Mass of the blade 
           'inertia',              [0 0 0], ...              % Moments of inertia of the blade  
           'inertiaProduct',       [0 0 0], ...              % Product of inertia of blade                    
           'bladediscr',           [0 0 0], ...              % Blade discretisation for wind speed average estimation 
           'centerGravityRel',     [0 0 0]);                 % Center of Gravity relative to blade root position
        number                     = [];                     % Wind turbine number
        ROSCO                      = struct();               % ROSCO parameters
    end
    
    methods (Access = 'public')
        
        function obj = windturbineClass(name)
            % This method initializes the ``windturbineClass`` and creates a
            % ``windturbine`` object.          
            %
            % Parameters
            % ------------
            %     filename : string
            %         String specifying the name of the constraint
            %
            % Returns
            % ------------
            %     windTurbine : obj
            %         windTurbineClass object         
            %
            if exist('name','var')
                obj.name = name;
            else
                error('The windTurbineclass() function should be initialized with a name.')
            end
        end
        function importAeroloadsTable(obj)
            data = importdata(obj.aeroloadsName);
            obj.aeroloads = data;
        end

        function importROSCO(obj)
            data = importdata(obj.roscoName);
            obj.ROSCO = data;
        end

        function loadTurbineData(obj)
            % This methods load turbine data into the windTurbineClass
            data = importdata(obj.turbineName); 
            obj.genEff = data.gen_eff; % generator efficiency
            obj.geometryFileTower = data.geometryFileTower;
            obj.geometryFileNacelle = data.geometryFileNacelle;
            obj.geometryFileHub = data.geometryFileHub;
            obj.geometryFileBlade = data.geometryFileBlade;  
            obj.tower.mass = data.tower.mass;
            obj.tower.inertia = data.tower.Inertia;
            obj.tower.inertiaProduct = data.tower.InertiaProduct;
            obj.tower.centerGravityRel = data.tower.cog_rel;    
            obj.tower.height = data.tower.height;
            obj.tower.offset = data.tower.offset;
            obj.nacelle.mass = data.nacelle.mass;
            obj.nacelle.inertia = data.nacelle.Inertia;
            obj.nacelle.inertiaProduct = data.nacelle.InertiaProduct;
            obj.nacelle.centerGravityRel = data.nacelle.cog_rel;   
            obj.nacelle.Twr2Shft = data.nacelle.Twr2Shft;
            obj.hub.overhang = data.hub.overhang;
            obj.nacelle.mass_yawBearing = data.nacelle.mass_yawBearing;
            obj.nacelle.reference = data.nacelle.reference;
            obj.nacelle.tiltangle = data.nacelle.tiltangle;
            obj.hub.mass = data.hub.mass;
            obj.hub.inertia = data.hub.Inertia;
            obj.hub.inertiaProduct = data.hub.InertiaProduct;
            obj.hub.centerGravityRel = data.hub.cog_rel;  
            obj.hub.reference = data.hub.reference;
            obj.hub.height = data.hub.height;
            obj.hub.radiusHub = data.hub.Rhub;
            obj.hub.precone = data.hub.precone;
            obj.blade.mass = data.blade.mass;
            obj.blade.inertia = data.blade.Inertia;
            obj.blade.inertiaProduct = data.blade.InertiaProduct;
            obj.blade.centerGravityRel = data.blade.cog_rel; 
            obj.blade.bladeDiscr = data.blade.bladediscr;
         end

         function setNumber(obj,number)
            % Method to set the private number property
            obj.number = number;
         end   
    end
end
