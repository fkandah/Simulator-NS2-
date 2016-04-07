
#Create a new simulator
set ns [new Simulator]

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
set n0 [$ns node]
set n1 [$ns node]

#Add a link between n0 and n1
$ns duplex-link $n0 $n1 1Mb 10ms DropTail


#Create a UDP agent and attach it to node n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0


#Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#Create a traffic sink and attach it to node n1
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0

#Connect the agents together
$ns connect $udp0 $null0

#When to start and stop sending packets
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"


#Simulation time
$ns at 5.0 "finish"


#Run the simulation
$ns run

