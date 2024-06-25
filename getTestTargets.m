function getTestTargets(diffFile)
    arguments
        diffFile (1,1) string = ""
    end
    % getTestTargets  Return modified test directories
    %
    %   Returns a list of target directories in JSON formatted file
    %   'targets.json' from either a JSON formatted diff file passed as an
    %   argument, or using all valid directory names.
    
    if (diffFile ~= "")
        targets = getDiffTargets(diffFile);
    else
        targets = getAllTargets();
    end
    
    filename = 'targets.json'; 
    fid = fopen(filename, 'w');  
    fprintf(fid, '%s', jsonencode(targets)); 
    fclose(fid);

end


function targets = getDiffTargets(diffFile)
    arguments
        diffFile (1,1) string
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
