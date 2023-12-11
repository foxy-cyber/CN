set ns [new Simulator]
set tf [open prog2.tr]
$ns trace-all $tf
set nf [open prog2.nam w]
$ns namtrace-all $nf
set cwind [open win2.tr w]
$ns color 1 Blue

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
$ns duplex-link $n1 $n3 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 2Mb 2ms DropTail
$ns duplex-link $n3 $n4 2Mb 2ms DropTail
$ns duplex-link $n4 $n5 2Mb 2ms DropTail
$ns duplex-link $n4 $n6 2Mb 2ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0 
set sink0 [new Agent/TCPSink]
$ns attach-agent $n6 $sink0
$ns connect $tcp0 $sink0

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1
set tel1 [new Application/Telnet]
$tel1 attach-agent $tcp1
$ns at 0.1 "$tel1 start"
$ns at 10 "finish"

proc plotWindow {tcpSource file} {
    global ns 
    set time 0.01 
    set now [$ns now]
    set cwd0 [$tcpSource set cwnd_]
    puts $file "$now $cwd0
    $ns at [expr ]
}
