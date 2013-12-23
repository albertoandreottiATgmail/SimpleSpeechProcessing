%Basic Speaker Authentication
%Author: Alberto Andreotti.


% Prevent Octave from thinking that this is a function file:
1;

%Train NN with [pitch, formant1, formant2, ..., formantN, cepstrum] feature vector using single speaker frames.
function main()
		
	train = 0;
	extract = 0;

	%Separate some part of the data for cross-validation, don't train on that data.
    load alberto_ds.mat
	begining = size(ds_sp1, 1) - 30;
	cvds_sp1 = ds_sp1(begining: end, :);
	save features.dat ds_sp1 -append
	ds_sp1(end-30:end, :) = [];
			
	%Cross validation dataset.
	begining = size(ds_sp1, 1) - 30;
	cvds_sp1 = ds_sp1(begining: end,:);

	%Train NN. First element probability for female, second one is for male.
	input_layer_size = size(ds_sp1,2);
	hidden_layer_size = 2*size(ds_sp1,2);
	initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
	initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels=3);

	% Unroll parameters
	initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];
	dataSet = [ds_sp1 ; ds_sp2; ds_sp3];
	expected = [zeros(size(ds_sp1,1),1).+1 ; zeros(size(ds_sp2,1),1).+2; zeros(size(ds_sp3,1),1).+3];
	params = trainNN(initial_nn_params, hidden_layer_size, dataSet, expected, 3);
	
	%Predictions on cross validation data.
	save params.dat params
	
	input_layer_size = size(ds_sp1,2);
	hidden_layer_size = 2*size(ds_sp1,2);
	% Obtain Theta1 and Theta2 back from nn_params
	Theta1 = reshape(params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

	Theta2 = reshape(params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels=3, (hidden_layer_size + 1));
	
	errors = 0;
    for i=1:size(cvds_sp1,1)
	    Y = predict(Theta1, Theta2, cvds_sp1(i, :));
		%Every frame detected as a man counts as an error.
		errors = errors + (Y!=1);
	end
	fprintf('Errors on class 1 are %f \n', errors);
			
	cvds_size = size(cvds_sp1,1) + size(cvds_sp2,1) + size(cvds_sp3,1);
	fprintf('Accuracy on cross validation set is %f \n', (cvds_size-errors)*100/cvds_size);
end


function plotSpectrogram(mtlb, Fs)
	segmentlen = 100;
	noverlap = 90;
	NFFT = 128;
	[y,f,t,p] = spectrogram(mtlb,segmentlen,noverlap,NFFT,Fs);
	surf(t,f,10*log10(abs(p)),'EdgeColor','none');
	axis xy; axis tight; colormap(jet); view(0,90);
	xlabel('Time');
	ylabel('Frequency (Hz)');
end



