#### IN PROGRESS ######


# This function runs LMM in R spliting the time files in m PCs
# And for each PC, spliting the times in n Cores
# If mPcs == 1, this function works as runParallelCores.sh

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
cstPath=$10
mPcs=$11
nCores=$12
nFiles=$13
nohupOut=$14
nLabs=$15

mRunPc=$(( $nFiles/$mPcs ))


for l in `seq 1 $nLabs`
do
	for z in `seq 1 $mPcs`
	do
		echo "Starting in PC $z"
		
		ssh 10.2."$l"."$z"

		tStartPc=$(( 1 + mRunPc*($z-1) )) 
		tEndPc=$(( $tStartPc + mRunPc))
		
		if [ "$z" -eq "$mPcs" ] 
		then
			tEndPc=$nFiles 
		fi

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
			
			echo "Starting in core $x with files $tStartCore to $tEndCore"

			nhOut=./"$nohupOut""$modType"_"$x" 
	        cmdR="$rPath"completeRun.R
			
			#nohup Rscript "$cmdR" "$tStartCore" "$tEndCore" "$nIter" "$inPath" "$outPath" "$modType" "$rPath" "$fixEf" "$ranEf" "$perPath" "$perVar" "$cstPath" > $nhOut &


		    #For the first core, I waitfor the generation of the permutation 
		    # matrix. 30s should be enough. 
			if [ "$x" -eq 1 ] && [ "$z" -eq 1 ]
			then
				sleep 3s # Waits 30 seconds.
			fi
		done
	done
done