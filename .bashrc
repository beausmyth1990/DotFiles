PROMPT_COMMAND=__build_prompt

__build_prompt() {
  local exit=$?

  # Colors (wrapped in \[ \] so bash ignores their width)
  local reset="\[\e[0m\]"
  local s1_bg="\[\e[44m\]"
  local s1_fg="\[\e[97m\]"
  local s2_bg="\[\e[100m\]"
  local s2_fg="\[\e[97m\]"
  local s3_bg="\[\e[42m\]"
  local s3_fg="\[\e[30m\]"
  local err_bg="\[\e[41m\]"
  local err_fg="\[\e[97m\]"

  # Segment 1: username
  local s1=" $s1_bg$s1_fg \u $reset"

  # Segment 2: current directory
  local s2=" $s2_bg$s2_fg \w $reset"

  # Segment 3: git branch (only inside a git repo)
  local s3=""
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ -n $branch ]]; then
    s3=" $s3_bg$s3_fg ± $branch $reset"
  fi

  # Segment 4: exit code (only on failure, red bg + ✗ prefix)
  local s4=""
  if [[ $exit != 0 ]]; then
    s4=" $err_bg$err_fg ✗ $exit $reset"
  fi

  # Line 1: segments | Line 2: prompt char (red on error, white on success)
  local prompt_clr
  [[ $exit != 0 ]] && prompt_clr="\[\e[91m\]" || prompt_clr="\[\e[97m\]"

  PS1="$s1$s2$s3$s4\n${prompt_clr}❯${reset} "
}

export WORKBOOK_DIR=~/workbook/

alias ls="ls -la"
alias cat="batcat"
alias gs="git status"
alias gc="git commit . -m"
alias gp="git pull"
alias gd="git diff"
alias gpsh="git push"
alias pgpsh="cb < ~/.github/PAT && gpsh"
alias pgp="cb < ~/.github/PAT && gp"
alias vi="nvim"
alias vim="nvim"
alias tr1="tree -L 1"
alias tr2="tree -L 2"
alias tr3="tree -L 3"
alias tr4="tree -L 4"
alias cb="xclip -sel clipboard"
alias clr="clear"

# Bell / alert helper (double-flash)
alert() {
  echo -e "\a"
  sleep 0.2
  echo -e "\a"
}

far() {
  while getopts "f" opts; do
    case "$opts" in
    "f")
      RENAME_FILES=true
      ;;
    esac
  done

  local FIND="$1"
  local REPACE="$2"
  local DIR="$3"

  rg $FIND $DIR | awk -F : '{ print $1 }' | xargs sed -i "s/$FIND/$REPACE/g"

  if [ -z "$RENAME_FILES" ]; then
    echo 'time to rename files with the same name match'
  fi
}

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
  local cell_width=5  # " NNN " = 5 chars
  local cols=$(( ${COLUMNS:-80} / cell_width ))
  for i in {0..255}; do
    printf "\e[48;5;${i}m\e[38;5;255m %3d \e[0m" "$i"
    [[ $(( (i + 1) % cols )) -eq 0 ]] && echo
  done
  echo
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
  if [[ $existing == '' ]]; then
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

# Set cursor to blinking block
printf '\e[1 q'

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;31m'                 # begin blink (red)
export LESS_TERMCAP_md=$'\e[38;5;217m'             # begin bold (salmon pink) - headings
export LESS_TERMCAP_me=$'\e[0m'                    # end bold/blink
export LESS_TERMCAP_us=$'\e[38;5;181m'             # begin underline (soft salmon) - values
export LESS_TERMCAP_ue=$'\e[0m'                    # end underline
export LESS_TERMCAP_so=$'\e[48;5;217m\e[38;5;232m' # begin standout (salmon bg, near-black text)
export LESS_TERMCAP_se=$'\e[0m'                    # end standout
export GROFF_NO_SGR=1                              # required for some distros
