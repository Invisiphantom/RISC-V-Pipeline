module HazardUnit (
	input            EX_MemRead,
	input      [4:0] ID_Rs1, ID_Rs2,
	input      [4:0] EX_rdReg  ,
	output reg       Controlen, PCen, IF_IDen
);
	always @(*) begin
		if(EX_MemRead == 1'b1 && (EX_rdReg == ID_Rs1 | EX_rdReg == ID_Rs2)) begin
			Controlen = 1'b0 ;
			PCen      = 1'b0 ;
			IF_IDen   = 1'b0 ;
		end
		else begin
			Controlen = 1'b1 ;
			PCen      = 1'b1 ;
			IF_IDen   = 1'b1 ;
		end
	end

endmodule

