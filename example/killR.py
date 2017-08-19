import os

labos    = [1,2,3]
compus   = [[5,6,7,8,9,16,18,19], [1,3,4,8,10,11,12,15,16,17,18,19], [2,4,5,6,7,10]]

for i,l in enumerate(labos):
	print 'En el labo ' + str(l)
	for j,c in enumerate(compus[i]):
		print 'En la compu ' + str(c)

		ip      = '10.2.' + str(l) + "." + str(c)
		fullLine = "ssh " + str(ip) + " -t killall R" 
                
		os.system(fullLine)
