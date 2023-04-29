module InstructionMemory (
	input             IFflush    ,
	input      [63:0] pc_address , // current pc addr
	output reg [31:0] instruction  // instruction
);

	reg [31:0] inst_mem[0:1024];
	initial
		$readmemh ("ROM.txt", inst_mem);
	always @(*) begin
		if(IFflush == 1)
			instruction = 32'h00000000;
		else
			instruction = inst_mem[pc_address[63:2]];
	end
endmodule
