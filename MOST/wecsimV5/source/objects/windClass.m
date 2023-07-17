%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2023 MOREnergy Lab
% 
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

classdef windClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``windClass`` creates a ``wind`` object saved to the MATLAB
    % workspace. The ``windClass`` includes properties and methods used
    % to define MOST's wind input. 
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'public', GetAccess = 'public')%input file
        windTable = '';                           % Wind table of turbulent wind from Turbsim
        constantWindFlag = 0;                     % Choice of constant wind (constantWindFlag=1) or turbulent wind (constantWindFlag=0).
        V0               = 0;                     % Average wind speed
        type             = '';                    % Type of wind conditions. Can be 'constant' or 'turbulent'
    end

    properties (SetAccess = 'private', GetAccess = 'public')%internal
        % The following properties are private, for internal use by MOST
        spatialDiscrU    = [];                    % Wind speed from look-up table.
        zDiscr           = [];                    % Z discretisation from look-up table.
        yDiscr           = [];                    % Y discretisation from look-up table.
        time             = [];                    % time discretisation from look-up table.
    end

    methods (Access = 'public')
        function obj = windClass(type)
            % This method initializes the ``windClass`` and creates a
            % ``wind`` object.
            %
            % Parameters
            % ------------
            %     type : string
            %         String specifying the wind type, options include:
            %
            %           constant
            %               Constant wind speed
            % 
            %           turbulent
            %               Turbulent wind conditions
            %
            % Returns
            % ------------
            %     wind : obj
            %         windClass object
            % 
            % TODO - this needs to be reversed.
            obj.type = type;
            switch obj.type
                case {'constant'}
                    obj.constantWindFlag = 0;
                case {'turbulent'}
                    obj.constantWindFlag = 1;
            end
        end

        function importWindTable(obj)
            % This method loads the table of wind data and formats it for
            % use in MOST
            data = importdata(obj.windTable);
            obj.spatialDiscrU = data.SpatialDiscrU;
            obj.zDiscr = data.Zdiscr;
            obj.yDiscr = data.Ydiscr;
            obj.time = data.t;
        end
    end
end
