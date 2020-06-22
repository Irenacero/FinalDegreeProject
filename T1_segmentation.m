%This script creates a function called Segmentation with Group as parameter ("1" stands for Controls group and "2" for Patients). This function performs segmentation of the T1-weighted image of each of the subjects using Matlab SPM Segmentation Tool. It separates tissue classes such as grey matter, white matter and cerebrospinal fluid (CSF). 


function Segmentation(G) %define the function

%set 1 as input parameter for Controls group and 2 for Patients group
if G==1 
    Grup='Controls';
elseif G==2
    Grup='Patients';
end


directory=  fullfile('/media/estela/HD_2/Irene/Analysis', Grup); %current working directory

cd(directory); %enter to the working directory

%Take the folders in the directory containing data of subjects. In case of Controls, they start with C, and in case of Patients, with H.
if G==1
    pilots = dir('C*');
    disp(length(pilots));
elseif G==2
    pilots = dir('H*');
end


if G==1 %for Controls
    for k = 1:length(pilots) %for each of the subjects in Controls group
        disp(pilots(k).name) %print the name of the subject
        direct= fullfile(directory, pilots(k).name, 'T1'); %directory where the T1-weighted image of the subject is stored
        cd(direct);
        T1_image_pre = dir(fullfile(direct, 'o*')); %T1-weighted image file (its name in all subjects starts with letter "o")
        T1_image = T1_image_pre(1).name %obtain complete name of the T1-weighted image file
        
        
        matlabbatch{1}.spm.spatial.preproc.channel.vols = {T1_image}; %input image
        matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001; %bias regularisation --> set to light regularisation (0.001)
        matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60; %FWHM of Gaussian smoothness of bias --> 60 mm cutoff selected 
        matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0]; %option to save a bias corrected version of the image. In our case, we do not keep it
        matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,1'}; %Tissue probability image for the first class
        matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0]; %To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,2'}; %Tissue probability image for the second class
        matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0]; %To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,3'};  %Tissue probability image for the third class
        matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];%To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,4'};  %Tissue probability image for the fourth class
        matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];%To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,5'};  %Tissue probability image for the fifth class
        matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];%To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,6'};  %Tissue probability image for the sixth class
        matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;%Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0]; %To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1; %Number of iterations of a simple Markov Random Field run
        matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1; %Set clean up routine to Light Clean
        matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];%Wraping regularisation
        matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni'; %Affine regularisation. We want to do the registration in MNI space, so ICBM space template- European brains is the option that we select
        matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0; %Smoothness. Set to 0mm as we are in MRI.
        matlabbatch{1}.spm.spatial.preproc.warp.samp = 3; %Distance between the sampled points when estimating model parameters
        matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0]; %Deformation fields. In our case we do not use them.
        
        spm_jobman('run',matlabbatch); %Run the job.
        
        
        
       
    end
elseif G==2
    for k = 1:length(pilots) %for all the patients
        disp(pilots(k).name) %print patient name
        direct= fullfile(directory, pilots(k).name, 'T1'); %directory where the input image is stored
        cd(direct);
        T1_image_pre = dir(fullfile(direct, 'o*')); %obtain T1- weighted image file (all names start with "o")
        T1_image = T1_image_pre(1).name %obtain the name of the file of the image
        %T1_image = fullfile(directory, pilots(k).name, 'T1', T1);
        
        
        matlabbatch{1}.spm.spatial.preproc.channel.vols = {T1_image}; %input image
        matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001; %bias regularisation --> set to light regularisation (0.001)
        matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60; %FWHM of Gaussian smoothness of bias --> 60 mm cutoff selected 
        matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0]; %option to save a bias corrected version of the image. In our case, we do not keep it
        matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,1'}; %Tissue probability image for the first class
        matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0]; %To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,2'}; %Tissue probability image for the second class
        matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0]; %To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,3'};  %Tissue probability image for the third class
        matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];%To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,4'};  %Tissue probability image for the fourth class
        matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];%To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,5'};  %Tissue probability image for the fifth class
        matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4; %Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];%To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/home/estela/Desktop/programs/spm12/tpm/TPM.nii,6'};  %Tissue probability image for the sixth class
        matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;%Number of Gaussians used to represent the instensity distribution for each tissue
        matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0]; %To produce a tissue image that is in alignment with the original
        matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0]; %To produce a spatially normalised version of the tissue class. In our case we do not do it.
        matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1; %Number of iterations of a simple Markov Random Field run
        matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1; %Set clean up routine to Light Clean
        matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];%Wraping regularisation
        matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni'; %Affine regularisation. We want to do the registration in MNI space, so ICBM space template- European brains is the option that we select
        matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0; %Smoothness. Set to 0mm as we are in MRI.
        matlabbatch{1}.spm.spatial.preproc.warp.samp = 3; %Distance between the sampled points when estimating model parameters
        matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0]; %Deformation fields. In our case we do not use them.
        
        spm_jobman('run',matlabbatch); %Run the job.
    end
end
