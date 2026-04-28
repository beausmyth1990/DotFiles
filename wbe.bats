#!/usr/bin/bats

setup(){
		. ~/.bashrc
}

@test "wbe | no workbook specified |  exit code 1 and error message" {
	        run wbe
		[ "$status" -eq 1 ]
		[ "$output" = "workbook not specified" ]
}

@test "wbe | no entry specified | exit code 1 and error message" {
		local workbook="$(uuidgen)_test_workbook"

		run wbe $workbook

		[ "$status" -eq 1 ]
		[ "$output" = "entry not specified" ]
}

@test "wbe | workbook file does not exist | workbook file created with date and time-stamped entry" {
		local workbook="$(uuidgen)"
		
		! [[ -e ~/workbook/"$workbook" ]]

 		run wbe $workbook "some entry..."

		[[ -e ~/workbook/"$workbook" ]]
		[[ $( grep "$(date '+%Y-%m-%d')" < ~/workbook/"$workbook" | wc -l ) -eq 1 ]]
		[[ $( grep "$(date '+%H:%M'):" < ~/workbook/"$workbook" | wc -l ) -eq 1 ]]

		rm ~/workbook/"$workbook"
}

@test "wbe | date exists in file | consecutive entries do not cause duplicate date stamps, with each entry time-stamped" {
		local workbook="$(uuidgen)"

 		run wbe $workbook "some entry...1"
 		run wbe $workbook "some entry...2"
 		run wbe $workbook "some entry...3"

		# 3 entries above means a single date stamp followed by
		# 3 time-stamped entries
		[[ -e ~/workbook/"$workbook" ]]
		[[ $( grep -e "^$(date '+%Y-%m-%d')$" < ~/workbook/"$workbook" | wc -l ) -eq 1 ]]
		[[ $( grep "$(date '+%H:%M'):" < ~/workbook/"$workbook" | wc -l ) -eq 3 ]]

		rm ~/workbook/"$workbook"
}

@test "wbe | partial filename specified with only a single match | entry is inserted into file that matches" {
		local workbook="test_$(uuidgen)"
		# ensure that this workbook is pre-existing
		touch ~/workbook/"$workbook"
	
		run wbe 'test' "some entry..."

		! [[ -e ~/workbook/"test" ]]
		[[ $( grep -e "^$(date '+%Y-%m-%d')$" < ~/workbook/"$workbook" | wc -l ) -eq 1 ]]
		[[ $( grep "$(date '+%H:%M'):" < ~/workbook/"$workbook" | wc -l ) -eq 1 ]]

		rm ~/workbook/"$workbook"
}
