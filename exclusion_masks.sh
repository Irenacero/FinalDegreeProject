#This file creates two different exclusion masks for each cortical region for each side of the brain. On the one hand, a mask excluding the CSF and the other hemisphere of the brain and, on the other hand, a mask excluding these elements plus the other cortical regions that we do not want to take into account. In this case, we are using the cortical ROIs obtained from FSLeyes'Harvard-Oxford Cortical Structural atlas. 

DIR="/media/estela/HD_2/Irene/Analysis"  #working directory

for group in Controls Patients; #for each group of subjects

    do
    echo $group #print the group we are analyzing

    for folder in $DIR/$group/!(Runfirstall)/ #for each of the subjects in the group
        do

        name=$(basename "$folder")  #obtain subject name
        echo $name #print subject name

        mkdir "$DIR/$group/$name/Exclusion_masks" #directory where the exlcusion masks will be stored
        
        fslmaths "$DIR/$group/$name/CSF_mask/FA_C3.nii.gz" -thr 0.4 -bin "$DIR/$group/$name/CSF_mask/FA_C3.nii.gz" #binarize and threshold CSF


        for side in left right #for each side of the brain

            do

            for cortical in Executive Motivational Motor #for each cortical region
                do

                #substract the cortical region from the CSF:
                fslmaths "$DIR/$group/$name/CSF_mask/FA_C3.nii.gz" -sub "$DIR/$group/$name/Cortical_masks/$cortical/${cortical}_${side}_FA.nii.gz" -bin "$DIR/$group/$name/Exclusion_masks/csf_minus_${cortical}_${side}.nii.gz" #CSF mask minus cortical mask
                
                #addition of the midline:

                if [[ "$side" == "left" ]] #if we are computing the left side mask, we will need to add the right hemisphere mask so we can avoid tracts going into that direction
                then
                    

                    fslmaths "$DIR/$group/$name/Exclusion_masks/csf_minus_${cortical}_${side}.nii.gz" -add "$DIR/$group/$name/Middline_masks/right_hemisphere_FA.nii.gz" -bin "$DIR/$group/$name/Exclusion_masks/exclusion_mask_CSF_middline_${cortical}_${side}.nii.gz"  #addition of the right hemisphere mask

                else #on the other hand, if we are computing the right side mask, we will need to add the left hemisphere mask 
                   

                    fslmaths "$DIR/$group/$name/Exclusion_masks/csf_minus_${cortical}_${side}.nii.gz" -add "$DIR/$group/$name/Middline_masks/left_hemisphere_FA.nii.gz" -bin "$DIR/$group/$name/Exclusion_masks/exclusion_mask_CSF_middline_${cortical}_${side}.nii.gz" #addition of the left hemisphere mask

                fi
                    



                done;

            done;

        done;

done; 


#add to the exclusion mask the other cortical masks that we do not want to take into account


for group in Controls Patients; #for each group of subjects

    do
    echo $group #print the group we are analyzing

    for folder in $DIR/$group/!(Runfirstall)/ #for each of the subjects in the group
        do

        name=$(basename "$folder")  #obtain subject name
        echo $name #print subject name

        for side in left right #for each side of the brain
            
            do

            fslmaths "$DIR/$group/$name/Exclusion_masks/exclusion_mask_CSF_middline_Motivational_${side}.nii.gz" -add "$DIR/$group/$name/Cortical_masks/Motor/Motor_${side}_FA.nii.gz" -add "$DIR/$group/$name/Cortical_masks/Executive/Executive_${side}_FA.nii.gz"  -bin "$DIR/$group/$name/Exclusion_masks/exclusion_mask_total_Motivational_${side}.nii.gz" #exclusion mask with motor and executive exclusions

            fslmaths "$DIR/$group/$name/Exclusion_masks/exclusion_mask_CSF_middline_Executive_${side}.nii.gz" -add "$DIR/$group/$name/Cortical_masks/Motor/Motor_${side}_FA.nii.gz" -add "$DIR/$group/$name/Cortical_masks/Motivational/Motivational_${side}_FA.nii.gz"  -bin "$DIR/$group/$name/Exclusion_masks/exclusion_mask_total_Executive_${side}.nii.gz" #exclusion mask with motor and motivational exclusions


            fslmaths "$DIR/$group/$name/Exclusion_masks/exclusion_mask_CSF_middline_Motor_${side}.nii.gz" -add "$DIR/$group/$name/Cortical_masks/Motivational/Motivational_${side}_FA.nii.gz" -add "$DIR/$group/$name/Cortical_masks/Executive/Executive_${side}_FA.nii.gz"  -bin "$DIR/$group/$name/Exclusion_masks/exclusion_mask_total_Motor_${side}.nii.gz" #exclusion mask with behavioural and motivational exclusions

            done;

        done;
    
done; 



