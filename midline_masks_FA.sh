
#This script obtains the right and left hemisphere masks from a reference general image and converts them to FA space applying them to reference images specific for each subject.


#Obtention of the right and left hemisphere masks:


fslhd MNI152_T1_1mm_brain.nii.gz  | grep dim1 #we obtain the dimensions in the x axis of the input image

#we need to divide de value of dim1 into 2 (182/2=91)

#to do the left side:

fslmaths MNI152_T1_1mm_brain.nii.gz  -roi 91 -1 -1 -1 -1 -1 -1 -1 left_hemisphere.nii.gz #take only the left part

fslmaths left_hemisphere.nii.gz -bin left_hemisphere.nii.gz #to binarize the left part

fslmaths MNI152_T1_1mm_brain.nii.gz -bin MNI152_T1_1mm_brain.nii.gz #binarize the total

#to obtain the right side: 


fslmaths MNI152_T1_1mm_brain.nii.gz -sub left_hemisphere.nii.gz right_hemisphere.nii.gz

fslmaths right_hemisphere.nii.gz -bin right_hemisphere.nii.gz #binarize the right part



#Transformation to FA space       


DIR="/media/estela/HD_2/Irene/Analysis"  #working directory

for group in Controls Patients; #for each group of subjects

    do
    echo $group #print the group we are analyzing

    for folder in $DIR/$group/!(Runfirstall)/ #for each of the subjects in the group
        do

        name=$(basename "$folder")  #obtain subject name
        echo $name #print subject name

        mkdir "/media/estela/HD_2/Irene/Analysis/$group/$name/Middline_masks" #create directory where the midline masks will be stored

        ref_FA_MNI_1mm='/media/estela/HD_2/Irene/Proves/FMRIB58_FA_1mm.nii' #reference image FA space 1mm
        param_FA='/media/estela/HD_2/Irene/Proves/FA_2_FMRIB58_1mm.cnf'  #parameters of FA 1mm

        Input_right_mask="/media/estela/HD_2/Irene/Proves/right_hemisphere.nii.gz" #right region that we want to normalize
        Input_left_mask="/media/estela/HD_2/Irene/Proves/left_hemisphere.nii.gz" #left region that we want to normalize
            
        FA_image_right_normalized="/media/estela/HD_2/Irene/Analysis/$group/$name/Middline_masks/right_hemisphere_FA.nii.gz" #output of the right region in FA space
        FA_image_left_normalized="/media/estela/HD_2/Irene/Analysis/$group/$name/Middline_masks/left_hemisphere_FA.nii.gz" #output of the left region in FA space
        reference_dti_image="/media/estela/HD_2/subjects/$name/dmri/dtifit_FA.nii.gz" #reference image dti

        aff_transf_fa="/media/estela/HD_2/Irene/Analysis/$group/$name/Middline_masks/aff_trans_fa" #affine trasformation FA space
        nl_transf_fa="/media/estela/HD_2/Irene/Analysis/$group/$name/Middline_masks/nl_trans_fa" #non linear transformation FA space

        linear_transformed_fa="/media/estela/HD_2/Irene/Analysis/$group/$name/Middline_masks/linear_transformed_fa" #linear trasnformation output to FA space
            

        transf_from_MNI_to_fa_right="/media/estela/HD_2/Irene/Analysis/$group/$name/Middline_masks/transform_from_MNI_right.nii" #transformation to go from MNI to FA right region
        transf_from_MNI_to_fa_left="/media/estela/HD_2/Irene/Analysis/$group/$name/Middline_masks/transform_from_MNI_left.nii" #transformation to go from MNI to FA left region


        echo "Normalización FA"



        echo "Linear FA"
        #Linear transformation
        flirt -ref ${ref_FA_MNI_1mm} -in ${FA_image} -omat ${aff_transf_fa} -o ${linear_transformed_fa}
            


        echo "nO LINEAR t1"
        #No linear transformation 
        fnirt --in=${FA_image} --aff=${aff_transf_fa} --cout=${nl_transf_fa} --config=${param_FA} --warpres=8,8,8
          


        echo "inverse warp"

        invwarp -r ${Input_right_mask} -w ${nl_transf_fa} -o ${transf_from_MNI_to_fa_right} #reverse the non-linear mapping of the right region
        invwarp -r ${Input_left_mask} -w ${nl_transf_fa} -o ${transf_from_MNI_to_fa_left} #reverse the non-linear mapping of the left region

        applywarp -r ${reference_dti_image}  -i ${Input_right_mask} -w ${transf_from_MNI_to_fa_right} -o ${FA_image_right_normalized} #map the computed transformation to the right image (in MNI)
        applywarp -r ${reference_dti_image}  -i ${Input_left_mask} -w ${transf_from_MNI_to_fa_left} -o ${FA_image_left_normalized} #map the computed transformation to the left image (in MNI)

        fslmaths ${FA_image_right_normalized} -bin ${FA_image_right_normalized} #binarize intensity of right side FA image
        fslmaths ${FA_image_left_normalized} -bin ${FA_image_left_normalized} #binarize intensity of left side FA image

        done;
    done;
done;
