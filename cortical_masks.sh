
#Using FSLeyes'Harvard-Oxford Cortical Structural atlas we obtained motor, executive and motivational cortical masks. This step was also performed using Resting-FMRI ICA components' templates. In this script, we transform the masks obtained to from T1 normalized space to FA space.



#Convert the masks obtained using the FSLeyes' atlases

DIR="/media/estela/HD_2/Irene/Analysis" #working directory

for group in Controls Patients; #for each group of data

    do
    echo $group #print the group we are working on

    for ele in Motor Executive Motivational; #for each of the three cortical regions

        do

        echo $ele #print the region being studied
        for folder in $DIR/$group/!(Runfirstall)/ #for each of the subjects in the current group 
            do

            name=$(basename "$folder") #obtain the subject's name

            mkdir $DIR/$group/$name/Cortical_masks #create folder where the cortical masks will be stored
            mkdir $DIR/$group/$name/Cortical_masks/$ele #create folder for the current region of the cortex
            
            ref_FA_MNI_1mm='/media/estela/HD_2/Irene/Proves/FMRIB58_FA_1mm.nii' #reference image FA space 1mm
            param_FA='/media/estela/HD_2/Irene/Proves/FA_2_FMRIB58_1mm.cnf'  #parameters of FA 1mm

            Input_right_mask="$DIR/Cortical_masks/$ele/${ele}_right.nii.gz" #right region that we want to normalize
            Input_left_mask="$DIR/Cortical_masks/$ele/${ele}_left.nii.gz" #left region that we want to normalize
            
            FA_image_right_normalized="$DIR/$group/$name/Cortical_masks/$ele/${ele}_right_FA.nii.gz" #output of the right region in FA space
            FA_image_left_normalized="$DIR/$group/$name/Cortical_masks/$ele/${ele}_left_FA.nii.gz" #output of the left region in FA space
            reference_image="/media/estela/HD_2/subjects/$name/dmri/dtifit_FA.nii.gz" #reference image dti

            aff_transf_fa="$DIR/$group/$name/Cortical_masks/$ele/aff_trans_fa" #affine trasformation FA space
            nl_transf_fa="$DIR/$group/$name/Cortical_masks/$ele/nl_trans_fa" #non linear transformation FA space

            linear_transformed_fa="$DIR/$group/$name/Cortical_masks/$ele/linear_transformed_fa" #linear transformed FA image brain
            

            transf_from_MNI_to_fa_right="$DIR/$group/$name/Cortical_masks/$ele/transform_from_MNI_right.nii" #transformation to go from MNI to FA right region
            transf_from_MNI_to_fa_left="$DIR/$group/$name/Cortical_masks/$ele/transform_from_MNI_left.nii" #transformation to go from MNI to FA left region


            echo "Normalización FA"

            echo "Linear FA"
            #Linear transformation
            flirt -ref ${ref_FA_MNI_1mm} -in ${reference_image} -omat ${aff_transf_fa} -o ${linear_transformed_fa}
            


            echo "nO LINEAR t1"
            #No linear transformation 
            fnirt --in=${reference_image} --aff=${aff_transf_fa} --cout=${nl_transf_fa} --config=${param_FA} --warpres=8,8,8
          


            echo "inverse warp"

            invwarp -r ${Input_right_mask} -w ${nl_transf_fa} -o ${transf_from_MNI_to_fa_right} #reverse the non-linear mapping of the right region
            invwarp -r ${Input_left_mask} -w ${nl_transf_fa} -o ${transf_from_MNI_to_fa_left} #reverse the non-linear mapping of the left region

            echo "apply warp" 

            applywarp -r ${reference_image}  -i ${Input_right_mask} -w ${transf_from_MNI_to_fa_right} -o ${FA_image_right_normalized} #map the computed transformation to the right image (in MNI) 
            applywarp -r ${reference_image}  -i ${Input_left_mask} -w ${transf_from_MNI_to_fa_left} -o ${FA_image_left_normalized} #map the computed transformation to the left image (in MNI) 

            echo "binarization"            

            fslmaths ${FA_image_right_normalized} -bin ${FA_image_right_normalized} #binarize intensity of right side FA image
            fslmaths ${FA_image_left_normalized} -bin ${FA_image_left_normalized} #binarize instensity of left side FA image image

            done;







        done;

    done;

#Convert the masks obtained using the Resting-FMRI ICA components' templates:

DIR="/media/estela/HD_2/Irene/Analysis" #working directory

for group in Controls Patients; #for each of the groups of data

    do
    echo $group #print the group we are working in

    for ele in Motor Executive Motivational; #for each of the three cortical regions

        do

        echo $ele #print the region
        for folder in $DIR/$group/!(Runfirstall)/ #for each of the subjects in the current group 
            do

            name=$(basename "$folder") #obtain the subject's name


            mkdir $DIR/$group/$name/Cortical_masks_resting #create folder where the cortical masks will be stored
            mkdir $DIR/$group/$name/Cortical_masks_resting/$ele #create folder for the current region of the cortex
            
            ref_FA_MNI_1mm='/media/estela/HD_2/Irene/Proves/FMRIB58_FA_1mm.nii' #reference image FA space 1mm
            param_FA='/media/estela/HD_2/Irene/Proves/FA_2_FMRIB58_1mm.cnf'  #parameters of FA 1mm

            Input_right_mask="$DIR/Cortical_masks_resting/$ele/${ele}_right.nii.gz" #right region that we want to normalize
            Input_left_mask="$DIR/Cortical_masks_resting/$ele/${ele}_left.nii.gz" #left region that we want to normalize
            
            FA_image_right_normalized="$DIR/$group/$name/Cortical_masks_resting/$ele/${ele}_right_FA.nii.gz" #output of the right region in FA space
            FA_image_left_normalized="$DIR/$group/$name/Cortical_masks_resting/$ele/${ele}_left_FA.nii.gz" #output of the left region in FA space
            reference_image="/media/estela/HD_2/subjects/$name/dmri/dtifit_FA.nii.gz" #reference image dti

            aff_transf_fa="$DIR/$group/$name/Cortical_masks_resting/$ele/aff_trans_fa" #affine trasformation FA space
            nl_transf_fa="$DIR/$group/$name/Cortical_masks_resting/$ele/nl_trans_fa" #non linear transformation FA space

            linear_transformed_fa="$DIR/$group/$name/Cortical_masks_resting/$ele/linear_transformed_fa" #linear transformed FA image brain
            

            transf_from_MNI_to_fa_right="$DIR/$group/$name/Cortical_masks_resting/$ele/transform_from_MNI_right.nii" #transformation to go from MNI to FA right region
            transf_from_MNI_to_fa_left="$DIR/$group/$name/Cortical_masks_resting/$ele/transform_from_MNI_left.nii" #transformation to go from MNI to FA left region


            echo "Normalización FA"

            echo "Linear FA"
            #Linear transformation
            flirt -ref ${ref_FA_MNI_1mm} -in ${reference_image} -omat ${aff_transf_fa} -o ${linear_transformed_fa} 
            


            echo "nO LINEAR t1"
            #No linear transformation 
            fnirt --in=${reference_image} --aff=${aff_transf_fa} --cout=${nl_transf_fa} --config=${param_FA} --warpres=8,8,8
          


            echo "inverse warp"

            invwarp -r ${Input_right_mask} -w ${nl_transf_fa} -o ${transf_from_MNI_to_fa_right} #reverse the non-linear mapping of the right region
            invwarp -r ${Input_left_mask} -w ${nl_transf_fa} -o ${transf_from_MNI_to_fa_left} #reverse the non-linear mapping of the left region

            echo "apply warp" 

            applywarp -r ${reference_image}  -i ${Input_right_mask} -w ${transf_from_MNI_to_fa_right} -o ${FA_image_right_normalized} #map the computed transformation to the right image (in MNI) 
            applywarp -r ${reference_image}  -i ${Input_left_mask} -w ${transf_from_MNI_to_fa_left} -o ${FA_image_left_normalized} #map the computed transformation to the left image (in MNI) 

            echo "binarization"            

            fslmaths ${FA_image_right_normalized} -bin ${FA_image_right_normalized} #binarize intensity of right side FA image
            fslmaths ${FA_image_left_normalized} -bin ${FA_image_left_normalized} #binarize instensity of left side FA image image

            done;







        done;

    done;
