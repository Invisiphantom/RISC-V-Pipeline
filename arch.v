module arch (
	input clk  ,
	input PCrst
);

	initial begin
		MEM_PCSrc = 1'b0;
	end




	reg         MEM_PCSrc   ;
	wire [63:0] MEM_PCPlus4 ;
	wire [63:0] MEM_PCSum   ;
	reg  [63:0] MEM_PCnext  ;
	wire [63:0] IF_PCaddress;
	PC4Add u_PC4Add (
		.PC     (IF_PCaddress),
		.PCPlus4(MEM_PCPlus4 )
	);
	always @(*) begin
		MEM_PCnext = (MEM_PCSrc == 1'b0) ? MEM_PCPlus4 : MEM_PCSum;
	end


	/* MEM */
	wire PCen;
	PC u_PC (
		.clk      (clk         ),
		.PCrst    (PCrst       ),
		.PCen     (PCen        ),
		.PCnext   (MEM_PCnext  ),
		.PCaddress(IF_PCaddress)
	);

	/* IF */


	wire [31:0] IF_Instruction;
	InstructionMemory u_InstructionMemory (
		.IFflush    (MEM_PCSrc     ),
		.pc_address (IF_PCaddress  ),
		.instruction(IF_Instruction)
	);


	/* IF */
	wire [63:0] ID_PCaddress  ;
	wire [31:0] ID_Instruction;
	wire        IF_IDen       ;
	IF_ID u_IF_ID (
		.clk           (clk           ),
		.IFflush       (MEM_PCSrc     ),
		.IF_IDen       (IF_IDen       ),
		.IF_PCaddress  (IF_PCaddress  ),
		.IF_Instruction(IF_Instruction),
		.ID_PCaddress  (ID_PCaddress  ),
		.ID_Instruction(ID_Instruction)
	);
	/* ID */

	wire       EX_MemRead;
	wire [4:0] EX_rdReg  ;
	wire       Controlen ;
	HazardUnit u_HazardUnit (
		.EX_MemRead(EX_MemRead           ),
		.ID_Rs1    (ID_Instruction[19:15]),
		.ID_Rs2    (ID_Instruction[24:20]),
		.EX_rdReg  (EX_rdReg             ),
		.Controlen (Controlen            ),
		.PCen      (PCen                 ),
		.IF_IDen   (IF_IDen              )
	);



	wire       ID_ALUSrc  ;
	wire       ID_MemtoReg;
	wire       ID_RegWrite;
	wire       ID_MemRead ;
	wire       ID_MemWrite;
	wire       ID_Branch  ;
	wire       ID_Jump    ;
	wire [1:0] ID_ALUOp   ;
	Control u_Control (
		.Opcode   (ID_Instruction[6:0]),
		.Controlen(Controlen          ),
		.ALUSrc   (ID_ALUSrc          ),
		.MemtoReg (ID_MemtoReg        ),
		.RegWrite (ID_RegWrite        ),
		.MemRead  (ID_MemRead         ),
		.MemWrite (ID_MemWrite        ),
		.Branch   (ID_Branch          ),
		.Jump     (ID_Jump            ),
		.ALUOp    (ID_ALUOp           )
	);


	wire        WB_RegWrite ;
	wire [ 4:0] WB_rdReg    ;
	wire [63:0] ID_ReadData1;
	wire [63:0] ID_ReadData2;
	wire [63:0] WB_WriteData;
	Registers u_Registers (
		.clk      (clk                  ),
		.RegWrite (WB_RegWrite          ),
		.ReadReg1 (ID_Instruction[19:15]),
		.ReadReg2 (ID_Instruction[24:20]),
		.WriteReg (WB_rdReg             ),
		.WriteData(WB_WriteData         ),
		.ReadData1(ID_ReadData1         ),
		.ReadData2(ID_ReadData2         )
	);


	wire[63:0] ID_ExImm;
	ImmGen u_ImmGen (
		.In (ID_Instruction[31:0]),
		.Out(ID_ExImm            )
	);


	/* ID */
	wire        EX_ALUSrc   ; // RD2 or ImmGen
	wire        EX_MemtoReg ; // ALU or MemData
	wire        EX_RegWrite ;
	wire        EX_MemWrite ;
	wire        EX_Branch   ;
	wire        EX_Jump     ;
	wire [ 1:0] EX_ALUOp    ;
	wire [63:0] EX_PCaddress;
	wire [63:0] EX_ReadData1;
	wire [63:0] EX_ReadData2;
	wire [63:0] EX_ExImm    ;
	wire        EX_funct7   ;
	wire [ 2:0] EX_funct3   ;
	wire [ 4:0] EX_Rs1      ;
	wire [ 4:0] EX_Rs2      ;
	ID_EX u_ID_EX (
		.clk         (clk                  ),
		.EXflush     (MEM_PCSrc            ),
		.ID_ALUSrc   (ID_ALUSrc            ),
		.ID_MemtoReg (ID_MemtoReg          ),
		.ID_RegWrite (ID_RegWrite          ),
		.ID_MemRead  (ID_MemRead           ),
		.ID_MemWrite (ID_MemWrite          ),
		.ID_Branch   (ID_Branch            ),
		.ID_Jump     (ID_Jump              ),
		.ID_ALUOp    (ID_ALUOp             ),
		.ID_PCaddress(ID_PCaddress         ),
		.ID_ReadData1(ID_ReadData1         ),
		.ID_ReadData2(ID_ReadData2         ),
		.ID_ExImm    (ID_ExImm             ),
		.ID_funct7   (ID_Instruction[30]   ),
		.ID_funct3   (ID_Instruction[14:12]),
		.ID_Rs1      (ID_Instruction[19:15]),
		.ID_Rs2      (ID_Instruction[24:20]),
		.ID_rdReg    (ID_Instruction[11:7] ),
		.EX_ALUSrc   (EX_ALUSrc            ),
		.EX_MemtoReg (EX_MemtoReg          ),
		.EX_RegWrite (EX_RegWrite          ),
		.EX_MemRead  (EX_MemRead           ),
		.EX_MemWrite (EX_MemWrite          ),
		.EX_Branch   (EX_Branch            ),
		.EX_Jump     (EX_Jump              ),
		.EX_ALUOp    (EX_ALUOp             ),
		.EX_PCaddress(EX_PCaddress         ),
		.EX_ReadData1(EX_ReadData1         ),
		.EX_ReadData2(EX_ReadData2         ),
		.EX_ExImm    (EX_ExImm             ),
		.EX_funct7   (EX_funct7            ),
		.EX_funct3   (EX_funct3            ),
		.EX_Rs1      (EX_Rs1               ),
		.EX_Rs2      (EX_Rs2               ),
		.EX_rdReg    (EX_rdReg             )
	);
	/* EX */


	wire[63:0] EX_ShiftImm;
	ShiftLeft1 u_ShiftLeft1 (
		.In (EX_ExImm   ),
		.out(EX_ShiftImm)
	);


	wire[63:0] EX_PCSum;
	PCAdd u_PCAdd (
		.PCaddress(EX_PCaddress),
		.ShiftImm (EX_ShiftImm ),
		.PCSum    (EX_PCSum    )
	);


	wire[3:0] EX_ALU_control;
	ALUControl u_ALUControl (
		.ALUOp      (EX_ALUOp      ),
		.funct7     (EX_funct7     ),
		.funct3     (EX_funct3     ),
		.ALU_control(EX_ALU_control)
	);


	wire [63:0] EX_ALU1    ;
	wire [63:0] EX_ALU2    ;
	wire [ 1:0] EX_ForwardA;
	wire [ 1:0] EX_ForwardB;
	wire [ 4:0] MEM_rdReg  ;
	ForwardingUnit u_ForwardingUnit (
		.RegWrite (EX_RegWrite),
		.Rs1      (EX_Rs1     ),
		.Rs2      (EX_Rs2     ),
		.MEM_rdReg(MEM_rdReg  ),
		.WB_rdReg (WB_rdReg   ),
		.ForwardA (EX_ForwardA),
		.ForwardB (EX_ForwardB)
	);


	wire [63:0] MEM_ALUresult;
	wire [63:0] EX_ForData1  ;
	wire [63:0] EX_ForData2  ;
	ForwardMux u_ForwardMux_A (
		.ForwardX     (EX_ForwardA  ),
		.EX_ReadDatax (EX_ReadData1 ),
		.MEM_ALUresult(MEM_ALUresult),
		.WB_WriteData (WB_WriteData ),
		.EX_ForDatax  (EX_ForData1  )
	);
	ForwardMux u_ForwardMux_B (
		.ForwardX     (EX_ForwardB  ),
		.EX_ReadDatax (EX_ReadData2 ),
		.MEM_ALUresult(MEM_ALUresult),
		.WB_WriteData (WB_WriteData ),
		.EX_ForDatax  (EX_ForData2  )
	);
	assign EX_ALU1 = EX_ForData1;
	assign EX_ALU2 = (EX_ALUSrc == 0) ? EX_ForData2 : EX_ExImm;


	wire        EX_zero     ;
	wire        EX_s_less   ;
	wire        EX_u_less   ;
	wire [63:0] EX_ALUresult;
	ALU u_ALU (
		.ALU_control(EX_ALU_control),
		.A1         (EX_ALU1       ),
		.A2         (EX_ALU2       ),
		.Y          (EX_ALUresult  ),
		.zero       (EX_zero       ),
		.s_less     (EX_s_less     ),
		.u_less     (EX_u_less     )
	);


	/* EX */
	wire        MEM_MemtoReg;
	wire        MEM_RegWrite;
	wire        MEM_MemRead ;
	wire        MEM_MemWrite;
	wire        MEM_Branch  ;
	wire        MEM_Jump    ;
	wire        MEM_zero    ;
	wire        MEM_s_less  ;
	wire        MEM_u_less  ;
	wire [63:0] MEM_RegData2;
	wire [ 2:0] MEM_funct3  ;
	EX_MEM u_EX_MEM (
		.clk          (clk          ),
		.MEMflush     (MEM_PCSrc    ),
		.EX_MemtoReg  (EX_MemtoReg  ),
		.EX_RegWrite  (EX_RegWrite  ),
		.EX_MemRead   (EX_MemRead   ),
		.EX_MemWrite  (EX_MemWrite  ),
		.EX_Branch    (EX_Branch    ),
		.EX_Jump      (EX_Jump      ),
		.EX_PCSum     (EX_PCSum     ),
		.EX_zero      (EX_zero      ),
		.EX_s_less    (EX_s_less    ),
		.EX_u_less    (EX_u_less    ),
		.EX_ALUresult (EX_ALUresult ),
		.EX_RegData2  (EX_ForData2  ),
		.EX_funct3    (EX_funct3    ),
		.EX_rdReg     (EX_rdReg     ),
		.MEM_MemtoReg (MEM_MemtoReg ),
		.MEM_RegWrite (MEM_RegWrite ),
		.MEM_MemRead  (MEM_MemRead  ),
		.MEM_MemWrite (MEM_MemWrite ),
		.MEM_Branch   (MEM_Branch   ),
		.MEM_Jump     (MEM_Jump     ),
		.MEM_PCSum    (MEM_PCSum    ),
		.MEM_zero     (MEM_zero     ),
		.MEM_s_less   (MEM_s_less   ),
		.MEM_u_less   (MEM_u_less   ),
		.MEM_ALUresult(MEM_ALUresult),
		.MEM_RegData2 (MEM_RegData2 ),
		.MEM_funct3   (MEM_funct3   ),
		.MEM_rdReg    (MEM_rdReg    )
	);
	/* MEM */


	wire MEM_Branch_jump;
	BranchJudge u_BranchJudge (
		.zero       (MEM_zero       ),
		.s_less     (MEM_s_less     ),
		.u_less     (MEM_u_less     ),
		.Branch     (MEM_Branch     ),
		.funct3     (MEM_funct3     ),
		.Branch_jump(MEM_Branch_jump)
	);
	always @(*) begin
		MEM_PCSrc = MEM_Jump || MEM_Branch_jump;
	end

	wire [63:0] MEM_MemData;
	DataMemory u_DataMemory (
		.clk      (clk          ),
		.MemWrite (MEM_MemWrite ),
		.MemRead  (MEM_MemRead  ),
		.address  (MEM_ALUresult),
		.WriteData(MEM_RegData2 ),
		.ReadData (MEM_MemData  )
	);


	/* MEM */
	wire        WB_MemtoReg ;
	wire [63:0] WB_MemData  ;
	wire [63:0] WB_ALUresult;
	MEM_WB u_MEM_WB (
		.clk          (clk          ),
		.MEM_MemtoReg (MEM_MemtoReg ),
		.MEM_RegWrite (MEM_RegWrite ),
		.MEM_MemData  (MEM_MemData  ),
		.MEM_ALUresult(MEM_ALUresult),
		.MEM_rdReg    (MEM_rdReg    ),
		.WB_MemtoReg  (WB_MemtoReg  ),
		.WB_RegWrite  (WB_RegWrite  ),
		.WB_MemData   (WB_MemData   ),
		.WB_ALUresult (WB_ALUresult ),
		.WB_rdReg     (WB_rdReg     )
	);
	/* WB */


	assign WB_WriteData = (WB_MemtoReg == 0) ? WB_ALUresult : WB_MemData;


endmodule