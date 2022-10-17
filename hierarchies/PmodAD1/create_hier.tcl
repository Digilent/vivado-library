# This script manages dependencies and name resolution for the bd.tcl script

set script_dir [file normalize [file dirname [info script]]]

# If vivado-hierarchies/repo is not included in the project's list of IP repos, add it
set ip_repo_list [get_property IP_REPO_PATHS [current_project]]
set ip_repo_path [file normalize $script_dir/../..]
if {[lsearch $ip_repo_list $ip_repo_path] == -1} {
	lappend ip_repo_list $ip_repo_path
	set_property IP_REPO_PATHS $ip_repo_list [current_project]
	update_ip_catalog
	puts "Loaded IP Repo $ip_repo_path"
}

# Add source files to the project
set list_source_files [glob -nocomplain [file join $script_dir sources *]]
if { [llength $list_source_files] > 0 } {
	# adding the same file more than once is okay
	catch { add_files -fileset sources_1 $list_source_files }
}

# Resolve hierarchy name
set pmod [file tail $script_dir]
for {set idx 0} {[llength [get_bd_cells /${pmod}_${idx}]] > 0} {incr idx} {}
set nameHier ${pmod}_${idx}; # Find first unused trailing number for a name like PmodNAV_0

# Create temporary copies of each constraint file,
#  add the hierarchy name to the name as an affix, 
#  if a file with the same name already exists, add a number as a suffix
#  then import them into the project
set list_constr_files [glob -nocomplain [file join $script_dir constrs *]]
set tempdir [file join $script_dir temp]
file mkdir $tempdir
set existing_constrs []
foreach constr [get_files -of_objects [get_filesets constrs_1]] {
	lappend existing_constrs [file tail ${constr}]
}
foreach constr $list_constr_files {
	set constr_tail [file rootname [file tail ${constr}]]
	set constr_ext [file extension ${constr}]
	set filename ${nameHier}_${constr_tail}${constr_ext}
	if {[lsearch $existing_constrs ${filename}] == -1} {
		file copy ${constr} [file join ${tempdir} ${filename}]
	} else {
		for {set idx 0} {[lsearch $existing_constrs ${nameHier}_${constr_tail}_${idx}${constr_ext}] != -1} {incr idx} {}
		set filename ${nameHier}_${constr_tail}_${idx}${constr_ext}
		file copy ${constr} [file join ${tempdir} ${filename}]
	}
}
set list_temp_constr_files [glob -nocomplain [file join ${tempdir} *]]
catch { import_files -fileset constrs_1 $list_temp_constr_files }
file delete -force $tempdir

# call the process created in the bd.tcl script. recreates the described hierarchy
source -notrace [file join $script_dir "bd.tcl"]
create_hier_cell_${pmod}_* / $nameHier

# add README.txt text to the project as a comment attached to the hierarchy
set fp [open [file join $script_dir "README.txt"] r]
set comment_text [read $fp]
close $fp
set_property USER_COMMENTS.readme $comment_text [get_bd_cells $nameHier/pmod_bridge_0]
