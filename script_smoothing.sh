#This script uses as input the smoothed image computed in Matlab SPM, applies a threshold of 0.3 and binarizes it. 


DIR="/media/estela/HD_2/Irene/Analysis"  #working directory

for group in Controls Patients; #for each of the groups

    do
    echo $group #print the group that is being analyzed

    for folder in $DIR/$group/!(Runfirstall)/ #for each of the subjects in the group
        do

        name=$(basename "$folder") #obtain the folder name (subject name)
        echo $name #print the subject name

        for side in left right #for each side of the brain
            
            do

            for subpart in Caudate putamen accumbens #for each of the subcortical structures
                do
            
                fslmaths $DIR/$group/$name/${subpart}_masks/FA_transformation/sFA_${side}_${subpart}.nii -thr 0.3 -bin $DIR/$group/$name/${subpart}_masks/FA_transformation/smoothed_${side}_${subpart}.nii #apply threshold and binarize using FSL tools
                done;
            done;
        done;
    done;

