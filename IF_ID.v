module IF_ID (
	input             clk           ,
	input IFflush,
	input             IF_IDen       ,
	input      [63:0] IF_PCaddress  ,
	input      [31:0] IF_Instruction,
	output reg [63:0] ID_PCaddress  ,
	output reg [63:0] ID_Instruction
);

	always@(posedge clk)begin
		if(IFflush == 1)begin
			ID_PCaddress   <= {64{1'b0}};
			ID_Instruction <= {32{1'b0}};
		end
		else if(IF_IDen == 0) begin
			ID_PCaddress   <= ID_PCaddress;
			ID_Instruction <= ID_Instruction;
		end
		else begin
			ID_PCaddress   <= IF_PCaddress;
			ID_Instruction <= IF_Instruction;
		end
	end

endmodule