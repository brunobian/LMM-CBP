nIter=250
inPath="~/Bruno_R/alpha/"
outPath="~/lmm_results_500/freqalpha_suj/"
modType="lmm"
rPath=~/Repos/CuBaPeTo2/R_functions/
fixEf="freq + palnum:tipo + pred:tipo"
ranEf="(1|suj_id) + (1|pal)"
perVar=suj_id
perPath="~/Bruno_R/permutations/"
cstPath="~/Repos/CuBaPeTo2/example/cstFuns/"
nCores=4
Files="33 34 35 39"
nohupOut=~/Bruno_R/nohup/

INDEX=1
for x in $Files
do
        # start file
        tStart=$(( x/1 ))
        
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
~                  
