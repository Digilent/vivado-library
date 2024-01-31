set ClockGenPriRefClk_period 2.500; # 400MHz max frequency expected for ClockGenPriRefClk_period
create_clock -period $ClockGenPriRefClk_period -name ClockGenPriRefClk -waveform {0.000 1.250} -add [get_ports ClockGenPriRefClk]
set SysClk100_period 10.000; # 100MHz frequency expected for SysClk100
create_clock -period $SysClk100_period -name SysClk100 -waveform {0.000 5.000} -add [get_ports SysClk100]
