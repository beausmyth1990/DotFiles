PS1="\e[34;66m\u$\e[0m"

alias ls="ls -la"
alias cat="batcat"
alias gs="git status"
alias gc="git commit . -m"
alias gp="git pull"
alias gpsh="git push"

printfln_clr(){
	printf "\e[$1;$2m%s\e[0m\n" "${*:3}";
}

preview_clrs(){
	for i in {0..100}; do
		printfln_clr $i $((100 - $i)) "some color"
	done;
}

wbe(){
	if [[ -z $1 ]]; then
		echo "workbook not specified" >&2
		return 1;
	fi

	if [[ $( find ~/workbook/ -name $1* | wc -l ) -gt 1 ]]; then
		echo 'more than a single workbook match, please be more specific' >&2
		return 1;
	fi

	if [[ -z $2 ]]; then
		echo "entry not specified" >&2
		return 1;
	fi

	local date=$(date '+%Y-%m-%d');
	local time=$(date '+%H:%M');

        if ! [[ -d ~/workbook ]]; then
		mkdir ~/workbook
	fi

	existing="$(basename $(find ~/workbook/ -name $1* | head -n 1))"
	wb=''

	if [[ $existing == '' ]]; then
		echo $existing
		wb=workbook/"$1"
		touch ~/$wb
	else
		wb=workbook/"$existing"
	fi

	if [[ $(grep $date < ~/$wb | wc -l) -eq 0 ]]; then
		 printf "$date\n\n" >> ~/$wb
	fi

	printf "$time: %s\n" "${*:2}" >> ~/$wb
}

cd ~

pwd
