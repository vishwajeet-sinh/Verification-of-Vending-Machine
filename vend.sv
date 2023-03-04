// An automatically generated Verilog file using al2
// Generated on 18:18:50 Feb 27 2018 PST

// Module definition for vend
module vend(input reg clk,input reg reset,input detect_5 
,input detect_10 ,input detect_25 ,input [8:0] amount ,input buy ,input return_coins 
,input empty_5 ,input empty_10 ,input empty_25 ,output ok ,output return_5 
,output return_10 ,output return_25 );
    reg _out_ok;
    assign ok=_out_ok;
    reg _out_return_5;
    assign return_5=_out_return_5;
    reg _out_return_10;
    assign return_10=_out_return_10;
    reg _out_return_25;
    assign return_25=_out_return_25;
    reg [8:0] acc,acc_d;
    reg [19:0] cnt,cnt_d;
    reg ret_5,ret_5_d;
    reg ret_10,ret_10_d;
    reg ret_25,ret_25_d;
    reg [3:0] sm_state_var,sm_state_var_d;
    reg [3:0] sm_return_var,sm_return_var_d;
    always @(*) begin
        acc_d=acc;
        cnt_d=cnt;
        ret_5_d=ret_5;
        ret_10_d=ret_10;
        ret_25_d=ret_25;
        sm_state_var_d=sm_state_var;
        sm_return_var_d=sm_return_var;
        _out_return_5 = ret_5;
        _out_return_10 = ret_10;
        _out_return_25 = ret_25;
        _out_ok = 1'b0;

        // state machine sm

        sm_state_var_d=sm_state_var;  // state holds value 
        sm_return_var_d=sm_return_var; // return value hold
        case(sm_state_var)
            0 : begin // state Sreset
                cnt_d = 1'b0;
                acc_d = 1'b0;
                ret_5_d = 1'b0;
                ret_10_d = 1'b0;
                ret_25_d = 1'b0;
                sm_state_var_d=1; // goto Sdrop
            end
            1 : begin // state Sdrop
                cnt_d = 1'b0;
                case(1'b1)
                    detect_5 : begin
                        acc_d = acc+3'b101;
                        sm_state_var_d=2; // calls down_5
                        sm_return_var_d=1; // returns to Sdrop
                    end
                    detect_10 : begin
                        acc_d = acc+5'b01010;
                        sm_state_var_d=3; // calls down_10
                        sm_return_var_d=1; // returns to Sdrop
                    end
                    detect_25 : begin
                        acc_d = acc+6'b011001;
                        sm_state_var_d=4; // calls down_25
                        sm_return_var_d=1; // returns to Sdrop
                    end
                    return_coins : begin
                        sm_state_var_d=6; // goto Sreturn_em
                    end
                    buy : begin
                        sm_state_var_d=5; // goto Sbuy
                    end
                endcase
            end
            2 : begin // state down_5
                if(!detect_5) begin
                    cnt_d = cnt+1'b1;
                    if(cnt>$urandom_range(6'b010100,6'b011110)) begin
                        sm_state_var_d=sm_return_var; // return
                    end
                end
            end
            3 : begin // state down_10
                if(!detect_10) begin
                    cnt_d = cnt+1'b1;
                    if(cnt>$urandom_range(6'b010100,6'b011110)) begin
                        sm_state_var_d=sm_return_var; // return
                    end
                end
            end
            4 : begin // state down_25
                if(!detect_25) begin
                    cnt_d = cnt+1'b1;
                    if(cnt>$urandom_range(6'b010100,6'b011110)) begin
                        sm_state_var_d=sm_return_var; // return
                    end
                end
            end
            5 : begin // state Sbuy
                if(acc>=amount) begin
                    _out_ok = 1'b1;
                    cnt_d = cnt+1'b1;
                    if(cnt>$urandom_range(9'b001100100,10'b0011001000)) begin
                        acc_d = acc-amount;
                        sm_state_var_d=6; // goto Sreturn_em
                    end
                end
                else begin
                    sm_state_var_d=1; // goto Sdrop
                end
            end
            6 : begin // state Sreturn_em
                cnt_d = 1'b0;
                if(acc>1'b0) begin
                    if(!empty_25&&acc>=6'b011001) begin
                        ret_25_d = 1'b1;
                        acc_d = acc-6'b011001;
                        sm_state_var_d=7; // calls Sret_pulse
                        sm_return_var_d=6; // returns to Sreturn_em
                    end
                    else begin
                        if(!empty_10&&acc>=5'b01010) begin
                            ret_10_d = 1'b1;
                            acc_d = acc-5'b01010;
                            sm_state_var_d=7; // calls Sret_pulse
                            sm_return_var_d=6; // returns to Sreturn_em
                        end
                        else begin
                            if(!empty_5&&acc>=3'b101) begin
                                ret_5_d = 1'b1;
                                acc_d = acc-3'b101;
                                sm_state_var_d=7; // calls Sret_pulse
                                sm_return_var_d=6; // returns to Sreturn_em
                            end
                            else begin
                                acc_d = 1'b0;
                                sm_state_var_d=1; // goto Sdrop
                            end
                        end
                    end
                end
                else begin
                    cnt_d = 1'b0;
                    acc_d = 1'b0;
                    sm_state_var_d=1; // goto Sdrop
                end
            end
            7 : begin // state Sret_pulse
                if(cnt>$urandom_range(13'b0001111101000,14'b00011111010000)) begin
                    ret_5_d = 1'b0;
                    ret_10_d = 1'b0;
                    ret_25_d = 1'b0;
                    cnt_d = 1'b0;
                    sm_state_var_d=8; // goto Srec_pulse
                end
                else begin
                    cnt_d = cnt+1'b1;
                end
            end
            8 : begin // state Srec_pulse
                if(cnt>$urandom_range(13'b0001111101000,17'b00010011100010000)) begin
                    sm_state_var_d=sm_return_var; // return
                    cnt_d = 1'b0;
                end
                else begin
                    cnt_d = cnt+1'b1;
                end
            end
        endcase // ending state machine sm_state_var

    end
    always @(posedge(clk) or posedge(reset)) begin
        if(reset) begin
            acc <= 0;
            cnt <= 0;
            ret_5 <= 0;
            ret_10 <= 0;
            ret_25 <= 0;
            sm_state_var <= 0;
            sm_return_var <= 0;
        end else begin
            acc<= #1 acc_d;
            cnt<= #1 cnt_d;
            ret_5<= #1 ret_5_d;
            ret_10<= #1 ret_10_d;
            ret_25<= #1 ret_25_d;
            sm_state_var<= #1 sm_state_var_d;
            sm_return_var<= #1 sm_return_var_d;
        end
    end
endmodule
