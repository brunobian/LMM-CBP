nIter=0
inPath="~/Bruno_R/alpha/"
outPath="~/lmm_results_500/freqalpha/"
modType="lmm"
rPath=~/Repos/CuBaPeTo2/R_functions/
fixEf="freq + pred + tipo + pred:tipo"
ranEf="(1|suj_id) + (1|pal)"
perVar="suj_id"
perPath="~/Bruno_R/permutations/"
cstPath="~/Repos/CuBaPeTo2/example/cstFuns/"
nCores=4
nohupOut=~/Bruno_R/nohup/
nFiles=88
start=1

# Number of file to run on each core
nRun=$(( $nFiles/$nCores ))

for x in `seq 1 $nCores`
do
	# start file
	tStart=$(( $start + $nRun*($x-1) )) 
	# end file
	tEnd=$(( $tStart + $nRun-1))
	
	# if mod(nFiles,nCores) ~= 0, set last core to last file
	#if [ "$x" -eq "$nCores" ] 
	#then
	#	tEnd=$(( tStart + $nFiles))
	#fi
		
	echo "Starting in core $x with files $tStart to $tEnd"

	# set  the locartions properly
	nhOut="$nohupOut""$modType"_"$x" 
    cmdR="$rPath"completeRun.R
	
	nohup Rscript "$cmdR" "$tStart" "$tEnd" "$nIter" "$inPath" "$outPath" "$modType" "$rPath" "$fixEf" "$ranEf" "$perPath" "$perVar" "$cstPath" > $nhOut &

    #For the first core, I wait for the generation of the permutation 
    # matrix. 30s should be enough. 
	if [ "$x" -eq 1 ] 
	then
		sleep 25s # Waits 30 seconds.
	fi

	# For each run I wait 5 extra seconds. Just in case.
	sleep 5s
done
