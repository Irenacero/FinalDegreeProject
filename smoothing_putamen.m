%This script includes a function with the group (which can be Controls, 1, or Patients, 2) as parameter, and computes the smoothing of the right and left putamen of each of the subjects in the group. It runs in Matlab SPM. The image we want to smooth needs to be unzipped.

function F_smoothingp_Huntington(G)


%set 1 as input parameter for Controls group and 2 for Patients group
if G==1
    Grup='Controls';
elseif G==2
    Grup='Patients';
end


directory=  fullfile('/media/estela/HD_2/Irene/Analysis', Grup); %current working directory

cd(directory); %enter to the directory

%Take the folders in the directory containing data of subjects. In case of Controls, they start with C, and in case of Patients, with H.
if G==1
    pilots = dir('C*');
    
elseif G==2
    pilots = dir('H*');
end

%In case of Controls
if G==1
    for k = 1:length(pilots) %For all folders with subjects data
        
        disp(pilots(k).name) %print subject name
        cd(fullfile(directory, pilots(k).name)); %enter to the subject's directory
        
      
        left = fullfile(directory,pilots(k).name,'putamen_masks', 'FA_transformation','FA_left_putamen.nii'); %path where the left putamen we want to smooth is stored
        right = fullfile(directory,pilots(k).name,'putamen_masks', 'FA_transformation','FA_right_putamen.nii'); %path where the right putamen we want to smooth is stored
        
        %Perform left putamen smoothing
        matlabbatch{1}.spm.spatial.smooth.data = {left}; %image to smooth
        matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8]; %parameters in mm
        matlabbatch{1}.spm.spatial.smooth.dtype = 0; %data type of the output images --> set as 0 to obtain the same as input images
        matlabbatch{1}.spm.spatial.smooth.im = 0; %implicit masking: set as 0 as we do not want a mask implies by a particular voxel value
        matlabbatch{1}.spm.spatial.smooth.prefix='s'; %output prefix
        
        spm_jobman('run',matlabbatch);  %Run the job
        
        %Perform right putamen smoothing
        matlabbatch{1}.spm.spatial.smooth.data = {right}; %image to smooth
        matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8]; %parameters in mm
        matlabbatch{1}.spm.spatial.smooth.dtype = 0; %data type of the output images --> set as 0 to obtain the same as input images
        matlabbatch{1}.spm.spatial.smooth.im = 0; %implicit masking: set as 0 as we do not want a mask implies by a particular voxel value
        matlabbatch{1}.spm.spatial.smooth.prefix ='s'; %output prefix
        
        spm_jobman('run',matlabbatch);  %Run the job
       
        
       
    end

%In case of Controls
elseif G==2
    for k = 1:length(pilots) %For all folders with subjects data

        disp(pilots(k).name) %print subject name

        left = fullfile(pilots(k).name, 'putamen_masks', 'FA_transformation','FA_left_putamen.nii'); %path where the left putamen we want to smooth is stored
        right = fullfile(pilots(k).name, 'putamen_masks', 'FA_transformation','FA_right_putamen.nii'); %path where the right putamen we want to smooth is stored

        %Perform left putamen smoothing
        matlabbatch{1}.spm.spatial.smooth.data = {left}; %image to smooth
        matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8]; %parameters in mm
        matlabbatch{1}.spm.spatial.smooth.dtype = 0; %data type of the output images --> set as 0 to obtain the same as input images
        matlabbatch{1}.spm.spatial.smooth.im = 0; %implicit masking: set as 0 as we do not want a mask implies by a particular voxel value
        matlabbatch{1}.spm.spatial.smooth.prefix = 's'; %output prefix
        
        spm_jobman('run',matlabbatch);  %Run the job
        
        %Perform right putamen smoothing
        matlabbatch{1}.spm.spatial.smooth.data = {right}; %image to smooth
        matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8]; %parameters in mm
        matlabbatch{1}.spm.spatial.smooth.dtype = 0; %data type of the output images --> set as 0 to obtain the same as input images
        matlabbatch{1}.spm.spatial.smooth.im = 0; %implicit masking: set as 0 as we do not want a mask implies by a particular voxel value
        matlabbatch{1}.spm.spatial.smooth.prefix = 's'; %output prefix
        
        spm_jobman('run',matlabbatch);  %Run the job
    end
end
