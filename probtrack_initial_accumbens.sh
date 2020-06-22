#This script runs the Probtrackx analysis for each side (left and right) of the accumbens and each side of three cortical regions (Motor, Motivational, Executive) using ROIs computed previously using FSLeyes atlas. This analysis is done for each subject in Patients and Controls. Two analysis are executed, one computing the tracts from the accumbens to the cortical region and the other on the other way, form the cortical to the subcortical. Hence, we will obtain better results by doing the mean between the two analyses.


DIR="/media/estela/HD_2/Irene/Analysis"  #working directory

for group in Controls Patients; #for each group of subjects

    do
    echo $group #print the group we are analyzing

    for folder in $DIR/$group/!(Runfirstall)/ #for each of the subjects in the group
        do

        name=$(basename "$folder")  #obtain subject name
        echo $name #print subject name

        for side in left right #for each side of the brain
            
            do
            
            for cortical in Executive Motivational Motor #for each cortical region
                do
                for exclusion in Exclusion No_exclusion;
                    do

                    mkdir "$DIR/Tractography_${group}/$name" #folder that will contain probtrackx output
                    mkdir "$DIR/Tractography_${group}/$name/$exclusion"

                    mkdir "$DIR/Tractography_${group}/$name/$exclusion/accumbens"

                    mkdir "$DIR/Tractography_${group}/$name/$exclusion/accumbens/$cortical" #folder that will contain probtrackx output of each cortical region of the brain

                    mkdir "$DIR/Tractography_${group}/$name/$exclusion/accumbens/$cortical/$side" #folder that will contain probtrackx output of each side of the brain


                    bedpost_dir="$DIR/Bedpost_${group}/$name/dmri.bedpostX" #directory where the bedpostX output is stored

                    if [[ "$exclusion" == "Exclusion" ]] #run the analysis adding the two cortical masks not used as seed as exclusion masks

                    then 
                        echo "Total exclusion probtrakx"
                        /usr/share/fsl/5.0/bin/probtrackx2 -x $DIR/$group/$name/Cortical_masks/$cortical/${cortical}_${side}_FA.nii.gz -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --avoid="$DIR/$group/$name/Exclusion_masks/exclusion_mask_total_${cortical}_${side}.nii.gz" --forcedir --opd -s $bedpost_dir/merged -m $bedpost_dir/nodif_brain_mask --dir=$DIR/Tractography_${group}/$name/$exclusion/accumbens/$cortical/$side/seed1 --stop=$DIR/$group/$name/accumbens_masks/FA_transformation/smoothed_${side}_accumbens.nii.gz 


                        /usr/share/fsl/5.0/bin/probtrackx2 -x $DIR/$group/$name/accumbens_masks/FA_transformation/smoothed_${side}_accumbens.nii.gz -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --avoid="$DIR/$group/$name/Exclusion_masks/exclusion_mask_total_${cortical}_${side}.nii.gz" --forcedir --opd -s $bedpost_dir/merged -m $bedpost_dir/nodif_brain_mask --dir=$DIR/Tractography_${group}/$name/$exclusion/accumbens/$cortical/$side/seed2 --waypoints=$DIR/$group/$name/Cortical_masks/$cortical/${cortical}_${side}_FA.nii.gz --waycond=AND

                    else #run the analysis without adding the two cortical masks not used as seed as exclusion masks
                        echo "CSF_midline exclusion probtrakx"
                        /usr/share/fsl/5.0/bin/probtrackx2 -x $DIR/$group/$name/Cortical_masks/$cortical/${cortical}_${side}_FA.nii.gz -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --avoid="$DIR/$group/$name/Exclusion_masks/exclusion_mask_CSF_middline_${cortical}_${side}.nii.gz" --forcedir --opd -s $bedpost_dir/merged -m $bedpost_dir/nodif_brain_mask --dir=$DIR/Tractography_${group}/$name/$exclusion/accumbens/$cortical/$side/seed1 --stop=$DIR/$group/$name/accumbens_masks/FA_transformation/smoothed_${side}_accumbens.nii.gz 


                        /usr/share/fsl/5.0/bin/probtrackx2 -x $DIR/$group/$name/accumbens_masks/FA_transformation/smoothed_${side}_accumbens.nii.gz -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --avoid="$DIR/$group/$name/Exclusion_masks/exclusion_mask_CSF_middline_${cortical}_${side}.nii.gz" --forcedir --opd -s $bedpost_dir/merged -m $bedpost_dir/nodif_brain_mask --dir=$DIR/Tractography_${group}/$name/$exclusion/accumbens/$cortical/$side/seed2 --waypoints=$DIR/$group/$name/Cortical_masks/$cortical/${cortical}_${side}_FA.nii.gz --waycond=AND

                        
                        

                    fi

                    done;
            done;

        done;
    done; 
done;


