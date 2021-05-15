#### IN PROGRESS ######


# This function runs LMM in R spliting the time files in m PCs
# And for each PC, spliting the times in n Cores
# If mPcs == 1, this function works as runParallelCores.sh

cfgPath=$1 
labsPath=$2 

#cfgPath=/media/brunobian/DATABRUNO/Co-registro_2018/Data/LMM/cfg.csv
#labsPath=/media/brunobian/DATABRUNO/Co-registro_2018/Data/LMM/labos.csv

# load variables from cfg file
while IFS=, read -r var value; do
  eval "$var"='$value'
done < $cfgPath

while IFS=, read -r var value; do
  eval "$var"='($value)'
done < $labsPath

mPcs=${#labs[@]}
mRunPc=$(( $nFiles/$mPcs ))

for i in `seq 0 $(($mPcs-1))`
do
	l=${labs[i]}
	z=${pcs[i]}
	echo "Starting in lab $l, PC $z"

	tStartPc=$(( 1 + $mRunPc*($z-1) )) 
	tEndPc=$(( $tStartPc + $mRunPc))

	if [ "$z" -eq "$mPcs" ] 
	then
		tEndPc=$nFiles 
	fi

    echo -e "\tCopying files fom t$tStartPc to t$tEndPc"
    for f in `seq $tStartPc $tEndPc`
    do
		scp -q "$scpPath"t$f.csv $inPath
	done

	nRunCore=$(( $mRunPc/$nCores ))
	for x in `seq 1 $nCores`
	do

		tStartCore=$(( $tStartPc + nRunCore*($x-1) )) 
		tEndCore=$(( $tStartCore + nRunCore-1))
		
		# if mod(nFiles,nCores) ~= 0, set last core to last file
		if [ "$x" -eq "$nCores" ] 
		then
			tEndCore=$tEndPc 
		fi
		
		echo -e "\tStarting in core $x with files $tStartCore to $tEndCore"

		nhOut="$nohupOut""$modType"_"$x" 
	    cmdR="$rPath"completeRun.R
		
		#nohup Rscript "$cmdR" "$tStart" "$tEnd" "$nIter" "$inPath" "$outPath" "$modType" "$rPath" "$fixEf" "$ranEf" "$perPath" "$perVar" "$cstPath" > $nhOut &

		nohup Rscript "$cmdR" "$tStart" "$tEnd" "$cfgPath" > $nhOut &

	    #For the first core, I waitfor the generation of the permutation 
	    # matrix. 30s should be enough. 
		if [ "$x" -eq 1 ] && [ "$i" -eq 0 ]
		then
			sleep 30s # Waits 30 seconds.
		fi
	done
	echo ""
done

