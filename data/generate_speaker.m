%Generate feature vectors from local files
%Destination binary file
output_file = "bt.mat";

%Input directory holding the files.
input_dir = "speakers/beto";
options = featureopt('pitch', true, 'formants', 3, 'mfcc', 14, 'delta', true, 'frame', 8.33);

%C = 1(pitch) + 3 (formants) + 14(mfccs) + 14(delta-mfccs) = 32
data = zeros(C = 32, 1);

confirm_recursive_rmdir(0)
cd(input_dir);

a = fileattrib ('wav');
b = fileattrib ('flac');
    
if (a) 
   cd wav;
   files = list("*.wav");
elseif(b)
   cd flac;
   system('sh ~/convToWav.sh')
   files = list("*.wav");
end
    
for j=1:size(files,1)
   
   %Separate some part of the data for cross-validation, don't train on that data.
   ds_sp1 = extractFeatures("wavs/sp1.wav", options);
   data = [data, ds_sp1'];
   
end

cd ../..;
read_size = size(data)
rmdir('temp*', "s");
save("-mat4-binary", filename, "data");