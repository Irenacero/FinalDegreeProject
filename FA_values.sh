#This script takes a fdt_paths file obtained from Probtrackx and normalizes it by streamlines in order to apply a probability threshold. Afterwards, it obtains the FA, radial diffusivity and mean diffusivity values multiplying the normalized image by the reference image and computing the mean.


DIR="/media/estela/HD_2/Irene/Analysis"  #working directory

for group in Controls Patients; #for each group of subjects

    do
    echo $group #print the group we are analyzing
    

    for data in initial Resting #for both types of cortical ROIs used

        do
        echo $data
        if [[ "$data" == "initial" ]] #if we are using the ROIs obtained with FSL
        then


            for folder in $DIR/Tractography_${group}/!(Runfirstall)/ #for each of the subjects in the group
                do

                name=$(basename "$folder")  #obtain subject name
                echo $name #print subject name

                for exclusion in Exclusion No_exclusion  #for each type of exclusion masks
                    
                    do
                    
                    for region in accumbens Caudate putamen #for each subcortical region
                        do

                        for cortical in Executive Motivational Motor #for each cortical region

                            do
                            for side in left right #for each hemisphere of the brain

                                do

                                Column_name="Initial_${exclusion}_${region}_${cortical}_${side}" #All variables we are computing 
                    

                                if [[ "$name" == "C01_1" ]]  #if we are in the first subject
                                then
                                    Header="Subject ${Column_name}_FA ${Column_name}_MD ${Column_name}_RD" #header of the file where we will store the results
                                    echo "$Header" > $DIR/${Column_name}.csv #print the header in the file
                                    

                                fi

                                for seed in seed1 seed2 #for each of the two analysis run in each case (cortical to subcortical and subcortical to cortical)
                                    do
                                    current_dir="$DIR/Tractography_${group}/$name/$exclusion/$region/$cortical/$side/$seed" #directory in which we are working in
                                    
                                    waytotal="$current_dir/waytotal" #file where the waytotal values are stored
                                    streamlines=$(cat "$waytotal") #reads the values of the waytotal file 

                                    #normalize by waytotal 
                                    fslmaths $current_dir/fdt_paths.nii.gz -div $streamlines $current_dir/fdt_paths_norm.nii.gz    

                                                    
                                    done;

                               

                                current_dir="$DIR/Tractography_${group}/$name/$exclusion/$region/$cortical/${side}" #directory in which we are working in
                        
                                fslmaths $current_dir/seed1/fdt_paths_norm.nii.gz -add $current_dir/seed2/fdt_paths_norm.nii.gz -div 2 $current_dir/mean_image #compute the mean image with both seeds
                 

                                fslmaths $current_dir/mean_image -thrP 95 -bin $current_dir/mean_image_bin.nii.gz #apply a threshold of 95% and binarize


                                fslmaths $current_dir/mean_image_bin.nii.gz -mul /media/estela/HD_2/subjects/$name/dmri/dtifit_FA.nii.gz $current_dir/multiplication_dtiFA_mask #multiply by the FA reference image

                                fslmaths /media/estela/HD_2/subjects/$name/dmri/dtifit_L1.nii.gz -add /media/estela/HD_2/subjects/$name/dmri/dtifit_L2.nii.gz -add /media/estela/HD_2/subjects/$name/dmri/dtifit_L3.nii.gz -div 3 /media/estela/HD_2/subjects/$name/dmri/ditfit_MD #obtain the Mean Diffusivity (MD) reference image
                                fslmaths /media/estela/HD_2/subjects/$name/dmri/dtifit_L2.nii.gz -add /media/estela/HD_2/subjects/$name/dmri/dtifit_L3.nii.gz -div 2 /media/estela/HD_2/subjects/$name/dmri/ditfit_RD #obtain the Radial Diffusivity (RD) reference image

                                fslmaths $current_dir/mean_image_bin.nii.gz -mul /media/estela/HD_2/subjects/$name/dmri/ditfit_MD $current_dir/multiplication_dtiMD_mask #multiply by the MD reference image

                                fslmaths $current_dir/mean_image_bin.nii.gz -mul /media/estela/HD_2/subjects/$name/dmri/ditfit_RD $current_dir/multiplication_dtiRD_mask #multiply by the RD reference image

                                #obtain the FA mean
                                FA_mean=$(fslstats $current_dir/multiplication_dtiFA_mask.nii.gz -M) #store the mean in a variable

                                

                                #obtain the MD:

                                MD=$(fslstats $current_dir/multiplication_dtiMD_mask.nii.gz -M) #store the mean in a variable

                                #obtain the RD:

                                RD=$(fslstats $current_dir/multiplication_dtiRD_mask.nii.gz -M) #store the mean in a variable


                                echo ${name} $FA_mean $MD $RD >> $DIR/${Column_name}.csv #print the the cortical region and side of brain and the FA mean, MD and RD in the final results file

                                done;
                            done;
                        done;
                    done;

               

                done;

            else #if we are using the resting cortical ROIs 
      


                for folder in $DIR/Tractography_${group}_resting/!(Runfirstall)/ #for each of the subjects in the group
                    do

                    name=$(basename "$folder")  #obtain subject name
                    echo $name #print subject name

                    for exclusion in Exclusion No_exclusion #for each type of exclusion masks
                        
                        do
                        
                        for region in accumbens Caudate putamen #for each subcortical region
                            do

                            for cortical in Executive Motivational Motor #for each cortical region

                                do
                                for side in left right #for each hemisphere of the brain

                                    do

                                    Column_name="Resting_${exclusion}_${region}_${cortical}_${side}" #all variables we are using

                                    if [[ "$name" == "C01_1" ]]  #if we are in the first control (first subject analysed)
                                    then
                                        Header="Subject ${Column_name}_FA ${Column_name}_MD ${Column_name}_RD" #header of the file in which we will store the results
                                        echo $Header > $DIR/${Column_name}.csv #print the header in the file
                                         

                                    fi

                                    for seed in seed1 seed2 #for each analysis run in each case (subcortical to cortical and cortical to subcortical regions)
                                        do
                                        current_dir="$DIR/Tractography_${group}_resting/$name/$exclusion/$region/$cortical/$side/$seed" #directory in which we are working
                                        
                                        waytotal="$current_dir/waytotal" #file where the waytotal values are stored
                                        streamlines=$(cat "$waytotal") #reads the values of the waytotal file 

                                        #normalize by waytotal and binarize
                                        fslmaths $current_dir/fdt_paths.nii.gz -div $streamlines $current_dir/fdt_paths_norm.nii.gz    

                                                        
                                        done;

                                   

                                    current_dir="$DIR/Tractography_${group}_resting/$name/$exclusion/$region/$cortical/$side" #directory in which we are working
                            
                                    fslmaths $current_dir/seed1/fdt_paths_norm.nii.gz -add $current_dir/seed2/fdt_paths_norm.nii.gz -div 2 $current_dir/mean_image #compute the mean of the two analysis
                        
                                    fslmaths $current_dir/mean_image -thrP 95 -bin $current_dir/mean_image_bin.nii.gz #apply a 95% threshold and binarize

                                    fslmaths $current_dir/mean_image_bin.nii.gz -mul /media/estela/HD_2/subjects/$name/dmri/dtifit_FA.nii.gz $current_dir/multiplication_dtiFA_mask #multiply by the FA reference image

                                    fslmaths $current_dir/mean_image_bin.nii.gz -mul /media/estela/HD_2/subjects/$name/dmri/dtifit_FA.nii.gz $current_dir/multiplication_dtiFA_mask

                                    fslmaths /media/estela/HD_2/subjects/$name/dmri/dtifit_L1.nii.gz -add /media/estela/HD_2/subjects/$name/dmri/dtifit_L2.nii.gz -add /media/estela/HD_2/subjects/$name/dmri/dtifit_L3.nii.gz -div 3 /media/estela/HD_2/subjects/$name/dmri/ditfit_MD #obtain the mean diffusivity reference image
                                    fslmaths /media/estela/HD_2/subjects/$name/dmri/dtifit_L2.nii.gz -add /media/estela/HD_2/subjects/$name/dmri/dtifit_L3.nii.gz -div 2 /media/estela/HD_2/subjects/$name/dmri/ditfit_RD #obtain the radial diffusivity reference image
                                    fslmaths $current_dir/mean_image_bin.nii.gz -mul /media/estela/HD_2/subjects/$name/dmri/ditfit_MD $current_dir/multiplication_dtiMD_mask #multiply by the Mean Disffusivity (MD) reference image

                                    fslmaths $current_dir/mean_image_bin.nii.gz -mul /media/estela/HD_2/subjects/$name/dmri/ditfit_RD $current_dir/multiplication_dtiRD_mask #multiply by the radial diffusivity (RD) reference image

                                    #obtain the FA mean
                                    FA_mean=$(fslstats $current_dir/multiplication_dtiFA_mask.nii.gz -M) #store the mean in a variable

                                    #obtain the MD:

                                    MD=$(fslstats $current_dir/multiplication_dtiMD_mask.nii.gz -M) #store the mean in a variable

                                    #obtain the RD:

                                    RD=$(fslstats $current_dir/multiplication_dtiRD_mask.nii.gz -M) #store the mean in a variable


                                    echo ${name} $FA_mean $MD $RD >> $DIR/${Column_name}.csv #print the the cortical region and side of brain and the FA mean, MD and RD in the final results file



                                    done;
                                done;
                            done;
                        done;

                    done;

            fi

        done;
    done;

                           

















                                    
