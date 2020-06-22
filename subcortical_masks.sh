
#This script uses the patient's T1-weighted structural image to obtain the left and right caudate, putamen and accumbens images using FSL tools. Then, it transforms them from native T1 space to FA space. 


for group in Controls Patients; #iterate over each group of data (Controls and Patients)

    do
    DIR="/media/estela/HD_2/Irene/Analysis/$group" #directory where the group data is

    cd $DIR #enter to the directory in which we have the data

    for folder in */ #for each subject in the group
     	do 

        name=$(basename "$folder") #obtain the folder name (subject name)
        
        mkdir Runfirstall/$name    #create directory of the corresponding folder 
        mkdir Runfirstall/$name/Runfirstall #here the results of the run_first_all analysis will be stored
        mkdir $name/Caudate_masks #create directory where the caudate masks will be stored
        mkdir $name/Caudate_masks/FA_transformation #create directory where the output of the transformation of caudate masks to FA space will be stored

        mkdir $name/putamen_masks #create directory where the putamen masks will be stored
        mkdir $name/putamen_masks/FA_transformation #create directory where the output of the transformation of putamen masks to FA space will be stored

        mkdir $name/accumbens_masks #create directory where the accumbens masks will be stored
        mkdir $name/accumbens_masks/FA_transformation #create directory where the output of the transformation of accumbens masks to FA space will be stored
        
        #RUN_FIRST_ALL analysis: in this step we perform segmentation of all the subcortical structures
        run_first_all -i $name/T1/o* -o $DIR/Runfirstall/$name/Runfirstall #input file contains the original T1-weighted structural image

        #Obtention of right and left caudate using the corresponding intensity values of the images of substructures obtained
        fslmaths $DIR/Runfirstall/$name/Runfirstall_all_fast_firstseg.nii.gz -thr 50 -uthr 50 $DIR/$name/Caudate_masks/right_caudate.nii.gz #obtain the right caudate and save it to directory
        fslmaths $DIR/Runfirstall/$name/Runfirstall_all_fast_firstseg.nii.gz -thr 11 -uthr 11 $DIR/$name/Caudate_masks/left_caudate.nii.gz #obtain the left caudate and save it to directory

        #Obtention of right and left putamen
        fslmaths $DIR/Runfirstall/$name/Runfirstall_all_fast_firstseg.nii.gz -thr 12 -uthr 12 $DIR/$name/putamen_masks/left_putamen.nii.gz #obtain the left putamen and save it to directory
        fslmaths $DIR/Runfirstall/$name/Runfirstall_all_fast_firstseg.nii.gz -thr 51 -uthr 51 $DIR/$name/putamen_masks/right_putamen.nii.gz #obtain the right putamen and save it to directory

        #Obtention of the right and left accumbens
        fslmaths $DIR/Runfirstall/$name/Runfirstall_all_fast_firstseg.nii.gz -thr 26 -uthr 26 $DIR/$name/accumbens_masks/left_accumbens.nii.gz #obtain the left accumbens and save it to directory
        fslmaths $DIR/Runfirstall/$name/Runfirstall_all_fast_firstseg.nii.gz -thr 58 -uthr 58 $DIR/$name/accumbens_masks/right_accumbens.nii.gz #obtain the right accumbens and save it to directory
    

        #BET: in this step we perform the separation of the brain from the skull
        /usr/share/fsl/5.0/bin/bet $DIR/$name/T1/o*.nii $DIR/$name/T1/o_brain -R -f 0.5 -g 0 -c 104 139 138 #the input file is the original T1-weighted structural image and we will store it as "o_brain". We are using robust brain center estimation, a fractional intensity threshold of 0.5 and 104 X, 139 Y, 138 Z as voxels for centre of initial brain surface sphere (determined using Matlab SPM).
        done;



    #Transformation of left and right caudate masks to FA space using FSL tools
    for folder in $DIR/!(Runfirstall)/ #for each of the subjects in each group
        do

        name=$(basename "$folder") #obtain folder name (subject name)
        echo $name #print the subject which we are working on

        cd $DIR

        for subpart in Caudate putamen accumbens; #for each subcortical structure 
        
            do
            ref_T1_MNI_1mm='/media/estela/HD_2/Irene/Proves/MNI152_T1_1mm_brain.nii' #reference image T1 space 1mm
            ref_FA_MNI_1mm='/media/estela/HD_2/Irene/Proves/FMRIB58_FA_1mm.nii' #reference image FA space 1mm

            FA_image_right="$DIR/$name/${subpart}_masks/FA_transformation/FA_right_${subpart}.nii.gz" #final FA space right image  
            FA_image_left="$DIR/$name/${subpart}_masks/FA_transformation/FA_left_${subpart}.nii.gz" #final FA space left image

            Input_right_structure="$DIR/$name/${subpart}_masks/right_${subpart}.nii.gz" #right mask obtained with runfirstall
            Input_left_structure="$DIR/$name/${subpart}_masks/left_${subpart}.nii.gz" #left mask obtained with runfirstall
            Reference_dti="/media/estela/HD_2/subjects/$name/dmri/dtifit_FA.nii.gz" #reference image dti 

            aff_transf_fa="$DIR/$name/${subpart}_masks/FA_transformation/aff_trans_fa" #affine trasformation FA space
            nl_transf_fa="$DIR/$name/${subpart}_masks/FA_transformation/nl_trans_fa_right" #non linear transformation FA space

            aff_transf="$DIR/$name/${subpart}_masks/FA_transformation/aff_transf.mat" #affine transformation of T1 to MNI
            nl_transf="$DIR/$name/${subpart}_masks/FA_transformation/nl_transf.nii" #non linear trasformation of T1 to MNI
           
            linear_transformed_T1="$DIR/$name/${subpart}_masks/FA_transformation/linear_transformed_T1" #linear transformed T1 image brain
            linear_transformed_fa="$DIR/$name/${subpart}_masks/FA_transformation/linear_transformed_fa" #linear transformed FA image brain
            

            param_T1='/media/estela/HD_2/Irene/Proves/T1_2_MNI152_2mm.cnf' #T1 parameters
            param_FA='/media/estela/HD_2/Irene/Proves/FA_2_FMRIB58_1mm.cnf' #FA parameters

            T1_image_bet="$DIR/$name/T1/o_brain.nii.gz" #BET image of the brain computed before
      
            T1_norm_right_structure="$DIR/$name/${subpart}_masks/FA_transformation/T1_norm_right.nii" #normalization T1 of the right structure
            T1_norm_left_structure="$DIR/$name/${subpart}_masks/FA_transformation/T1_norm_left.nii" #normalization T1 of the left structure

            transf_from_MNI_to_fa_right_structure="$DIR/$name/${subpart}_masks/FA_transformation/transform_from_MNI_to_fa_right.nii" #transformation to go from MNI to FA right structure
            transf_from_MNI_to_fa_left_structure="$DIR/$name/${subpart}_masks/FA_transformation/transform_from_MNI_to_fa_left.nii" #transformation to go from MNI to FA left structure


            #Normalization of T1 to MNI

            echo "Linear T1"
            #Linear transformation to T1
            flirt -ref ${ref_T1_MNI_1mm} -in ${T1_image_bet} -omat ${aff_transf} -o ${linear_transformed_T1} 

            echo "no LINEAR t1"
            #No linear transformation to T1
            fnirt --in=${T1_image_bet} --aff=${aff_transf} --cout=${nl_transf} --config=${param_T1} --warpres=8,8,8

            echo "APPLY WARP"
            #Apply transformation to T1
            applywarp -r ${ref_T1_MNI_1mm}  -i ${T1_image_right_structure} -w ${nl_transf} -o ${T1_norm_right_structure} #map the computed transformation to the right image (which is in native T1) 
            applywarp -r ${ref_T1_MNI_1mm}  -i ${T1_image_left_structure} -w ${nl_transf} -o ${T1_norm_left_structure} #map the computed transformation to the left image (which is in native T1)

            echo "Linear FA"
            #Linear transformation
            flirt -ref ${ref_FA_MNI_1mm} -in ${Reference_dti} -omat ${aff_transf_fa} -o ${linear_transformed_fa}
            

            echo "nO LINEAR t1"
            #No linear transformation 
            fnirt --in=${Reference_dti} --aff=${aff_transf_fa} --cout=${nl_transf_fa} --config=${param_FA} --warpres=8,8,8


            echo "Transformation from MNI space to FA"
            echo "inverse warp"

            invwarp -r ${Input_right_structure} -w ${nl_transf_fa} -o ${transf_from_MNI_to_fa_right_structure} #reverse the non-linear mapping of the right structure
            invwarp -r ${Input_left_structure} -w ${nl_transf_fa} -o ${transf_from_MNI_to_fa_left_structure} #reverse the non-linear mapping of the left structure

            echo "applywarp"
            
            applywarp -r ${Reference_dti}  -i ${T1_norm_right_structure} -w ${transf_from_MNI_to_fa_right_structure} -o ${FA_image_right} #map the computed transformation to the right image (in MNI) 
            applywarp -r ${Reference_dti}  -i ${T1_norm_left_structure} -w ${transf_from_MNI_to_fa_left_structure} -o ${FA_image_left} #map the computed transformation to the left image (in MNI)

            echo "binarization"

            fslmaths ${FA_image_right} -bin ${FA_image_right} #binarize intensities to 0 and 1 right structure
            fslmaths ${FA_image_left} -bin ${FA_image_left} #binarize intensities to 0 and 1 left structure

            #unzip the output obtained to perform smoothing in the next step of the analysis
            gunzip -k ${FA_image_right} 
            gunzip -k ${FA_image_left} 

            done;
        done;
done;




