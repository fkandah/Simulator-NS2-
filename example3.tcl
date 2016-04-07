
#Create a new simulator
set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

#Create an output file
set nf [open out.nam w]
$ns namtrace-all $nf


#Close the file after finish
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam & 
	exit 0
}

#Create nodes
for {set i 0} {$i < 7} {incr i} {
   set n($i) [$ns node]
}

#Add links
for {set i 0} {$i < 7} {incr i} {
  $ns duplex-link $n($i) $n([expr ($i+1)%7]) 1Mb 10ms DropTail
}


#The next step is to send some data from node n(0) to node n(3).

#Create a UDP agent and attach it to node n(0)
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0

# Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $n(3) $null0

$ns connect $udp0 $null0

#Drop link n1 - n2 (link failure)
$ns rtmodel-at 1.0 down $n(1) $n(2)
$ns rtmodel-at 2.0 up $n(1) $n(2)

#Create rerouting
$ns rtproto DV

$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"


#Simulation time
$ns at 5.0 "finish"


#Run the simulation
$ns run

