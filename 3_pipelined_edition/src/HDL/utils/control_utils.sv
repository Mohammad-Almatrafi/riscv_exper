/*
 * alu controller
 *
 * rur1k 2025-08-04
 *
 * dev note 2025-08-04 (rur1k):
 * logic seperation will beneficial for the project maintainability and logic
 * expansion in the future
 */

module alu_control (
    input  [1:0] alu_op,
    input  [2:0] func3,
    input  [6:0] func7,
    output [3:0] alu_ctrl
);

  import holy_core_pkg::*;

  alu_op_t alu_op_enum;
  alu_control_t alu_ctrl_enum;
  assign alu_op_enum = alu_op_t'(alu_op);
  funct3_t func3_alu_enum;
  assign func3_alu_enum = funct3_t'(func3);
  branch_funct3_t func3_branch_enum;
  assign func3_branch_enum = branch_funct3_t'(func3);

  always @(*) begin
    alu_ctrl_enum = ALU_ADD;
    case (alu_op_enum)
      ALU_OP_LOAD_STORE: begin
        alu_ctrl_enum = ALU_ADD;
      end
      ALU_OP_R_TYPE: begin
        case (func3_alu_enum)
          F3_ADD_SUB: begin
            if (func7[5]) alu_ctrl_enum = ALU_SUB;
            else alu_ctrl_enum = ALU_ADD;
          end
          F3_SLL:  alu_ctrl_enum = ALU_SLL;
          F3_SLT:  alu_ctrl_enum = ALU_SLT;
          F3_SLTU: alu_ctrl_enum = ALU_SLTU;
          F3_XOR:  alu_ctrl_enum = ALU_XOR;
          F3_SRL_SRA: begin
            if (func7[5]) alu_ctrl_enum = ALU_SRA;
            else alu_ctrl_enum = ALU_SRL;
          end
          F3_OR:   alu_ctrl_enum = ALU_OR;
          F3_AND:  alu_ctrl_enum = ALU_AND;
          default: ;
        endcase
      end
      ALU_OP_I_TYPE: begin
        case (func3_alu_enum)
          F3_ADD_SUB: alu_ctrl_enum = ALU_ADD;
          F3_SLL: alu_ctrl_enum = ALU_SLL;
          F3_SLT: alu_ctrl_enum = ALU_SLT;
          F3_SLTU: alu_ctrl_enum = ALU_SLTU;
          F3_XOR: alu_ctrl_enum = ALU_XOR;
          F3_SRL_SRA: begin
            if (func7[5]) alu_ctrl_enum = ALU_SRA;
            else alu_ctrl_enum = ALU_SRL;
          end
          F3_OR: alu_ctrl_enum = ALU_OR;
          F3_AND: alu_ctrl_enum = ALU_AND;
          default: ;
        endcase
      end
      ALU_OP_BRANCHES: begin
        case (func3_branch_enum)
          F3_BEQ, F3_BNE: begin
            alu_ctrl_enum = ALU_SUB;
          end
          F3_BLT, F3_BGE: begin
            alu_ctrl_enum = ALU_SLT;
          end
          F3_BLTU, F3_BGEU: begin
            alu_ctrl_enum = ALU_SLTU;
          end
          default: ;
        endcase
      end
      default: ;
    endcase
  end

  assign alu_ctrl = alu_ctrl_enum;

endmodule


/*
 * branch and jump controller
 *
 * rur1k 2025-08-04
 *
 */

module branch_jump_control (
    input [2:0] func3,
    input branch,
    input zero,
    input jump,
    output pc_sel
);

  import holy_core_pkg::*;

  branch_funct3_t func3_branch_enum;
  assign func3_branch_enum = branch_funct3_t'(func3);
  logic comparison_result;

  always @(*) begin
    case (func3_branch_enum)
      F3_BEQ:  comparison_result = zero;
      F3_BNE:  comparison_result = ~zero;
      F3_BLT:  comparison_result = ~zero;
      F3_BGE:  comparison_result = zero;
      F3_BLTU: comparison_result = ~zero;
      F3_BGEU: comparison_result = zero;
      default: comparison_result = 1'bx;
    endcase
  end

  assign pc_sel = (comparison_result & branch) | jump;

endmodule

module pipeline_controller (
    input load_hazard,
    input branch_hazard,
    input stall_pipeline,

    output pc_en,
    output if_id_reg_en,
    output id_exe_reg_en,
    output exe_mem_reg_en,
    output mem_wb_reg_en,
    output if_id_reg_clr,
    output id_exe_reg_clr,
    output exe_mem_reg_clr,
    output mem_wb_reg_clr
);

  assign pc_en = ~(load_hazard | stall_pipeline) | branch_hazard;

  assign if_id_reg_en = ~(load_hazard | branch_hazard);
  assign id_exe_reg_en = ~(stall_pipeline);
  assign exe_mem_reg_en = ~(stall_pipeline);
  assign mem_wb_reg_en = ~(stall_pipeline);

  assign if_id_reg_clr = branch_hazard;
  assign id_exe_reg_clr = branch_hazard | load_hazard;
  assign exe_mem_reg_clr = branch_hazard;
  assign mem_wb_reg_clr = 1'b0;

endmodule

module hazard_controller (
    input pc_sel_mem,
    input exe_use_rs1,
    input exe_use_rs2,
    input [4:0] rs1_addr_id,
    input [4:0] rs2_addr_id,
    input [4:0] rd_addr_exe,
    input mem_read_exe,
    output load_hazard,
    output branch_hazard
);

  logic rs1_usage;
  logic rs2_usage;
  logic rd_needed;

  assign rs1_usage = exe_use_rs1 & (rs1_addr_id == rd_addr_exe);
  assign rs2_usage = exe_use_rs2 & (rs2_addr_id == rd_addr_exe);
  assign rd_needed = (rd_addr_exe != 0) & mem_read_exe;

  assign branch_hazard = pc_sel_mem;
  assign load_hazard = (rs1_usage | rs2_usage) & rd_needed;

endmodule

module forward_unit (
    input [4:0] rs1_addr_id,
    input [4:0] rs2_addr_id,
    input [4:0] rs1_addr_exe,
    input [4:0] rs2_addr_exe,
    input [4:0] rs2_addr_mem,
    input [4:0] rd_addr_mem,
    input [4:0] rd_addr_wb,

    input reg_write_mem,
    input reg_write_wb,

    output rs1_select_id,
    output rs2_select_id,
    output [1:0] rs1_select_exe,
    output [1:0] rs2_select_exe,
    output rs2_select_mem
);

  logic rs1_select_exe_0;
  logic rs1_select_exe_1;
  logic rs2_select_exe_0;
  logic rs2_select_exe_1;

  assign rs1_select_id = (rs1_addr_id == rd_addr_wb) & reg_write_wb & (rd_addr_wb != 0);
  assign rs2_select_id = (rs2_addr_id == rd_addr_wb) & reg_write_wb & (rd_addr_wb != 0);

  assign rs1_select_exe_0 = (rs1_addr_exe == rd_addr_mem) & (rd_addr_mem != 0) & reg_write_mem;
  assign rs1_select_exe_1 = (rs1_addr_exe == rd_addr_wb) & (rd_addr_wb != 0) & reg_write_wb;
  assign rs2_select_exe_0 = (rs2_addr_exe == rd_addr_mem) & (rd_addr_mem != 0) & reg_write_mem;
  assign rs2_select_exe_1 = (rs2_addr_exe == rd_addr_wb) & (rd_addr_wb != 0) & reg_write_wb;

  assign rs1_select_exe[0] = rs1_select_exe_0;
  assign rs1_select_exe[1] = rs1_select_exe_1 & ~rs1_select_exe_0;
  assign rs2_select_exe[0] = rs2_select_exe_0;
  assign rs2_select_exe[1] = rs2_select_exe_1 & ~rs2_select_exe_0;

  assign rs2_select_mem = (rs2_addr_mem == rd_addr_wb) & (rd_addr_wb != 0);

endmodule


/*
 * STORE ALIGNER
 *
 * BRH 10/24
 *
 * Sits before the data memory and allows to feed the right signals into the memory's cpu interface.
 *
 * dev note 2025-08-04 (rur1k):
 * optimized the shifting process to a mux only process so i could use less
 * shifter resources
 *
 * dev note 2025-08-05 (rur1k):
 * changed the name of the module to the standard naming convention it is more
 * of a data aligner than a decoder and it is store only and doesn't care
 * about the load process
 */

module store_aligner (
    input  logic [31:0] alu_result_address,
    input  logic [ 2:0] f3,
    input  logic [31:0] reg_read,
    output logic [ 3:0] byte_enable,
    output logic [31:0] data
);

  import holy_core_pkg::*;

  logic [ 1:0] offset;
  logic [ 7:0] byte_store;
  logic [15:0] half_store;
  assign offset = alu_result_address[1:0];
  load_store_funct3_t f3_enum;
  assign f3_enum = load_store_funct3_t'(f3);

  assign byte_store = reg_read[7:0];
  assign half_store = reg_read[15:0];

  always @(*) begin
    case (f3_enum)
      F3_BYTE, F3_BYTE_U: begin  // SB, LB, LBU
        case (offset)
          2'b00: begin
            byte_enable = 4'b0001;
            data = {24'b0, byte_store};
          end
          2'b01: begin
            byte_enable = 4'b0010;
            data = {16'b0, byte_store, 8'b0};
          end
          2'b10: begin
            byte_enable = 4'b0100;
            data = {8'b0, byte_store, 16'b0};
          end
          2'b11: begin
            byte_enable = 4'b1000;
            data = {byte_store, 24'b0};
          end
          default: begin
            data = 'b0;
            byte_enable = 4'b0000;
          end
        endcase
      end

      F3_WORD: begin  // SW
        byte_enable = (offset == 2'b00) ? 4'b1111 : 4'b0000;
        data = reg_read;
      end

      F3_HALFWORD, F3_HALFWORD_U: begin  // SH, LH, LHU
        case (offset)
          2'b00: begin
            byte_enable = 4'b0011;
            data = {16'b0, half_store};
          end
          2'b10: begin
            byte_enable = 4'b1100;
            data = {half_store, 16'b0};
          end
          default: begin
            data = 'b0;
            byte_enable = 4'b0000;
          end
        endcase
      end

      default: begin
        data = 'b0;
        byte_enable = 4'b0000;  // No operation for unsupported types
      end
    endcase
  end

endmodule


/*
 * LOAD ALIGNER
 *
 * BRH 10/24
 *
 * Reads incomming data from memory and formats it depending on the issued instruction's f3
 * and the bye_enable mask.
 *
 * dev note 2025-08-04 (rur1k):
 * changed the name of this module for the same reason mentioned for the
 * module store_aligner
 */

module load_aligner (
    input logic [31:0] mem_data,
    input logic [ 3:0] be_mask,
    input logic [ 2:0] f3,

    output logic [31:0] wb_data
);

  import holy_core_pkg::*;

  logic sign_extend;
  assign sign_extend = ~f3[2];

  load_store_funct3_t f3_enum;
  assign f3_enum = load_store_funct3_t'(f3);

  logic [31:0] masked_data;  // just a mask applied
  logic [31:0] raw_data;  // Data shifted according to instruction
  // and then mem_data is the final output with sign extension

  always @(*) begin : mask_apply
    for (int i = 0; i < 4; i++) begin
      if (be_mask[i]) begin
        masked_data[(i*8)+:8] = mem_data[(i*8)+:8];
      end else begin
        masked_data[(i*8)+:8] = 8'h00;
      end
    end
  end

  always @(*) begin : shift_data
    case (f3_enum)
      F3_WORD: raw_data = masked_data;  // masked data is full word in that case

      F3_BYTE, F3_BYTE_U: begin  // LB, LBU
        case (be_mask)
          4'b0001: raw_data = masked_data;
          4'b0010: raw_data = masked_data >> 8;
          4'b0100: raw_data = masked_data >> 16;
          4'b1000: raw_data = masked_data >> 24;
          default: raw_data = 32'd0;
        endcase
      end

      F3_HALFWORD, F3_HALFWORD_U: begin  // LH, LHU
        case (be_mask)
          4'b0011: raw_data = masked_data;
          4'b1100: raw_data = masked_data >> 16;
          default: raw_data = 32'd0;
        endcase
      end

      default: raw_data = 32'd0;
    endcase
  end

  always @(*) begin : sign_extend_logic
    case (f3)
      // LW
      F3_WORD: wb_data = raw_data;

      // LB, LBU
      F3_BYTE, F3_BYTE_U: begin
        wb_data = sign_extend ? {{24{raw_data[7]}}, raw_data[7:0]} : raw_data;
      end

      // LH, LHU
      F3_HALFWORD, F3_HALFWORD_U: begin
        wb_data = sign_extend ? {{16{raw_data[15]}}, raw_data[15:0]} : raw_data;
      end

      default: wb_data = 32'd0;
    endcase
  end

endmodule


