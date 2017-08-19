import os

labos  = [1,3,4,6,7]
compus = [[1,3,9,13],[2,4,5,6,7,8,9,10],[2,3],[1],[1,2,3,10,11,13,16,18,23,24,25]]

for i,l in enumerate(labos):
	print 'En el labo ' + str(l)
	for j,c in enumerate(compus[i]):
		print 'En la compu ' + str(c)

		ip      = '10.2.' + str(l) + "." + str(c)
		fullLine = "ssh " + str(ip) + " -t killall R" 
                
		os.system(fullLine)
