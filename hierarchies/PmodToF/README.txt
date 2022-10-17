## Adding PmodToF Hierarchy IP to your Design

Please follow the guide :

https://reference.digilentinc.com/learn/programmable-logic/tutorials/vivado-hierarchical-blocks/start

Hierarchy Requirements
* Using the Board Flow it requires the board files (Installation steps https://reference.digilentinc.com/reference/software/vivado/board-files?redirect=1 )


Hierarchy Port Requirements
---------------------------
* s_axi_aclk: The AXI IIC IP core requires that the AXI clock frequency be at least 25 MHz and 25 times faster than the SCL clock frequency.
Since the ToF requires an IIC SCL clock frequency of 100KHz, s_axi_aclk's frequency must be at least 25 MHz.

Constraints
-----------
* When using the Board Flow, no additional constraints are required.
* When not using the Board Flow, template constraints for the Pmod_out port can be found in the imported "PmodToF_*.xdc" file.
