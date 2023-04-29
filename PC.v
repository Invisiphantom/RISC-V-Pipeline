module PC (
	input             clk      ,
	input             PCrst    ,
	input             PCen     ,
	input      [63:0] PCnext   ,
	output reg [63:0] PCaddress
);

	always @ (posedge clk) begin
		if(PCrst == 1'b1)
			PCaddress <= {64{1'b0}};
	end
	always @(posedge clk) begin
		if(PCen == 0)
			PCaddress <= PCaddress;
		else
			PCaddress <= PCnext;
	end
endmodule
