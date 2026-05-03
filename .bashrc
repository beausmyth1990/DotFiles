PROMPT_COMMAND=__append_unsuccessful_exit_status

__append_unsuccessful_exit_status() {
  EXIT="$?"
  PS1="\e[66;34m\u\e[0m"

  if [ $EXIT != 0 ]; then
    PS1="$PS1\e[95;5m$EXIT\e[0m"
  fi
}

export WORKBOOK_DIR=~/workbook/

alias ls="ls -la"
alias cat="batcat"
alias gs="git status"
alias gc="git commit . -m"
alias gp="git pull"
alias gpsh="git push"
alias vi="nvim"
alias vim="nvim"
alias tr1="tree -L 1"
alias tr2="tree -L 2"
alias tr3="tree -L 3"
alias tr4="tree -L 4"

spinner() {
  PID=$(
    "$1" >/dev/null "${*:2}" &
    echo $!
  )
  SPINNER_FRAMES=("|" "/" "-" "\\")
  FRAME_INDEX=0
  until ! [[ $(ps | grep "$PID") ]]; do
    printf "\b${SPINNER_FRAMES[$FRAME_INDEX]}"
    sleep .25
    FRAME_INDEX="$(($FRAME_INDEX + 1))"
    if [[ $FRAME_INDEX == ${#SPINNER_FRAMES[@]} ]]; then
      FRAME_INDEX=0
    fi
  done
  printf "\b"
}

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
    echo 'please provide a workbook name' >&2
    return 1
  fi

  # If there are multiple files starting with the same name and an exact name is NOT found,
  # then we should advise the user that the specified file is ambiguous.
  if [[ $(find $WORKBOOK_DIR -name $1* | wc -l) -gt 1 ]] && [[ $(find $WORKBOOK_DIR -name $1 | wc -l) -eq 0 ]]; then
    echo 'multiple worbooks begin with this name' >&2
    return 1
  fi

  if [[ -z $2 ]]; then
    echo 'please provide a workbook entry' >&2
    return 1
  fi

  local date=$(date '+%Y-%m-%d')
  local time=$(date '+%H:%M')

  if ! [[ -d $WORKBOOK_DIR ]]; then
    mkdir $WORKBOOK_DIR
  fi

  local existing="$(basename $(find $WORKBOOK_DIR -name $1) 2>/dev/null)"
  # if we didn't find an exact match then we look for a partial match
  if [[ $existing -eq '' ]]; then
    existing="$(basename $(find $WORKBOOK_DIR -name $1* | head -n 1) 2>/dev/null)"
  fi

  wb=$WORKBOOK_DIR
  # if no partial or exact existing file was found then
  # we need to create one as this means it's a new workbook
  if [[ $existing == '' ]]; then
    wb=$wb"/$1"
    touch $wb
  else
    wb=$wb"/$existing"
  fi

  if [[ $(grep $date <$wb | wc -l) -eq 0 ]]; then
    printf "\n$date\n\n" >>$wb
  fi

  printf "$time: %s\n" "${*:2}" >>$wb
}

cd ~

# Filter out any references to the mnt directory, so it doesn't pollute the PATH
PATH="$(echo $PATH | tr ':' "\n" | grep -e '^/[^mnt]' | tr "\n" ':')"

pwd
