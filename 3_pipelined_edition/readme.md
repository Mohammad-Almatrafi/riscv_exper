# pipeline edition

## source tree

```
├── scripts/*                       //for verification
└── src                             //HDL and test_benches
    ├── HDL
    │   ├── core.sv
    │   ├── rv32i_top.sv
    │   └── utils                   // has its own md
    │       ├── control_utils.sv
    │       ├── datapath_utils.sv
    │       ├── defines.sv
    │       ├── holy_core_pkg.sv
    │       ├── main_control.sv
    │       └── memory.sv
    ├── tb
    │   ├── Makefile
    │   ├── rv32i_top_tb.py
    │   └── rv32i_top_wrapper.sv
    └── tracer                      // has its own md
        ├── ibex_pkg.sv
        ├── ibex_tracer_pkg.sv
        └── ibex_tracer.sv
```


