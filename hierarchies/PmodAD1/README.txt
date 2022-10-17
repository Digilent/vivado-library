Hierarchy Port Requirements
* s_axi_aclk: 100 MHz
Clocks of different frequencies can be used, provided that care is taken to correctly
set the PmodAD1_AXI module parameters

Constraints
* When using the Board Flow, no additional constraints are required
* When not using the Board Flow, template constraints for the Pmod_out port can be found in
the imported PmodAD1_*.xdc file