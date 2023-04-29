module ForwardingUnit (
	input            RegWrite,
	input      [4:0] Rs1, Rs2,
	input      [4:0] MEM_rdReg, WB_rdReg,
	output reg [1:0] ForwardA, ForwardB
);
// forwardA and forwardB = 00 -> source = EX
// forwardA and forwardB = 10 -> source = MEM
// forwardA and forwardB = 01 -> source = WB
	always @(*) begin
		if(RegWrite == 1'b1 && MEM_rdReg != 5'b00000 && MEM_rdReg == Rs1)
			ForwardA <= 2'b10;
		else if(RegWrite == 1'b1 && WB_rdReg != 5'b00000 && WB_rdReg == Rs1)
			ForwardA <= 2'b01;
		else
			ForwardA <= 2'b00;

		if(RegWrite == 1'b1 && MEM_rdReg != 5'b00000 && MEM_rdReg == Rs2)
			ForwardB <= 2'b10;
		else if(RegWrite == 1'b1 && WB_rdReg != 5'b00000 && WB_rdReg == Rs2)
			ForwardB <= 2'b01;
		else
			ForwardB <= 2'b00;
	end
endmodule
