create_project -part xc7a100tcsg324-1 -force vivado_synth.xpr /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0
read_ip /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.xci
update_compile_order -fileset sources_1
set ip_synth_type [get_property GENERATE_SYNTH_CHECKPOINT [get_files /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.xci ]]
if {$ip_synth_type != "" && $ip_synth_type != "1"} {
puts "IP was generated using Global synth mode. Hence regenerating with OOC mode"
reset_target all [get_files /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.xci]
set_property GENERATE_SYNTH_CHECKPOINT TRUE [get_files /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.xci ]
}
generate_target all [get_files /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.xci ]
catch { config_ip_cache -export [get_ips -all design_2_mig_7series_custom_1_0 ] }
export_ip_user_files -of_objects [get_files /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.xci] -no_script -sync -force -quiet
create_ip_run -force [get_files -of_objects [get_fileset sources_1] /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.xci]
launch_runs -jobs 26 design_2_mig_7series_custom_1_0_synth_1
wait_on_run design_2_mig_7series_custom_1_0_synth_1
open_run design_2_mig_7series_custom_1_0_synth_1
write_verilog -force /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.v
write_checkpoint -force /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.dcp
write_xdc -force /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0/design_2_mig_7series_custom_1_0.xdc
set top_ip_name [file join /slowfs/cae265/users/estay/src/vivado-library/ip/mig_7series_custom/design_2_mig_7series_custom_1_0 name.txt ]
if { [catch {open $top_ip_name w} fp] } {
close $fp
 } else {
puts $fp [get_property TOP [current_design] ] 
close $fp
}
close_project

