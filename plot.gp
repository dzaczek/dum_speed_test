#!/usr/bin/gnuplot 

#timeex=1
#command -v curl >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
#command -v gnuplot  >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }

#pause=5
#flags=0
#COU=0
#URL=http://www.google.com;
 #while [ $COU -lt $timeex ] ; do
#	 let COU=$(($COU+1))
#	a=$(curl -L -w %{speed_download} -o/dev/null -s $URL);
#	d=$(date +%d/%m/%y%t%H:%M:%S)
#	echo $d";"$a>>/var/www/html/bps.dat
#	sleep ${pause}
#done

#intime(COL) = strptime("%H:%M:%S",strcol(COL))
set datafile separator ";"
stats '/var/www/html/bps.dat' using 2

set term png background "#330000" size 2560, 1080 \
# font "/usr/share/fonts/truetype/msttcorefonts/Arial.ttf,10"


 #######################



 ##############################
set autoscale xfix
 set output "/var/www/html/speedtest.png"
set multiplot layout 2,1
set title "Analysing speed WAN\nwith date curl -L -w google.com "  textcolor linestyle 1
####W
 stats '/var/www/html/bps.dat' using 2 prefix "A"

set xdata time
#set style fill solid 1.0
set datafile separator ";"
set xlabel "Date\nTime" textcolor linestyle 1
set timefmt "%d/%m/%y %H:%M:%S"
set format x "%H:%M:%S\n%d/%m"
set yrange [ 0 : ]
set xdata time
set autoscale  x
set ylabel "Speeed \nbytes/s" textcolor linestyle 1
set grid







##colors
# Define custom display styles
set style line 1 lt 1 lc rgb "#FFCC66"
set style line 2 lt 2 lc rgb "#FF00FF" pt 6
set style line 3 lc rgb "#FFFFFF"

# Axis tic marks
set xtics textcolor linestyle 3
set key tc ls 3
set bmargin  8

set ytics  textcolor linestyle 1
set y2tics textcolor linestyle 2
#y2 mbit
set y2label "Speeed \nMegabytes/s" textcolor linestyle 1
set tics nomirror
FACTOR=0.001
set link y2 via FACTOR*y inverse y/FACTOR
#average
# number of points in moving average
n = 60

# initialize the variables
do for [i=1:n] {
    eval(sprintf("back%d=0", i))
}

# build shift function (back_n = back_n-1, ..., back1=x)
shift = "("
do for [i=n:2:-1] {
    shift = sprintf("%sback%d = back%d, ", shift, i, i-1)
}
shift = shift."back1 = x)"
# uncomment the next line for a check
# print shift

# build sum function (back1 + ... + backn)
sum = "(back1"
do for [i=2:n] {
    sum = sprintf("%s+back%d", sum, i)
}
sum = sum.")"
# uncomment the next line for a check
# print sum

# define the functions like in the gnuplot demo
# use macro expansion for turning the strings into real functions
samples(x) = $0 > (n-1) ? n : ($0+1)

avg_n(x) = (shift_n(x), @sum/samples($0))
shift_n(x) = @shift
#plot
set autoscale xfix
##################################
#set style line 4 lt 2 lc rgb "green" lw 2
set label 4 'set style line 4 lt 2 lc rgb "#90EE90" lw 2'  at -0.4, -0.55 tc rgb "#90EE90"
set label 5 'set style line 5 lt 2 lc rgb "#009E60" lw 2'  at -0.4, -0.55 tc rgb "white"
##################################
plot '/var/www/html/bps.dat'  using   1:2 t 'bytes/s' w points, '/var/www/html/bps.dat' using 1:(avg_n($2)) w l lc rgb "red" lw 2 title "avg 60 probs(10 minutes)", A_mean  ls 4  title "  Mean",  A_median  ls 5  title "  Median"



set title "Averages"
set xdata time
set timefmt "%d/%m/%y %H:%M:%S"
#set format x "%H\n%d/%m"
#set style data histogram
#set style fill solid
#set key autotitle column
set autoscale x
set autoscale xfix
#binwidth = 0.1
#set boxwidth binwidth
#sum = 0
n = 6
nn = 360
# initialize the variables
do for [i=1:n] {
    eval(sprintf("back%d=0", i))
}

# build shift function (back_n = back_n-1, ..., back1=x)
shift = "("
do for [i=n:2:-1] {
    shift = sprintf("%sback%d = back%d, ", shift, i, i-1)
}
shift = shift."back1 = x)"
# uncomment the next line for a check
# print shift

# build sum function (back1 + ... + backn)
sum = "(back1"
do for [i=2:n] {
    sum = sprintf("%s+back%d", sum, i)
}
sum = sum.")"
samples(x) = $0 > (n-1) ? n : ($0+1)

avg_n(x) = (shift_n(x), @sum/samples($0))
shift_n(x) = @shift

#######################
do for [r=1:nn] {
    eval(sprintf("backw%d=0", r))
}

# build shift function (back_n = back_n-1, ..., back1=x)
shiftw = "("
do for [r=nn:2:-1] {
    shiftw = sprintf("%sbackw%d = backw%d, ", shiftw, r, r-1)
}
shiftw = shiftw."backw1 = tt)"
# uncomment the next line for a check
# print shift

# build sum function (back1 + ... + backn)
sumw = "(backw1"
do for [r=2:nn] {
    sumw = sprintf("%s+backw%d", sumw, r)
}
sumw = sumw.")"
samplesw(tt) = $0 > (nn-1) ? nn : ($0+1)

avg_nw(tt) = (shift_nw(tt), @sumw/samplesw($0))
shift_nw(tt) = @shiftw
#######################


#######################
plot '/var/www/html/bps.dat' using 1:(avg_n($2)) w  dots lc rgb "red" lw 2 title "avg 6 probs(1 minutes)", '/var/www/html/bps.dat' using 1:(avg_nw($2)) w  dots lc rgb "green" lw 2 title "avg 360 probs(1 hour)"

#set title "Histogram"#
#set style data histogram
#set style fill solid
#binwidth=40
#bin(x,width)=width*floor(x/width)
#set datafile separator ";"
#plot '/var/www/html/bps.dat' using 2 smooth freq with boxes
unset multiplot
reset
