#see who is connected on the cluster
who
#wreck havoc
cat /dev/urandom | write $(who | awk 'NR==1{print $XX}') #XX = user n°XX 
