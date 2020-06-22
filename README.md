FinalDegreeProject

Here you can find a brief description of the aim of each script. Initially, the explanation of the files used to complete the probabilistic tractography paths can be found. Afterwards, the file where the statistical analysis has been computed.The paper is in the file named as TFG_IreneAcero.pdf.

Probabilistic tractoraphy paths:

c3FA.sh --> This script takes as input the third component of the T1-weighted image segmentation, which corresponds to the cerebrospinal fluid (CSF) and normalizes it into FA space

cortical_masks.sh --> Using FSLeyes'Harvard-Oxford Cortical Structural atlas we obtained motor, executive and motivational cortical masks. This step was also performed using Resting-FMRI ICA components' templates. In this script, we transform the masks obtained to from T1 normalized space to FA space.

exclusion_masks.sh --> This file creates two different exclusion masks for each cortical region for each side of the brain. On the one hand, a mask excluding the CSF and the other hemisphere of the brain and, on the other hand, a mask excluding these elements plus the other cortical regions that we do not want to take into account. In this case, we are using the cortical ROIs obtained from FSLeyes'Harvard-Oxford Cortical Structural atlas. 

exclusion_masks_resting.sh --> This file creates two different exclusion masks for each cortical region for each side of the brain. On the one hand, a mask excluding the CSF and the other side of the brain and, on the other hand, a mask excluding these elements plus the other cortical regions that we do not want to take into account. In this case, we are using the cortical ROIs obtained from Resting-FMRI ICA components' templates. 

FA_values.sh --> This script takes a fdt_paths file obtained from Probtrackx and normalizes it by streamlines in order to apply a probability threshold. Afterwards, it obtains the FA, radial diffusivity and mean diffusivity values multiplying the normalized image by the reference image and computing the mean.

midline_masks_FA.sh --> This script obtains the right and left hemisphere masks from a reference general image and converts them to FA space applying them to reference images specific for each subject.

probtrack_initial_accumbens.sh --> This script runs the Probtrackx analysis for each side (left and right) of the accumbens and each side of three cortical regions (Motor, Motivational, Executive) using ROIs computed previously using FSLeyes atlas. This analysis is done for each subject in Patients and Controls. Two analysis are executed, one computing the tracts from the accumbens to the cortical region and the other on the other way, form the cortical to the subcortical. Hence, we will obtain better results by doing the mean between the two analyses.

probtrack_initial_caudate.sh --> This script runs the Probtrackx analysis for each side (left and right) of the caudate and each side of three cortical regions (Motor, Motivational, Executive) using ROIs computed previously using FSLeyes atlas. This analysis is done for each subject in Patients and Controls. Two analysis are executed, one computing the tracts from the caudate to the cortical region and the other on the other way, form the cortical to the subcortical. Hence, we will obtain better results by doing the mean between the two analysis.

probtrack_initial_putamen.sh --> This script runs the Probtrackx analysis for each side (left and right) of the putamen and each side of three cortical regions (Motor, Motivational, Executive) using ROIs computed previously using FSLeyes atlas. This analysis is done for each subject in Patients and Controls. Two analysis are executed, one computing the tracts from the putamen to the cortical region and the other on the other way, form the cortical to the subcortical. Hence, we will obtain better results by doing the mean between the two analysis.

probtrack_resting_accumbens.sh --> This script runs the Probtrackx analysis for each side (left and right) of the accumbens and each side of three cortical regions (Motor, Motivational, Executive) using ROIs computed previously using the resting templates. This analysis is done for each subject in Patients and Controls. Two analysis are executed, one computing the tracts from the accumbens to the cortical region and the other on the other way, form the cortical to the subcortical. Hence, we will obtain better results by doing the mean between the two analysis.

probtrack_resting_caudate.sh --> This script runs the Probtrackx analysis for each side (left and right) of the caudate and each side of three cortical regions (Motor, Motivational, Executive) using ROIs computed previously using the resting templates. This analysis is done for each subject in Patients and Controls. Two analysis are executed, one computing the tracts from the caudate to the cortical region and the other on the other way, form the cortical to the subcortical. Hence, we will obtain better results by doing the mean between the two analysis.

probtrack_resting_putamen.sh --> This script runs the Probtrackx analysis for each side (left and right) of the putamen and each side of three cortical regions (Motor, Motivational, Executive) using ROIs computed previously using the resting templates. This analysis is done for each subject in Patients and Controls. Two analysis are executed, one computing the tracts from the putamen to the cortical region and the other on the other way, form the cortical to the subcortical. Hence, we will obtain better results by doing the mean between the two analysis.

script_smoothing.sh --> This script uses as input the smoothed image computed in Matlab SPM, applies a threshold of 0.3 and binarizes it. 

smooting_accumbens.m --> This script includes a function with the group (which can be Controls, 1, or Patients, 2) as parameter, and computes the smoothing of the right and left accumbens of each of the subjects in the group. It runs in Matlab SPM. The image we want to smooth needs to be unzipped.

smoothing_caudate.m --> This script includes a function with the group (which can be Controls, 1, or Patients, 2) as parameter, and computes the smoothing of the right and left caudate of each subject in the group. It runs in Matlab SPM. The image we want to smooth needs to be unzipped.

smoothing_putamen.m --> This script includes a function with the group (which can be Controls, 1, or Patients, 2) as parameter, and computes the smoothing of the right and left putamen of each of the subjects in the group. It runs in Matlab SPM. The image we want to smooth needs to be unzipped.

subcortical_masks.sh --> This script uses the patient's T1-weighted structural image to obtain the left and right caudate, putamen and accumbens images using FSL tools. Then, it transforms them from native T1 space to FA space. 

T1_segmentation.m --> This script creates a function called Segmentation with Group as parameter ("1" stands for Controls group and "2" for Patients). This function performs segmentation of the T1-weighted image of each of the subjects using Matlab SPM Segmentation Tool. It separates tissue classes such as grey matter, white matter and cerebrospinal fluid (CSF). 



Image analysis:

results.R --> statistical study of the results obtained in the probabilistic tractogrpahy analysis
