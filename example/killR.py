import os

labos  = [2,6,7]
compus = [[2,3,4],[1,4,7,8,10,12,13,14,15,18,19,20,22,23,24],[2,5,10,11,16,20,24,25]]

for i,l in enumerate(labos):
	print 'En el labo ' + str(l)
	for j,c in enumerate(compus[i]):
		print 'En la compu ' + str(c)

		ip      = '10.2.' + str(l) + "." + str(c)
		fullLine = "ssh " + str(ip) + " -t killall R" 
                
		os.system(fullLine)
