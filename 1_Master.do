************************************************
** Master Do-File
** Author: Maria Schäfer
************************************************

clear all
cap log close
set more off, perm
cls

*Create directory/path to project 1
global dir "C:\Users\mschaefer41\sciebo2\LWC_geteilt\RegioHealthBielefeld\Code_Do-Files"
cap mkdir "$dir/Project 1"

*Create folders Code, Data, Tables, Graphs as well as Raw Data
local i=1
local folder Code Data Tables Graphs Raw_Data
foreach n of local folder{
	cap mkdir "$dir/Project 1/`i'_`n'"
	local ++i
}

*Pathways set-up
global code "$dir/Project 1/1_Code"
global data "$dir/Project 1/2_Data"
global tables "$dir/Project 1/3_Tables"
global graphs "$dir/Project 1/4_Graphs"
global raw "$dir/Project 1/5_Raw_Data"
global SOEP "C:\Users\mschaefer41\sciebo2\Dokumente\SOEP_DATA\soepdata"
