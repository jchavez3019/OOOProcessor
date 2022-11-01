module cdb (  input tomasula_types::ctl_word ctl [8],
                    input enable [8],
                    input rst [8],
                    output tomasula_types::ctl_word out [8],
                    );

    cdb_latch latch0(
        .control(ctl[0]),
        .en(enable[0]),
        .rstn(rst[0]),
        .q(out[0])
    );

    cdb_latch latch1(
        .control(ctl[1]),
        .en(enable[1]),
        .rstn(rst[1]),
        .q(out[1])
    );

    cdb_latch latch2(
        .control(ctl[2]),
        .en(enable[2]),
        .rstn(rst[2]),
        .q(out[2])
    );

    cdb_latch latch3()
        .control(ctl[3]),
        .en(enable[3]),
        .rstn(rst[3]),
        .q(out[3])
    );

    cdb_latch latch4(
        .control(ctl[4]),
        .en(enable[4]),
        .rstn(rst[4]),
        .q(out[4])
    );

    cdb_latch latch5(
        .control(ctl[5]),
        .en(enable[5]),
        .rstn(rst[5]),
        .q(out[5])
    );

    cdb_latch latch6(
        .control(ctl[6]),
        .en(enable[6]),
        .rstn(rst[6]),
        .q(out[6])
    );

    cdb_latch latch7(
        .control(ctl[7]),
        .en(enable[7]),
        .rstn(rst[7]),
        .q(out[7])
    );


endmodule