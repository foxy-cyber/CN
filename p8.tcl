set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(x) 500
set val(y) 500
set val(ifqlen) 50
set val(nn) 25
set val(sc) "/home/student/Desktop/ns-allinone-2.35/ns-2.35/indep-utils/cmu-scen-gen/setdest/mob"
set val(cp) "/home/student/Desktop/ns-allinone-2.35/ns-2.35/indep-utils/cmu-scen-gen/static"
set val(rp) AODV
set val(stop) 100.0
set ns_ [new Simulator]
set tracefd [open 003.tr w]
$ns_ trace-all $tracefd

set namtrace [open 003.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)
set prop [new $val(prop)]
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god_ [create-god $val(nn)]
$ns_ node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routeTrace ON \
-macTrace ON \

for { set i 0 } { $i < $val(nn) } { incr i } {
set node_($i) [$ns_ node]
$node_($i) random-motion 0
}
for { set i 0 } { $i < $val(nn) } { incr i } {
set xx [expr rand()*500]
set yy [expr rand()*400]
$node_($i) set X_ $xx
$node_($i) set Y_ $yy
}

for { set i 0 } { $i < $val(nn) } { incr i } {
$ns_ initial_node_pos $node_($i) 40
}
puts "Loading scanerio file..."
source $val(sc)
puts "Loading connection file..."
source $val(cp)

for { set i 0 } { $i < $val(nn) } { incr i } {
$ns_ at $val(stop) "$node_($i) reset";
}
$ns_ at $val(stop) "puts \" NS EXITING...\"; $ns_ halt"

puts "Starting simulation"
$ns_ run


#cmu-scen-gen$ ns cbrgen.tcl -type tcp -nn 25 -seed 1 -mc 10 -rate 10 >static
#cd setdest/
#cmu-scen-gen/setdest$ set setdest
#setdest -v 1 -n 25 -p 10 -M 10 -t 100 -x 500 -y 500 >mob