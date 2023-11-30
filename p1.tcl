
set ns [new Simulator]
set tf [open ex1.tr w]

$ns trace-all $tf

set nf [open ex1.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 10ms DropTail

#$ns queue-limit $n0 $n1 5

set udp1 [new Agent/UDP]
$ns attach-agent $n0 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n3 $null1
$ns connect $udp1 $null1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$ns at 1.1 "$cbr1 start"

set tcp [new Agent/TCP]
$ns attach-agent $n3 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink


set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.1 "$ftp start"
$ns at 10.0 "finish"

proc finish { } {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	puts "Running nam...."
	exec nam ex1.nam &
	exit 0
      }
$ns run


