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
    
    filename = 'folders.json'; 
    fid = fopen(filename, 'w');  
    fprintf(fid, '%s', jsonencode(targets)); 
    fclose(fid);
    
    products = getProducts(targets);
    include = struct('folder', targets, 'products', products);
    writestruct(include, 'include.json')

end

function products = getProducts(targets)
    arguments
        targets (1,:) cell
    end
    
    arguments (Output)
        products (1, :) cell
    end
    
    function products = loadProductFiles(product_file, file_exists)
        if ~file_exists
            products = "";
            return
        end
        
        fileID = fopen(product_file);
        C = textscan(fileID,'%s');
        fclose(fileID);
        products = strjoin(C{:, 1});
        
    end
    
    product_files = fullfile(targets, "products.txt");
    products = arrayfun(@loadProductFiles,      ...
                        product_files,          ...
                        isfile(product_files),  ...
                        'UniformOutput', 0);

end

function targets = getDiffTargets(diffFile)
    arguments
        diffFile (1,1) string
    end
    
    arguments (Output)
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
    arguments (Output)
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
