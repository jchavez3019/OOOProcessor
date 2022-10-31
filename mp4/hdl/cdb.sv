module cdb_latch (  
                    input tomasula_types::ctl_word control1,
                    input en1,
                    input rstn1,
                    output tomasula_types::ctl_word q1,
                    input tomasula_types::ctl_word control2,
                    input en2,
                    input rstn2,
                    output tomasula_types::ctl_word q2,
                    input tomasula_types::ctl_word control3,
                    input en3,
                    input rstn3,
                    output tomasula_types::ctl_word q3,
                    input tomasula_types::ctl_word control4,
                    input en4,
                    input rstn4,
                    output tomasula_types::ctl_word q4,
                    input tomasula_types::ctl_word control5,
                    input en5,
                    input rstn5,
                    output tomasula_types::ctl_word q5,
                    input tomasula_types::ctl_word control6,
                    input en6,
                    input rstn6,
                    output tomasula_types::ctl_word q6,
                    input tomasula_types::ctl_word control7,
                    input en7,
                    input rstn7,
                    output tomasula_types::ctl_word q7,
                    input tomasula_types::ctl_word control8,
                    input en8,
                    input rstn8,
                    output tomasula_types::ctl_word q8,
                    );

always @ (en1 | rstn1 | ctl_word1) begin
    if(!rst1) begin
        q1 <= 0;
    else
        if(en1)
            q1 <= d1;
    end
    if(!rst2) begin
        q2 <= 0;
    else
        if(en2)
            q2 <= d2;
    end

    if(!rst3) begin
        q3 <= 0;
    else
        if(en3)
            q3 <= d3;
    end
    if(!rst4) begin
        q4 <= 0;
    else
        if(en4)
            q4 <= d4;
    end
    if(!rst5) begin
        q5 <= 0;
    else
        if(en5)
            q5 <= d5;
    end
    if(!rst6) begin
        q6 <= 0;
    else
        if(en6)
            q6 <= d6;
    end
    if(!rst7) begin
        q7 <= 0;
    else
        if(en7)
            q7 <= d7;
    end
    if(!rst8) begin
        q8 <= 0;
    else
        if(en8)
            q8 <= d8;
    end
end

endmodule