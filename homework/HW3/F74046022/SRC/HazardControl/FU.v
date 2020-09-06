// Forwarding Unit

module FU ( // input 
			EX_Rs,
            EX_Rt,
			M_RegWrite,
			M_WR_out,
			WB_RegWrite,
			WB_WR_out,
			// output
			// write your code in here
			Fw_Rs,
			Fw_Rt,
			Fw_Rs_M,
			Fw_Rt_M
			);

	input [4:0] EX_Rs;
    input [4:0] EX_Rt;
    input M_RegWrite;
    input [4:0] M_WR_out;
    input WB_RegWrite;
    input [4:0] WB_WR_out;

	
	
	// write your code in here
	output Fw_Rs, Fw_Rt, Fw_Rs_M, Fw_Rt_M;
	wire Fw_Rs_WB, Fw_Rt_WB;
	
	assign Fw_Rs_M  = (EX_Rs== M_WR_out) &&  M_RegWrite;
	assign Fw_Rt_M  = (EX_Rt== M_WR_out) &&  M_RegWrite;
	assign Fw_Rs_WB = (EX_Rs==WB_WR_out) && WB_RegWrite;
	assign Fw_Rt_WB = (EX_Rt==WB_WR_out) && WB_RegWrite;
	
	assign Fw_Rs = (EX_Rs!=5'b0) && (Fw_Rs_M || Fw_Rs_WB);
	assign Fw_Rt = (EX_Rt!=5'b0) && (Fw_Rt_M || Fw_Rt_WB);
	
endmodule




























