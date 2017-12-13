nIter=0
<<<<<<< HEAD
inPath="~/Bruno_R/alpha/"
outPath="~/lmm_results_500/freqalpha/"
modType="lmm"
rPath=~/Repos/CuBaPeTo2/R_functions/
fixEf="freq + pred + tipo + pred:tipo"
ranEf="(1|suj_id) + (1|pal)"
perVar="suj_id"
=======
inPath="/media/brunobian/DataNew/Proverbs_wxw/csv_103/"
outPath="/media/brunobian/DataNew/Proverbs_wxw/results/relPos"
modType="lmm"
rPath=~/Documentos/Repos/CuBaPeTo2/R_functions/
fixEf="freq + palnum + MaxJump"
ranEf="(1|suj_id)"
perVar=suj_id
>>>>>>> ac3ad2948a233478567e47a96edd472160e27a8f
perPath="~/Bruno_R/permutations/"
cstPath="~/Documentos/Repos/CuBaPeTo2/example/cstFuns/"
nCores=4
nohupOut=~/Bruno_R/nohup/
nFiles=104
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
