#!/bin/bash



pause="20"

addplot(){


gnuplot /app/plot.gp
}


#command -v curl >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
#command -v gnuplot  >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }

#flags=0
#COU=0
URL=http://www.google.com;
 while true ; do
#         let COU=$(($COU+1))
        a=$(curl -L -w %{speed_download} -o/dev/null -s $URL);
        d=$(date +%d/%m/%y%t%H:%M:%S)
        echo $d";"$a>> /var/www/html/bps.dat
        addplot
        sleep ${pause}
done


