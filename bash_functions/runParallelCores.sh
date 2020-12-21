# This function runs LMM in R spliting the time files in nCores

# This are the Parameters (in order) that this function takes 
nIter=$1
inPath=$2
outPath=$3
modType=$4
rPath=$5
fixEf=$6
ranEf=$7
perPath=$8
perVar=$9
cstPath=$10
nCores=$11
nFiles=$12
nohupOut=$13
start=$14

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
	
	#nohup matlab -nodisplay -nodesktop -nojvm -r 'load cfg.mat; addpath(cfg.mPath); lm_completRun(cfg); exit;'  > $nhOut &


    #For the first core, I wait for the generation of the permutation 
    # matrix. 30s should be enough. 
	if [ "$x" -eq 1 ] 
	then
		sleep 25s # Waits 30 seconds.
	fi

	# For each run I wait 5 extra seconds. Just in case.
	sleep 5s
done
