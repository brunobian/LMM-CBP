# This function runs LMM in R spliting the time files in nCores

# Parameters
nIter=$1
inPath=$2
outPath=$3
modType=$4
rPath=$5
fixEf=$6
ranEf=$7
perPath=$8
perVar=$9
cstPath=${10}
nCores=${11}
nFiles=${12}
nohupOut=${13}

nRun=$(( $nFiles/$nCores ))

for x in `seq 1 $nCores`
do

	tStart=$(( 1 + nRun*($x-1) ))
	tEnd=$(( $tStart + nRun))

	# if mod(nFiles,nCores) ~= 0, set last core to last file

	if [ "$x" -eq "$nCores" ]
	then
		tEnd=$nFiles
	fi

	echo "Starting in core $x with files $tStart to $tEnd"

	nhOut="$nohupOut""$modType"_"$x"

	cd "$rPath"
	nohup Rscript completeRun.R "$tStart" "$tEnd" "$nIter" "$inPath" "$outPath" "$modType" "$rPath" "$fixEf" "$ranEf" "$perPath" "$perVar" "$cstPath" > $nhOut &

    #For the first core, I waitfor the generation of the permutation
    # matrix. 30s should be enough.
	if [ "$x" -eq 1 ]
	then
		sleep 30s # Waits 30 seconds.
	fi
done
