namespace eval ::namd::rx {namespace export run}
source module/rx/replicaNeighbor-0.1.0.tm
source module/rx/exchange-0.1.0.tm
source module/tk/io/write-0.1.0.tm
source module/tk/io/appendln-0.1.0.tm


#----------------------------------------------------
# NAMD Replica Exchange
#----------------------------------------------------
proc ::namd::rx::run {params} {
    set defaults [dict create \
        restart undefined \
        steps [dict create \
            total undefined \
            block undefined \
        ] \
        output  undefined \
        grids {} \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::rx::run"
    set p [dict merge $defaults $params]

    set log_file [dict get $p output]
    
    # total number of MD steps
    set total_steps [dict get $p steps total]

    # number of steps between replica exchanges
    set block_steps [dict get $p steps block]


    ::replicaBarrier
    set rInfo [::namd::rx::replicaNeighbor]
    
    set ccc 0

    ::namd::tk::io::write $log_file ""

    while {$ccc < $total_steps} {
        ::run $block_steps

        puts "======================================"
        puts "exchange"
        puts [::callback ::namd::rx::exchange?]
        puts "======================================"
        incr ccc $block_steps

        ::namd::tk::io::appendln $log_file [join \
            [list \
                $ccc \
                [myReplica] \
            ] \
            " " \
        ]
    }

    ::replicaBarrier
}
