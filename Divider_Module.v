`timescale 1ns/1ns

module Divider_Module(clk,rst,div_a,div_b,div_res);

    input [31:0] div_a;
    input [31:0] div_b;
    output [31:0] div_res;

    input clk;
    input rst;

    reg [3:0] state;

    parameter   unpack        = 4'd0,
                special_cases = 4'd1,
                normalise_a   = 4'd2,
                normalise_b   = 4'd3,
                divide_0      = 4'd4,
                divide_1      = 4'd5,
                divide_2      = 4'd6,
                divide_3      = 4'd7,
                normalise_1   = 4'd8,
                normalise_2   = 4'd9,
                round         = 4'd10,
                pack          = 4'd11;

    reg       [31:0] a, b, z;
    reg       [23:0] a_m, b_m, z_m;
    reg       [9:0] a_e, b_e, z_e;
    reg       a_s, b_s, z_s;
    reg       guard, round_bit, sticky;
    reg       [50:0] quotient, divisor, dividend, remainder;
    reg       [5:0] count;

    always@(div_a or div_b)
    begin
        if(rst)
        begin
            state <= unpack;
            a <= 32'b0;
            b <= 32'b0;
            z <= 32'b0;
        end

        else
        begin
            case (state)
                
                 //Unpacking of inputs and separation of Sign, Exponent and Mantessa bits.
                unpack:
				begin

					a <= div_a;
					b <= div_b;

					a_m <= a[22:0];
					b_m <= b[22:0];
					a_e <= a[30:23] - 127;
					b_e <= b[30:23] - 127;
					a_s <= a[31];
					b_s <= b[31];
					state <= special_cases;
				end

                special_cases:
                begin
                    //if a is NaN or b is NaN return NaN 
                    if ((a_e == 128 && a_m != 0) || (b_e == 128 && b_m != 0))
                        begin
                        z[31] <= 1;
                        z[30:23] <= 255;
                        z[22] <= 1;
                        z[21:0] <= 0;
                        state <= pack;
                    end

                     //if a is inf and b is inf return NaN 
                    else if ((a_e == 128) && (b_e == 128))
                    begin
                        z[31] <= 1;
                        z[30:23] <= 255;
                        z[22] <= 1;
                        z[21:0] <= 0;
                        state <= pack;
                    end
                    
                    //if a is inf return inf
                    else if (a_e == 128) 
                        begin
                            z[31] <= a_s ^ b_s;
                            z[30:23] <= 255;
                            z[22:0] <= 0;
                            state <= pack;
                        

                            //if b is zero return NaN
                            if ($signed(b_e == -127) && (b_m == 0)) 
                            begin
                                z[31] <= 1;
                                z[30:23] <= 255;
                                z[22] <= 1;
                                z[21:0] <= 0;
                                state <= pack;
                            end
                    end
                    
                    //if b is inf return zero
                    else if (b_e == 128) 
                    begin
                        z[31] <= a_s ^ b_s;
                        z[30:23] <= 0;
                        z[22:0] <= 0;
                        state <= pack;
                    end
                    
                    //if a is zero return zero
                    else if (($signed(a_e) == -127) && (a_m == 0))
                    begin
                        z[31] <= a_s ^ b_s;
                        z[30:23] <= 0;
                        z[22:0] <= 0;
                        state <= pack;
                    
                    
                        //if b is zero return NaN
                        if (($signed(b_e) == -127) && (b_m == 0)) 
                        begin
                            z[31] <= 1;
                            z[30:23] <= 255;
                            z[22] <= 1;
                            z[21:0] <= 0;
                            state <= pack;
                        end
                    end

                    //if b is zero return inf
                    else if (($signed(b_e) == -127) && (b_m == 0)) 
                    begin
                        z[31] <= a_s ^ b_s;
                        z[30:23] <= 255;
                        z[22:0] <= 0;
                        state <= pack;
                        end else begin
                        //Denormalised Number
                        if ($signed(a_e) == -127) begin
                            a_e <= -126;
                        end else begin
                            a_m[23] <= 1;
                        end
                        //Denormalised Number
                        if ($signed(b_e) == -127) begin
                            b_e <= -126;
                        end else begin
                            b_m[23] <= 1;
                        end
                        state <= normalise_a;
                    end
                end

                normalise_a:
                begin
                    if(a_m[23])
                        state <= normalise_b;
                    else
                    begin
                        a_m <= a_m << 1;
                        a_e <= a_e - 1;
                    end
                end

                normalise_b:
                begin
                    if(b_m[23])
                        state <= divide_0;
                    else
                    begin
                        b_m <= b_m << 1;
                        b_m <= b_m - 1;
                    end
                end

                divide_0:
                begin
                    z_s <= a_s ^ b_s;
                    z_e <= a_e - b_e;
                    quotient <= 0;
                    remainder <= 0;
                    count <= 0;
                    dividend <= a_m << 27;
                    divisor <= b_m;
                    state <= divide_1;
                end

                divide_1:
                begin
                    quotient <= quotient << 1;
                    remainder <= remainder << 1;
                    remainder[0] <= dividend[50];
                    dividend <= dividend << 1;
                    state <= divide_2;
                end

                divide_2:
                begin
                    if(remainder >= divisor)
                    begin
                        quotient[0] <= 1;
                        remainder <= remainder - divisor;
                    end

                    if(count == 49)
                        state <= divide_3;
                    else
                    begin
                        count <= count + 1;
                        state <= divide_1;
                    end
                end

                divide_3:
                begin
                    z_m <= quotient[26:3];
                    guard <= quotient[2];
                    round_bit <= quotient[1]; 
                    sticky <= quotient[0] | (remainder != 0);
                    state <= normalise_1;
                end

                normalise_1:
                begin
                    if(z_m[23] == 0 && $signed(z_e) > -126)
                    begin
                        z_e <= z_e - 1;
                        z_m <= z_m << 1;
                        z_m[0] <= guard;
                        guard <= round_bit;
                        round_bit <= 0;
                    end

                    else
                        state <= normalise_2;
                end

                normalise_2:
                begin
                    if($signed(z_e) < -126)
                    begin
                        z_e <= z_e + 1;
                        z_m <= z_m >> 1;
                        guard <= z_m[0];
                        round_bit <= guard;
                        sticky <= sticky | round_bit;
                    end

                    else
                        state <= round;
                end

                round:
                begin
                    if(guard && (round_bit | sticky | z_m[0]))
                    begin
                        z_m <= z_m + 1;
                        if(z_m == 24'hffffff)
                            z_e <= z_e + 1;
                    end

                    state <= pack;
                end

                pack:
                begin
                    z[22:0] <= z_m[22:0];
                    z[30:23] <= z_e[7:0] + 127;
                    z[31] <= z_s;

                    if($signed(z_e) == -126 && z[23] == 0)
                        z[30:23] <= 0;
                    
                    // If overflow occurs, return inf
                    if($signed(z_e) > 127)
                    begin
                        z[22:0] <= 0;
                        z[30:23] <= 255;
                        z[31] <= z_s;
                    end

                    state <= unpack;
                end

                default: state <= unpack; 
            endcase
        end
    end

    assign div_res[31:0] = z[31:0];

endmodule 
