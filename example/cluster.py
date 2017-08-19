import os

labos  = [1,3,4,6,7]
compus = [[1,3,9,13],[2,4,5,6,7,8,9,10],[2,3],[1],[1,2,3,10,11,13,16,18,23,24,25]]

npcs     = sum(len(c) for c in compus)
totFiles = 104
filesPc  = totFiles / npcs

count = 0
for i,l in enumerate(labos):
	print 'En el labo ' + str(l)
	for j,c in enumerate(compus[i]):
		print 'En la compu ' + str(c)

		ip      = '10.2.' + str(l) + "." + str(c)
		nIter	= '500'
		inPath	= '"~/Bruno_R/csv_103/"'
		outPath	= '"~/lmm_results_500/across2/"'
		modType	= '"lmm"'
		rPath	= '"~/CuBaPeTo/R_functions/"'
		fixEf	= '"\\"freq + palnum:tipo + pred:tipo\\""'
		ranEf	= '"\\"(1|suj_id) + (1|pal)\\""'
		perPath	= '"~/Bruno_R/permutations/"'
		perVar	= '"across"'
		cstPath	= '"~/Bruno_R/cstFuns/"'
		nCores	= '4'
		nFiles	= str(filesPc)
		nohupOut= '"\"~/Bruno_R/nohup/' + str(l) + "/" + str(c) + '_\""'
		start   = filesPc * count + 1
		end     = start + filesPc + 1 
		filesCP = [inPath + 't' + str(x) + '.csv' for x in range(start,end)]

		fullLineCp = ["ssh " + str(ip) + " -t cp " + x + ' /tmp/' for x in filesCP]

		tmp = [os.system(x) for x in fullLineCp]
		inPath	= '"/tmp/"'

		pars = [nIter, inPath, outPath, modType, rPath, fixEf,
		        ranEf, perPath, perVar, cstPath, nCores, nFiles, nohupOut, str(start)]

		parStr = " ".join(pars)
		fullLine = "ssh " + str(ip) + " -t sh ~/CuBaPeTo/bash_functions/runParallelCores.sh " + parStr
                
		#print fullLine
		os.system(fullLine)
		count = count + 1

