function Pmean_W = get_mean_pto_power(output, simu)


    rampTime = 0;

    if isstruct(simu)
        if isfield(simu, 'rampTime')
            rampTime = simu.rampTime;
        end
    else
        if isprop(simu, 'rampTime')
            rampTime = simu.rampTime;
        end
    end



    ptoOutput = [];

    if isstruct(output)

        if isfield(output, 'ptos')
            ptoOutput = output.ptos;
        elseif isfield(output, 'pto')
            ptoOutput = output.pto;
        end

    else

        if isprop(output, 'ptos')
            ptoOutput = output.ptos;
        elseif isprop(output, 'pto')
            ptoOutput = output.pto;
        end

    end


    

    if isempty(ptoOutput)

        fprintf('\nCould not find PTO output.\n')

        if isstruct(output)
            fprintf('output is a struct. Available fields are:\n')
            disp(fieldnames(output))
        else
            fprintf('output is an object. Available properties are:\n')
            disp(properties(output))
        end

        error('Could not find output.ptos or output.pto.')

    end


    % If multiple PTOs exist, use the first one
    if numel(ptoOutput) > 1
        ptoOutput = ptoOutput(1);
    end


    

    time = [];

    if isstruct(ptoOutput)

        if isfield(ptoOutput, 'time')
            time = ptoOutput.time;
        end

    else

        if isprop(ptoOutput, 'time')
            time = ptoOutput.time;
        end

    end


    % If PTO time not found, try wave/body output
    if isempty(time)

        if isstruct(output)

            if isfield(output, 'wave') && isfield(output.wave, 'time')
                time = output.wave.time;
            elseif isfield(output, 'bodies') && isfield(output.bodies(1), 'time')
                time = output.bodies(1).time;
            end

        else

            if isprop(output, 'wave')
                if isprop(output.wave, 'time')
                    time = output.wave.time;
                end
            end

            if isempty(time) && isprop(output, 'bodies')
                if isprop(output.bodies(1), 'time')
                    time = output.bodies(1).time;
                end
            end

        end

    end


    if isempty(time)
        fprintf('\nCould not find time vector.\n')
        print_available(ptoOutput, 'ptoOutput')
        error('Could not find time vector in PTO, wave, or body output.')
    end


   
    power = [];

    possiblePowerFields = { ...
        'powerInternalMechanics', ...
        'power', ...
        'powerPTO', ...
        'powerTakeOff', ...
        'ptoPower' ...
    };

    for k = 1:length(possiblePowerFields)

        fieldName = possiblePowerFields{k};

        if has_field_or_property(ptoOutput, fieldName)
            power = get_field_or_property(ptoOutput, fieldName);
            break
        end

    end


    

    if isempty(power)

        force = [];
        velocity = [];

        possibleForceFields = { ...
            'forceTotal', ...
            'forceActuation', ...
            'forceInternalMechanics', ...
            'force', ...
            'ptoForce' ...
        };

        possibleVelocityFields = { ...
            'velocity', ...
            'vel', ...
            'ptoVelocity' ...
        };

        for k = 1:length(possibleForceFields)

            fieldName = possibleForceFields{k};

            if has_field_or_property(ptoOutput, fieldName)
                force = get_field_or_property(ptoOutput, fieldName);
                break
            end

        end

        for k = 1:length(possibleVelocityFields)

            fieldName = possibleVelocityFields{k};

            if has_field_or_property(ptoOutput, fieldName)
                velocity = get_field_or_property(ptoOutput, fieldName);
                break
            end

        end

        if ~isempty(force) && ~isempty(velocity)
            power = force .* velocity;
        end

    end


    

    if isempty(power)

        fprintf('\nCould not find PTO power or force/velocity fields.\n')
        print_available(ptoOutput, 'ptoOutput')

        error('Could not calculate PTO power from available output.')

    end


    power = squeeze(power);
    time = squeeze(time);

    if size(power, 1) ~= length(time) && size(power, 2) == length(time)
        power = power.';
    end


    --

    idx = time >= rampTime;

    if sum(idx) == 0
        idx = true(size(time));
    end


    % Mean absorbed power
   

    Pmean_raw = mean(power(idx), 'omitnan');

    % WEC-Sim sign convention may make absorbed power negative.
    % Use positive absorbed power for optimization.
    Pmean_W = abs(Pmean_raw);

end


% Helper functions


function tf = has_field_or_property(obj, name)

    if isstruct(obj)
        tf = isfield(obj, name);
    else
        tf = isprop(obj, name);
    end

end


function value = get_field_or_property(obj, name)

    if isstruct(obj)
        value = obj.(name);
    else
        value = obj.(name);
    end

end


function print_available(obj, objName)

    if isstruct(obj)
        fprintf('%s is a struct. Available fields are:\n', objName)
        disp(fieldnames(obj))
    else
        fprintf('%s is an object. Available properties are:\n', objName)
        disp(properties(obj))
    end

end