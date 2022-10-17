Pmod_Bridge IP
==============

Using the IP in Vivado
--------------
This IP core is primarily intended as a component of other Pmod IP cores. As such,
it is not directly supported by any Digilent-provided tutorials.

However, the Pmod bridge can be used to connect various AXI controllers, (AXI GPIO,
IIC, SPI, UARTlite) to the Pmod interfaces provided as part of Digilent's board files.

It is also possible to manually connect non-IIC interfaces with non-standard pin
mappings to a Pmod bridge IP. Heavy use of concat and slice blocks is likely required.
