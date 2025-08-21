# main core

- [core.sv ](./core.sv )
- [rv32i_top.sv](./rv32i_top.sv)

## files specs

### [core.sv ](./core.sv )
|Module Name|Parameters|Inputs|Bit Width|Outputs|Bit Width|
|:---       |   :---   |:---  |:---:     |:---   |:---:     |
|core|None| clk<br> rst_n<br> inst_if<br> stall_pipeline<br> mem_read_data| [0:0]<br> [0:0]<br> [31:0]<br> [0:0]<br> [31:0]| byte_mask_mem<br> mem_addr_mem<br> mem_write_data<br> mem_write_mem<br> current_pc_if| [3:0]<br> [31:0]<br> [31:0]<br> [0:0]<br> [31:0]|


### [rv32i_top.sv](./rv32i_top.sv)
|Module Name|Parameters|Inputs|Bit Width|Outputs|Bit Width|
|:---       |   :---   |:---  |:---:     |:---   |:---:     |
|rv32i_top| string DATAMEM_FILE<br> int DATAMEM_SIZE<br> string TEXTMEM_FILE<br> int TEXTMEM_SIZE| clk<br> rst_n|[0:0]<br>[0:0]|None||






