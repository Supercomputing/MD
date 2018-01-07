namespace eval ::namd::rx {}

#--------------------------------------------------------
# Create a dictionary of information of this replica
#--------------------------------------------------------
proc ::namd::rx::createReplicaInfo {} {
    set here   [::myReplica]
    set lower  [expr $here - 1]
    set higher [expr $here + 1]

    if {[expr [::myReplica] + 1] < [::numReplicas]} {
        set right $higher
    } else {
        set right $here
    }

    if {[::myReplica] > 0} {
        set left $lower
    } else {
        set left $here
    }

    return [dict create \
        address $here \
        replica $here \
        L [dict create \
            address $left \
            replica $left \
          ] \
        R [dict create \
            address $right \
            replica  $right \
          ] \
    ]
}
