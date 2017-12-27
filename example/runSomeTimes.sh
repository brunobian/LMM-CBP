nIter=200
inPath="~/Bruno_R/csv_103_posRel/"
outPath="~/lmm_results/"
modType="lmm"
rPath=~/CuBaPeTo2/R_functions/
fixEf="freq + palnum + MaxJump"
ranEf="(1|suj_id)"
perVar=suj_id
perPath="~/Bruno_R/permutations/"
cstPath="~/CuBaPeTo2/example/cstFuns/"
nCores=1
Files=" 93 "
nohupOut=~/Bruno_R/nohup/

INDEX=1
for x in $Files
do
        # start file
        tStart=$x
        
 	# end file
        tEnd=$tStart

        echo "Starting in core $INDEX with files $tStart to $tEnd"

        # set  the locations properly
        nhOut="$nohupOut""$modType"_"$INDEX"
        cmdR="$rPath"completeRun.R

        nohup Rscript "$cmdR" "$tStart" "$tEnd" "$nIter" "$inPath" "$outPath" "$modType" "$rPath" "$fixEf" "$ranEf" "$perPath" "$perVar" "$cstPath" > $nhOut &

    #For the first core, I wait for the generation of the permutation 
    # matrix. 30s should be enough. 
        if [ "$INDEX" -eq 1 ]
        then
                sleep 25s # Waits 30 seconds.
        fi

        # For each run I wait 5 extra seconds. Just in case.
        sleep 5s

	INDEX=$(( INDEX + 1 )) 

done 
               
