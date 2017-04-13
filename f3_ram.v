module f3_ram(
input wire [3:0] offset_pos_x,
input wire [3:0] offset_pos_y,
input wire [3:0] ram_write_pos,
input wire ram_write_horizontal,
input wire ram_write_increase,
input wire ram_write,
input wire ram_reset,
input wire sysclk,
output reg [3:0] offset_x,
output reg [3:0] offset_y,
output reg ram_offset_all_zero);

reg [3:0] x_offsets_0,
          x_offsets_1,
          x_offsets_2,
          x_offsets_3,
          x_offsets_4,
          x_offsets_5,
          x_offsets_6,
          x_offsets_7,
          x_offsets_8,
          x_offsets_9,
          x_offsets_10,
          x_offsets_11,
          x_offsets_12,
          x_offsets_13,
          x_offsets_14,
          x_offsets_15,
          y_offsets_0,
          y_offsets_1,
          y_offsets_2,
          y_offsets_3,
          y_offsets_4,
          y_offsets_5,
          y_offsets_6,
          y_offsets_7,
          y_offsets_8,
          y_offsets_9,
          y_offsets_10,
          y_offsets_11,
          y_offsets_12,
          y_offsets_13,
          y_offsets_14,
          y_offsets_15;

reg offset_all_zero;
          
task reset_ram;
    begin
        x_offsets_0  <= 0;
        x_offsets_1  <= 0;
        x_offsets_2  <= 0;
        x_offsets_3  <= 0;
        x_offsets_4  <= 0;
        x_offsets_5  <= 0;
        x_offsets_6  <= 0;
        x_offsets_7  <= 0;
        x_offsets_8  <= 0;
        x_offsets_9  <= 0;
        x_offsets_10 <= 0;
        x_offsets_11 <= 0;
        x_offsets_12 <= 0;
        x_offsets_13 <= 0;
        x_offsets_14 <= 0;
        x_offsets_15 <= 0;
        y_offsets_0  <= 0;
        y_offsets_1  <= 0;
        y_offsets_2  <= 0;
        y_offsets_3  <= 0;
        y_offsets_4  <= 0;
        y_offsets_5  <= 0;
        y_offsets_6  <= 0;
        y_offsets_7  <= 0;
        y_offsets_8  <= 0;
        y_offsets_9  <= 0;
        y_offsets_10 <= 0;
        y_offsets_11 <= 0;
        y_offsets_12 <= 0;
        y_offsets_13 <= 0;
        y_offsets_14 <= 0;
        y_offsets_15 <= 0;
		  //Because it is reset, All zero will be false.
		  offset_all_zero <= 0;
    end
endtask

initial begin
	// Clear the offset.
	reset_ram();
	// Clear the offset all zero.
	ram_offset_all_zero <= 1;
end

always @(posedge sysclk) begin
    if (ram_reset) begin
        reset_ram();
    end
    else begin
        if (ram_write) begin
            if (ram_write_horizontal) begin
                // All y_offset, for horizontal move.
                if (ram_write_increase) begin
                    case (ram_write_pos)
                        0 : y_offsets_0  <= y_offsets_0  + 1'b1;
                        1 : y_offsets_1  <= y_offsets_1  + 1'b1;
                        2 : y_offsets_2  <= y_offsets_2  + 1'b1;
                        3 : y_offsets_3  <= y_offsets_3  + 1'b1;
                        4 : y_offsets_4  <= y_offsets_4  + 1'b1;
                        5 : y_offsets_5  <= y_offsets_5  + 1'b1;
                        6 : y_offsets_6  <= y_offsets_6  + 1'b1;
                        7 : y_offsets_7  <= y_offsets_7  + 1'b1;
                        8 : y_offsets_8  <= y_offsets_8  + 1'b1;
                        9 : y_offsets_9  <= y_offsets_9  + 1'b1;
                        10: y_offsets_10 <= y_offsets_10 + 1'b1;
                        11: y_offsets_11 <= y_offsets_11 + 1'b1;
                        12: y_offsets_12 <= y_offsets_12 + 1'b1;
                        13: y_offsets_13 <= y_offsets_13 + 1'b1;
                        14: y_offsets_14 <= y_offsets_14 + 1'b1;
                        15: y_offsets_15 <= y_offsets_15 + 1'b1;
                    endcase
                end
                else begin
                    case (ram_write_pos)
                        0 : y_offsets_0  <= y_offsets_0  - 1'b1;
                        1 : y_offsets_1  <= y_offsets_1  - 1'b1;
                        2 : y_offsets_2  <= y_offsets_2  - 1'b1;
                        3 : y_offsets_3  <= y_offsets_3  - 1'b1;
                        4 : y_offsets_4  <= y_offsets_4  - 1'b1;
                        5 : y_offsets_5  <= y_offsets_5  - 1'b1;
                        6 : y_offsets_6  <= y_offsets_6  - 1'b1;
                        7 : y_offsets_7  <= y_offsets_7  - 1'b1;
                        8 : y_offsets_8  <= y_offsets_8  - 1'b1;
                        9 : y_offsets_9  <= y_offsets_9  - 1'b1;
                        10: y_offsets_10 <= y_offsets_10 - 1'b1;
                        11: y_offsets_11 <= y_offsets_11 - 1'b1;
                        12: y_offsets_12 <= y_offsets_12 - 1'b1;
                        13: y_offsets_13 <= y_offsets_13 - 1'b1;
                        14: y_offsets_14 <= y_offsets_14 - 1'b1;
                        15: y_offsets_15 <= y_offsets_15 - 1'b1;
                    endcase
                end
            end
            else begin
                // All x_offset, for veritical move.
                if (ram_write_increase) begin
                    case (ram_write_pos)
                        0 : x_offsets_0  <= x_offsets_0  + 1'b1;
                        1 : x_offsets_1  <= x_offsets_1  + 1'b1;
                        2 : x_offsets_2  <= x_offsets_2  + 1'b1;
                        3 : x_offsets_3  <= x_offsets_3  + 1'b1;
                        4 : x_offsets_4  <= x_offsets_4  + 1'b1;
                        5 : x_offsets_5  <= x_offsets_5  + 1'b1;
                        6 : x_offsets_6  <= x_offsets_6  + 1'b1;
                        7 : x_offsets_7  <= x_offsets_7  + 1'b1;
                        8 : x_offsets_8  <= x_offsets_8  + 1'b1;
                        9 : x_offsets_9  <= x_offsets_9  + 1'b1;
                        10: x_offsets_10 <= x_offsets_10 + 1'b1;
                        11: x_offsets_11 <= x_offsets_11 + 1'b1;
                        12: x_offsets_12 <= x_offsets_12 + 1'b1;
                        13: x_offsets_13 <= x_offsets_13 + 1'b1;
                        14: x_offsets_14 <= x_offsets_14 + 1'b1;
                        15: x_offsets_15 <= x_offsets_15 + 1'b1;
                    endcase
                end
                else begin
                    case (ram_write_pos)
                        0 : x_offsets_0  <= x_offsets_0  - 1'b1;
                        1 : x_offsets_1  <= x_offsets_1  - 1'b1;
                        2 : x_offsets_2  <= x_offsets_2  - 1'b1;
                        3 : x_offsets_3  <= x_offsets_3  - 1'b1;
                        4 : x_offsets_4  <= x_offsets_4  - 1'b1;
                        5 : x_offsets_5  <= x_offsets_5  - 1'b1;
                        6 : x_offsets_6  <= x_offsets_6  - 1'b1;
                        7 : x_offsets_7  <= x_offsets_7  - 1'b1;
                        8 : x_offsets_8  <= x_offsets_8  - 1'b1;
                        9 : x_offsets_9  <= x_offsets_9  - 1'b1;
                        10: x_offsets_10 <= x_offsets_10 - 1'b1;
                        11: x_offsets_11 <= x_offsets_11 - 1'b1;
                        12: x_offsets_12 <= x_offsets_12 - 1'b1;
                        13: x_offsets_13 <= x_offsets_13 - 1'b1;
                        14: x_offsets_14 <= x_offsets_14 - 1'b1;
                        15: x_offsets_15 <= x_offsets_15 - 1'b1;
                    endcase
                end
            end
        end
		else begin
            offset_all_zero <= (x_offsets_0 == 0)
                             & (x_offsets_1 == 0)
                             & (x_offsets_2 == 0)
                             & (x_offsets_3 == 0)
                             & (x_offsets_4 == 0)
                             & (x_offsets_5 == 0)
                             & (x_offsets_6 == 0)
                             & (x_offsets_7 == 0)
                             & (x_offsets_8 == 0)
                             & (x_offsets_9 == 0)
                             & (x_offsets_10== 0)
                             & (x_offsets_11== 0)
                             & (x_offsets_12== 0)
                             & (x_offsets_13== 0)
                             & (x_offsets_14== 0)
                             & (x_offsets_15== 0)
                             & (y_offsets_0 == 0)
                             & (y_offsets_1 == 0)
                             & (y_offsets_2 == 0)
                             & (y_offsets_3 == 0)
                             & (y_offsets_4 == 0)
                             & (y_offsets_5 == 0)
                             & (y_offsets_6 == 0)
                             & (y_offsets_7 == 0)
                             & (y_offsets_8 == 0)
                             & (y_offsets_9 == 0)
                             & (y_offsets_10== 0)
                             & (y_offsets_11== 0)
                             & (y_offsets_12== 0)
                             & (y_offsets_13== 0)
                             & (y_offsets_14== 0)
                             & (y_offsets_15== 0);
		end
    end
end

always @(*) begin
    //Output the offsets.
    case (offset_pos_x)
        0 : offset_x = x_offsets_0 ;
        1 : offset_x = x_offsets_1 ;
        2 : offset_x = x_offsets_2 ;
        3 : offset_x = x_offsets_3 ;
        4 : offset_x = x_offsets_4 ;
        5 : offset_x = x_offsets_5 ;
        6 : offset_x = x_offsets_6 ;
        7 : offset_x = x_offsets_7 ;
        8 : offset_x = x_offsets_8 ;
        9 : offset_x = x_offsets_9 ;
        10: offset_x = x_offsets_10;
        11: offset_x = x_offsets_11;
        12: offset_x = x_offsets_12;
        13: offset_x = x_offsets_13;
        14: offset_x = x_offsets_14;
        15: offset_x = x_offsets_15;
    endcase
    case (offset_pos_y)
        0 : offset_y = y_offsets_0 ;
        1 : offset_y = y_offsets_1 ;
        2 : offset_y = y_offsets_2 ;
        3 : offset_y = y_offsets_3 ;
        4 : offset_y = y_offsets_4 ;
        5 : offset_y = y_offsets_5 ;
        6 : offset_y = y_offsets_6 ;
        7 : offset_y = y_offsets_7 ;
        8 : offset_y = y_offsets_8 ;
        9 : offset_y = y_offsets_9 ;
        10: offset_y = y_offsets_10;
        11: offset_y = y_offsets_11;
        12: offset_y = y_offsets_12;
        13: offset_y = y_offsets_13;
        14: offset_y = y_offsets_14;
        15: offset_y = y_offsets_15;
    endcase
	 //Update the all zero function.
	 ram_offset_all_zero = offset_all_zero;
end

endmodule