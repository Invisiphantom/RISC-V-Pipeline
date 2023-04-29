module ForwardMux (
	input      [ 1:0] ForwardX     ,
	input      [63:0] EX_ReadDatax ,
	input      [63:0] MEM_ALUresult,
	input      [63:0] WB_WriteData ,
	output reg [63:0] EX_ForDatax
);
// forwardA and forwardB = 00 -> source = EX
// forwardA and forwardB = 10 -> source = MEM
// forwardA and forwardB = 01 -> source = WB

	always @(*) begin
		case (ForwardX)
			2'b00 : EX_ForDatax = EX_ReadDatax;
			2'b10 : EX_ForDatax = MEM_ALUresult;
			2'b01 : EX_ForDatax = WB_WriteData;
		endcase
	end

endmodule