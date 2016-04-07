
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
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#Add a link between n0 and n1
$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n3 $n2 1Mb 10ms DropTail

#Create the layout
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

#Create a UDP agent and attach it to node n0
set udp0 [new Agent/UDP]
$udp0 set class_ 1
$ns attach-agent $n0 $udp0


#Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#Create a UDP agent and attach it to node n0
set udp1 [new Agent/UDP]
$udp1 set class_ 2
$ns attach-agent $n1 $udp1


#Create a CBR traffic source and attach it to udp0
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

#Create a traffic sink and attach it to node n3
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0

#Connect the agents together
$ns connect $udp0 $null0
$ns connect $udp1 $null0


#Monitor the queue for link $n2 - $n3
$ns duplex-link-op $n2 $n3 queuePos 0.5

#When to start and stop sending packets
$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$cbr1 start"
$ns at 4.0 "$cbr1 stop"
$ns at 4.5 "$cbr0 stop"


#Simulation time
$ns at 5.0 "finish"


#Run the simulation
$ns run

