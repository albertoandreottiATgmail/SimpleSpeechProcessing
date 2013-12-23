%Creates an options object for choosing which features to extract

function options = featureopt(varargin)

	if mod(length(varargin), 2)
	    error('Call featureopt with a list of key/value pairs such as featureopt(key1, val1, ..., keyN, valN)');
    end
	
	%TODO: add specific parameter check
    for i = 1:2:length(varargin)
        if  strcmp(varargin{i}, 'pitch') && isbool(varargin{i+1})
		    options.pitch = false;
		end
		options.(varargin{i}) = varargin{i+1};
    end

end