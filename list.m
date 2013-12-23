function l = list(folder)
    if isunix()
        l = ls(folder);
	else
        l = dir(folder);
    end
end