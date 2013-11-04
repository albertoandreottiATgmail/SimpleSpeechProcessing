%Max normalization - move the range of the signal to the [-1, 1] range
%TODO: DC removal.
function normalized = normalizeMax(samples)
    
	[vals, ~] = sort(samples);
	%Take the average of the top 5
	k = 5;
    normalized = samples/mean(vals(end-k:end));	

end