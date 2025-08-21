# utilities used in rv32i core
- [control_utils.sv ](./control_utils.sv )
- [datapath_utils.sv](./datapath_utils.sv)
- [defines.sv       ](./defines.sv       )
- [holy_core_pkg.sv ](./holy_core_pkg.sv )
- [main_control.sv  ](./main_control.sv  )
- [memory.sv        ](./memory.sv        )

## files specs

### [control_utils.sv ](./control_utils.sv )
|Module Name|Parameters|Inputs|Bit Width|Outputs|Bit Width|
|:---       |   :---   |:---  |:---:     |:---   |:---:     |
|alu_control|None| alu_op<br>func3<br>func7 | [1:0]<br>[2:0]<br>[6:0]|alu_ctrl|[3:0]
|branch_jump_control| None| func3<br>branch<br>zero<br>jump| [2:0]<br>[0:0]<br>[0:0]<br>[0:0] |pc_sel| [0:0]
|load_aligner|None      | mem_data<br>be_mask<br>f3       |[31:0]<br>[3:0]<br>[2:0]| wb_data       |[31:0]   |
|store_aligner|None |alu_result_address<br>f3<br>reg_read | [31:0]<br>[2:0]<br>[31:0] | byte_enable<br>data| [3:0]<br>[31:0]
|hazard_controller|None| pc_sel_mem<br> exe_use_rs1<br> exe_use_rs2<br> rs1_addr_id<br> rs2_addr_id<br> rd_addr_exe<br>mem_read_exe| [0:0]<br>[0:0]<br>[0:0]<br>[4:0]<br>[4:0]<br>[4:0]<br>[0:0]|load_hazard<br> branch_hazard|[0:0]<br>[0:0]|
|forward_unit|None| rs1_addr_id<br> rs2_addr_id<br> rs1_addr_exe<br> rs2_addr_exe<br> rs2_addr_mem<br> rd_addr_mem<br> rd_addr_wb<br>reg_write_mem<br>reg_write_wb| [4:0]<br>[4:0]<br>[4:0]<br>[4:0]<br>[4:0]<br>[4:0]<br>[4:0]<br>[0:0]<br>[0:0]|rs1_select_id<br>rs2_select_id<br>rs1_select_exe<br>rs2_select_exe<br>rs2_select_mem|[0:0]<br>[0:0]<br>[1:0]<br>[1:0]<br>[0:0]|
|pipeline_controller|None| load_hazard<br>branch_hazard<br>stall_pipeline|[0:0]<br>[0:0]<br>[0:0] | pc_en<br>if_id_reg_en<br>id_exe_reg_en<br> exe_mem_reg_en<br> mem_wb_reg_en<br> if_id_reg_clr<br> id_exe_reg_clr<br> exe_mem_reg_clr<br> mem_wb_reg_clr<br>|[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]|

### [datapath_utils.sv](./datapath_utils.sv)
| Module Name|Parameters|                Inputs           |Bit Width                 | Outputs       |Bit Width|
| :---       |   :---   |                :---             |:---:                      | :---          |:---:     |
|n_bit_reg_wclr| int N | clk<br>rst_n<br>wen<br>clear<br>data_in| [0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[N-1:0]|  data_out| [N-1:0]|
|program_counter| None| clk<br> rst_n<br> en<br>next_pc| [0:0]<br>[0:0]<br>[0:0]<br>[31:0]|pc|[31:0]|
|regfile|None| clk<br>rst_n<br> rs1_addr<br> rs2_addr<br>write_enable<br>write_data<br>rd_addr| [0:0]<br>[0:0]<br>[4:0]<br> [4:0]<br>[0:0]<br> [31:0]<br> [4:0]| rs1_data <br> rs2_data| [31:0]<br>[31:0]|
|imm_gen|None| raw_src<br> imm_source| [24:0]<br> [2:0] |immediate|[31:0]|
|adder_subtractor|None|a<br> b<br>sub|[31:0]<br>[31:0]<br>[0:0]|add_sub_result|[31:0]|
|alu|None| alu_control<br> src1<br> src2<br>|[3:0]<br>[31:0]<br>[31:0]|alu_result<br>zero|[31:0]<br>[0:0]|

### [defines.sv       ](./defines.sv       )
contains the generated defines from the makefile (verification build, implementation build)


### [holy_core_pkg.sv ](./holy_core_pkg.sv )
contains the packages for the rv core

### [main_control.sv  ](./main_control.sv  )
| Module Name|Parameters|                Inputs           |Bit Width                 | Outputs       |Bit Width|
| :---       |   :---   |                :---             |:---:                      | :---          |:---:     |
|main_control|None|opcode|[6:0]| mem_write<br> reg_write<br> alu_source<br> imm_source<br> alu_op<br> r_type<br> branch<br> jump<br> jalr<br> lui<br> auipc<br> mem_to_reg<br>|[0:0]<br>[0:0]<br>[2:0]<br> [1:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>[0:0]<br>|


### [memory.sv        ](./memory.sv        )

| Module Name|Parameters|                Inputs           |Bit Width                 | Outputs       |Bit Width|
| :---       |   :---   |                :---             |:---:                      | :---          |:---:     |
|memory|int WORDS<br>string MEM_INIT|clk<br>rst_n<br>address<br> write_data<br> byte_enable<br> write_enable| [0:0]<br> [0:0]<br> [31:0]<br> [31:0]<br> [3:0]<br> [0:0]|read_data|[31:0]|


