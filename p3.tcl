set ns [new Simulator]
set tf [open ex4.tr w]
$ns trace-all $tf
set nf [open ex4.nam w]
$ns namtrace-all $nf
set cwind [open win4.tr w]
$ns color 1 Blue
$ns color 2 Red

$ns rtproto DV

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 0.3Mb 10ms DropTail
$ns duplex-link $n0 $n2 0.3Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.3Mb 10ms DropTail
$ns duplex-link $n1 $n4 0.3Mb 10ms DropTail
$ns duplex-link $n3 $n5 0.5Mb 10ms DropTail
$ns duplex-link $n4 $n5 0.5Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n4 orient right
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n4 $n5 orient right-down
$ns duplex-link-op $n3 $n5 orient right-up

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp 
set sink [new Agent/TCPSink]
$ns attach-agent $n5 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns rtmodel-at 1.0 down $n1 $n4
$ns rtmodel-at 3.0 up $n1 $n4
$ns at 0.1 "$ftp start"
$ns at 12.0 "finish"

proc plotWindow { tcpSource file } {
    global ns
    set time 0.01
    set now [$ns now]
    set cwnd [$tcpSource set cwnd_]
    puts $file "$now $cwnd"
    $ns at [expr $now+$time] "plotWindow $tcpSource $file"
}
$ns at 1.0 "plotWindow $tcp $cwind"
proc finish { } {
    global ns tf nf cwind
    $ns flush-trace
    close $tf 
    close $nf 
    exec nam ex4.nam &
    exec xgraph win4.tr &
    exit 0
}
$ns run



