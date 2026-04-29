PS1="\e[34;66m\u$\e[0m"

alias ls="ls -la"
alias cat="batcat"
alias gs="git status"
alias gc="git commit . -m"
alias gp="git pull"
alias gpsh="git push"
alias vi="nvim"
alias vim="nvim"

printfln_clr() {
  printf "\e[$1;$2m%s\e[0m\n" "${*:3}"
}

preview_clrs() {
  for i in {0..100}; do
    printfln_clr $i $((100 - $i)) "$i;$((100 - $i))"
  done
}

wbe() {
  if [[ -z $1 ]]; then
    echo "workbook not specified" >&2
    return 1
  fi

  # If there are multiple files starting with the same name and an exact name is NOT found,
  # then we should advise the user that the specified file is ambiguous.
  if [[ $(find ~/workbook/ -name $1* | wc -l) -gt 1 ]] && [[ $(find ~/workbook/ -name $1) -eq 0 ]]; then
    echo 'more than a single workbook match, please be more specific' >&2
    return 1
  fi

  if [[ -z $2 ]]; then
    echo "entry not specified" >&2
    return 1
  fi

  local date=$(date '+%Y-%m-%d')
  local time=$(date '+%H:%M')

  if ! [[ -d ~/workbook ]]; then
    mkdir ~/workbook
  fi

  local existing="$(basename $(find ~/workbook/ -name $1) 2>/dev/null)"
  # if we didn't find an exact match then we look for a partial match
  if [[ $existing == '' ]]; then
    existing="$(basename $(find ~/workbook/ -name $1* | head -n 1) 2>/dev/null)"
  fi

  wb='workbook'
  # if no partial or exact existing file was found then
  # we need to create one as this means it's a new workbook
  if [[ $existing == '' ]]; then
    wb="$wb/$1"
    touch ~/$wb
  else
    wb="$wb/$existing"
  fi

  if [[ $(grep $date <~/$wb | wc -l) -eq 0 ]]; then
    printf "\n$date\n\n" >>~/$wb
  fi

  printf "$time: %s\n" "${*:2}" >>~/$wb
}

cd ~

# Filter out any references to the mnt directory, so it doesn't pollute the PATH
PATH="$(echo $PATH | tr ':' "\n" | grep -e '^/[^mnt]' | tr "\n" ':')"

pwd
