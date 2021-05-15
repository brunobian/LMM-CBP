# This function runs LMM in R spliting the time files in nCores

# load parameter: path to configuration file
cfgPath=$1

# load variables from cfg file
while IFS=, read -r var value; do
  eval "$var"='$value'
done < $cfgPath

# Number of file to run on each core
nRun=$(( $nFiles/$nCores ))

for x in `seq 1 $nCores`
do
	# start file
	tStart=$(( $startTime + $nRun*($x-1) )) 

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
	
	#nohup Rscript "$cmdR" "$tStart" "$tEnd" "$nIter" "$inPath" "$outPath" "$modType" "$rPath" "$fixEf" "$ranEf" "$perPath" "$perVar" "$cstPath" > $nhOut &

	nohup Rscript "$cmdR" "$tStart" "$tEnd" "$cfgPath" > $nhOut &
	
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
