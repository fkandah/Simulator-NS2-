#Make a NS simulator 
set ns [new Simulator]        

# Define a 'finish' procedure
proc finish {} {
   exit 0
}

# Create the nodes:
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Create the links:
$ns duplex-link $n0 $n2   2Mb  10ms DropTail
$ns duplex-link $n1 $n2   2Mb  10ms DropTail
$ns duplex-link $n2 $n3 0.3Mb 200ms DropTail
$ns duplex-link $n3 $n4 0.5Mb  40ms DropTail
$ns duplex-link $n3 $n5 0.5Mb  30ms DropTail

# Add a TCP sending module to node n0
set tcp1 [new Agent/TCP/Reno]
$ns attach-agent $n0 $tcp1

# Add a TCP receiving module to node n4
set sink1 [new Agent/TCPSink]
$ns attach-agent $n4 $sink1

# Direct traffic from "tcp1" to "sink1"
$ns connect $tcp1 $sink1

# Setup a FTP traffic generator on "tcp1"
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP               

# Schedule start/stop times
$ns at 0.1   "$ftp1 start"
$ns at 100.0 "$ftp1 stop"

# Set simulation end time
$ns at 125.0 "finish"            


##################################################
## Obtain CWND from TCP agent
##################################################

proc plotWindow {tcpSource outfile} {
   global ns

   set now [$ns now]
   set cwnd [$tcpSource set cwnd_]

###Print TIME CWND   for  gnuplot to plot progressing on CWND   
   puts  $outfile  "$now $cwnd"

   $ns at [expr $now+0.1] "plotWindow $tcpSource  $outfile"
}

set outfile [open  "WinFile"  w]


$ns  at  0.0  "plotWindow $tcp1  $outfile"



# Run simulation !!!!
$ns run
