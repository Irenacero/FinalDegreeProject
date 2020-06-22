#This script takes as input the third component of the T1-weighted image segmentation, which corresponds to the cerebrospinal fluid (CSF) and normalizes it into FA space

DIR="/media/estela/HD_2/Irene/Analysis" #specify the working directory

cd($DIR)

for group in Controls Patients; #for each group of subjects

    do
    echo $group #print the group we are analyzing

    for folder in $DIR/$group/!(Runfirstall)/ #for each of the subjects in the group
        do

        name=$(basename "$folder")  #obtain subject name
        echo $name #print subject name


        mkdir "/media/estela/HD_2/Irene/Analysis/$group/$name/CSF_mask" #create directory where the CSF masks will be kept

        ref_T1_MNI_1mm='/media/estela/HD_2/Irene/Proves/MNI152_T1_1mm_brain.nii' #reference image T1 space 1mm
        ref_FA_MNI_1mm='/media/estela/HD_2/Irene/Proves/FMRIB58_FA_1mm.nii' #reference image FA space 1mm

        FA_image_output="$DIR/$group/$name/CSF_mask/FA_C3.nii.gz" #final FA space image (output) 
        Input_structure="$DIR/$group/$name/T1/c3o*.nii" #Input image corresponding to the CSF obtained using Matlab SPM segmentation 

        reference_image="/media/estela/HD_2/subjects/$name/dmri/dtifit_FA.nii.gz" #reference image dti 
        aff_transf_fa="$DIR/$group/$name/CSF_mask/aff_trans_fac3" #affine trasformation FA space
        nl_transf_fa="/media/estela/HD_2/Irene/Analysis/$group/$name/CSF_mask/nl_trans_fac3" #non linear transformation FA space
        aff_transf="$DIR/$group/$name/CSF_mask/aff_transfc3.mat" #affine transformation of T1 to MNI
        nl_transf="$DIR/$group/$name/CSF_mask/nl_transfc3.nii" #non linear trasformation of T1 to MNI
       
        linear_transformed_T1="$DIR/$group/$name/CSF_mask/linear_transformed_c3_T1" #linear transformed T1 image brain
        linear_transformed_fa="$DIR/$group/$name/CSF_mask/linear_transformed_c3_fa" #linear transformed FA image brain
        

        param_T1='/media/estela/HD_2/Irene/Proves/T1_2_MNI152_2mm.cnf' #T1 parameters
        param_FA='/media/estela/HD_2/Irene/Proves/FA_2_FMRIB58_1mm.cnf' #FA parameters

        T1_image_bet="$DIR/$group/$name/T1/o_brain.nii.gz" #BET image of the brain computed before
        T1_norm_structure="$DIR/$group/$name/CSF_mask/T1_norm_c3.nii" #normalization T1 
       
        transf_from_MNI_to_fa_right_structure="$DIR/$group/$name/CSF_mask/transform_from_MNI_to_fa_right_c3.nii" #transformation to go from MNI to FA 
        


        #Normalization of T1 to MNI

        echo "Linear T1"
        #Linear transformation to T1
        flirt -ref ${ref_T1_MNI_1mm} -in ${T1_image_bet} -omat ${aff_transf} -o ${linear_transformed_T1} 

        echo "no LINEAR t1"
        #No linear transformation to T1
        fnirt --in=${T1_image_bet} --aff=${aff_transf} --cout=${nl_transf} --config=${param_T1} --warpres=8,8,8

        echo "APPLY WARP"
        #Apply transformation to T1
        applywarp -r ${ref_T1_MNI_1mm}  -i ${Input_structure} -w ${nl_transf} -o ${T1_norm_structure} #map the computed transformation to the image (which is in native T1) 
        

        echo "Linear FA"
        #Linear transformation
        flirt -ref ${ref_FA_MNI_1mm} -in ${reference_image} -omat ${aff_transf_fa} -o ${linear_transformed_fa}
        

        echo "nO LINEAR t1"
        #No linear transformation 
        fnirt --in=${reference_image} --aff=${aff_transf_fa} --cout=${nl_transf_fa} --config=${param_FA} --warpres=8,8,8


        echo "Transformation from MNI space to FA"
        echo "inverse warp"

        invwarp -r ${Input_structure} -w ${nl_transf_fa} -o ${transf_from_MNI_to_fa_right_structure} #reverse the non-linear mapping of the image


        echo "applywarp"
        
        applywarp -r ${reference_image}  -i ${T1_norm_structure} -w ${transf_from_MNI_to_fa_right_structure} -o ${FA_image_output} #map the computed transformation to the image (in MNI) 



        done;
    done;
done;


        

