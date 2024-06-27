function getTestTargets(diffFile)
    arguments
        diffFile (1,1) string = ""
    end
    % getTestTargets  Return modified test directories
    %
    %   Returns a list of target directories in JSON formatted file
    %   'folders.json' and a list of required MATLAB products in JSON formatted
    %   file 'products.json'. A JSON formatted diff file can be passed as an
    %   argument, otherwise all valid test directories are returned.
    
    if (diffFile ~= "")
        targets = getDiffTargets(diffFile);
    else
        targets = getAllTargets();
    end
    
    getPackages(targets)
    
    filename = 'targets.json'; 
    fid = fopen(filename, 'w');  
    fprintf(fid, '%s', jsonencode(targets)); 
    fclose(fid);

end

function packages = getPackages(targets)
    arguments
        targets (1,:) cell
    end
    
    for target = targets
        disp(target)
    end

end

function targets = getDiffTargets(diffFile)
    arguments
        diffFile (1,1) string
        targets (1, :) cell
    end
    
    diff = readstruct(diffFile);
    max_filtered = strings(1, length(diff.files));
    i_filtered = 1;
    
    for path = string({diff.files.path})
        
        bits = split(path, "/");
        
        % Ignore top level files
        if isscalar(bits)
            continue
        end
        
        % Ignore directories that start with . or _
        if sum(strncmp(path, [".", "_"], 1))
            continue
        end
        
        max_filtered(i_filtered) = bits(1);
        i_filtered = i_filtered + 1;
    
    end
    
    targets = cellstr(unique(max_filtered(1:i_filtered - 1)));

end

function targets = getAllTargets
    arguments
        targets (1, :) cell
    end
    
    d = dir();
    isub = [d(:).isdir];
    all_folders = {d(isub).name};
    
    max_filtered = strings(1, length(all_folders));
    i_filtered = 1;
    
    for folder = all_folders
        
        % Ignore directories that start with . or _
        if sum(strncmp(folder, [".", "_"], 1))
            continue
        end
        
        max_filtered(i_filtered) = folder;
        i_filtered = i_filtered + 1;
    
    end
    
    targets = cellstr(unique(max_filtered(1:i_filtered - 1)));

end
