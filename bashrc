function ingitrepo {
    git status -s > /dev/null 2> /dev/null
    if [[ $? == 0 ]]; then
        echo 1
    else
        echo 0
    fi
}

function gituntrackednum {
    echo -e `git status -s -uno | wc -l`
}

function gitcurbranch {
    echo -e `git describe --tags --dirty=+ --always` `git rev-parse --abbrev-ref HEAD`
}

function setPS1 {
    lastcmdstatus=$?
    graycolor="\[\033[1;30m\]"
    timecolor="34m"
    if [[ $lastcmdstatus != 0 ]]; then
        timecolor="41;1;33m"
    fi
    usercolor="0;36m"
    if [[ $EUID == 0 ]]; then
	    usercolor="1;31m"
    fi
    if [ "$TERM" != "dumb" ]; then
        export FRMT_RESET="\[\033[00m\]"
        export PROMPT_PART_HOST="\[\033[${usercolor}\]\u\[\033[01;30m\]@\[\033[0;36m\]\h"
        export PROMPT_PART_PWD="\[\033[1;34m\]\w${FRMT_RESET}"
        export PROMPT_PART_TIME="${graycolor}[${FRMT_RESET}\[\033[${timecolor}\]\T \d${FRMT_RESET}${graycolor}]${FRMT_RESET}"
        if [[ $lastcmdstatus != 0 ]]; then
            export PROMPT_PART_TIME="${PROMPT_PART_TIME} ${graycolor}(\[\033[00;31;1m\]${lastcmdstatus}${graycolor})${FRMT_RESET}"
        fi
        export PROMPT_PART_FINAL="${FRMT_RESET}\\$ "
        export PROMPT_PART_GIT=""
        inarepo=$(ingitrepo)
        if [[ $inarepo == 1 ]]; then
            numuntracked=$(gituntrackednum)
            export PROMPT_PART_GIT=" ${FRMT_RESET}${graycolor}<\[\033[00;33m\]$(gitcurbranch)"
            if [[ $numuntracked != 0 ]]; then
                export PROMPT_PART_GIT="${PROMPT_PART_GIT}${FRMT_RESET}:\[\033[00;31m\]${numuntracked}"
            fi
            export PROMPT_PART_GIT="${PROMPT_PART_GIT}${FRMT_RESET}${graycolor}>${FRMT_RESET}"
        fi
        export PS1="${PROMPT_PART_TIME}${PROMPT_PART_GIT} ${PROMPT_PART_HOST}${graycolor}:${FRMT_RESET}${PROMPT_PART_PWD}\n${PROMPT_PART_FINAL}"
    else
        export PS1="\w \$ "
    fi
}

export CLICOLOR=1
export PROMPT_COMMAND="setPS1"
export EDITOR=vim

alias csr='EDITOR=vim cscope -R'
alias grb='git checkout master && git pull --rebase && git checkout - && git rebase master'
alias grbi='git checkout master && git pull --rebase && git checkout - && git rebase -i master'
alias gdm='git diff | code -'

export PYTHONUNBUFFERED=1
