import os

labos  = [4,7]
compus = [[1,2,3,7,8,9,10,11,12,13,14,15,18,20,21,22],[1,2,3,4,5,6,7]]


for i,l in enumerate(labos):
	print 'En el labo ' + str(l)
	for j,c in enumerate(compus[i]):
		print 'En la compu ' + str(c)

		ip      = '10.2.' + str(l) + "." + str(c)
		fullLine = "ssh " + str(ip) + " -t killall R" 
                
		os.system(fullLine)
