set ns [new Simulator -multicast on]


set tf [open mcast.tr w]
$ns trace-all $tf


set fd [open mcast.nam w]
$ns namtrace-all $fd
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]


$ns duplex-link $n0 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n7 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 10ms DropTail


set mproto DM
set mrthandle [$ns mrtproto $mproto {}]


set group1 [Node allocaddr]
set group2 [Node allocaddr]


set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
$udp0 set dst_addr_ $group1
$udp0 set dst_port_ 0
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0


set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
$udp1 set dst_addr_ $group2
$udp1 set dst_port_ 0
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp1


set revr1 [new Agent/Null]
$ns attach-agent $n2 $revr1
$ns at 1.0 "$n2 join-group $revr1 $group1"

set revr2 [new Agent/Null]
$ns attach-agent $n3 $revr2
$ns at 1.5 "$n3 join-group $revr2 $group1"

set revr3 [new Agent/Null]
$ns attach-agent $n4 $revr3
$ns at 2.0 "$n4 join-group $revr3 $group1"


set revr4 [new Agent/Null]
$ns attach-agent $n5 $revr4
$ns at 2.5 "$n5 join-group $revr4 $group2"

set revr5 [new Agent/Null]
$ns attach-agent $n6 $revr5
$ns at 3.0 "$n6 join-group $revr5 $group2"

set revr6 [new Agent/Null]
$ns attach-agent $n7 $revr6
$ns at 3.5 "$n7 join-group $revr6 $group2"

$ns at 4.0 "$n2 leave-group $revr1 $group1"
$ns at 4.5 "$n3 leave-group $revr2 $group1"
$ns at 5.0 "$n4 leave-group $revr3 $group1"

$ns at 5.5 "$n5 leave-group $revr4 $group2"
$ns at 6.0 "$n6 leave-group $revr5 $group2"
$ns at 6.5 "$n7 leave-group $revr6 $group2"


$ns at 0.5 "$cbr1 start"
$ns at 9.5 "$cbr1 stop"

$ns at 0.5 "$cbr2 start"
$ns at 9.5 "$cbr2 stop"

$ns at 10.0 "finish"

proc finish {} {
global ns tf fd
$ns flush-trace
close $tf
close $fd
exec nam mcast.nam &
exit 0
}
$n0 label "Source 1"
$udp0 set fid_ 1
$n1 label "Source 2"
$udp1 set fid_ 2
$ns color 1 red 
$ns color 1 green
$n5 label "Receiver 1"
$n5 color blue
$n6 label "Receiver 2"
$n5 color blue
$n7 label "Receiver 3"
$n7 color blue

$ns run
