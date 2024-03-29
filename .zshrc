# Set up the prompt

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

setopt inc_append_history # save every command before it runs
setopt histignorealldups sharehistory

#export ZSH=$HOME/.oh-my-zsh
export ZSH=~/.oh-my-zsh
ZSH_THEME="robbyrussell"

# Path
# shortcut to this dotfiles path is $ZSH
export PATH=$PATH:$ZSH/bin:~/.nvm/versions/node/v16.16.0/bin

# Envvars
export EDITOR=vim
export VISUAL=vim

# Enable z script
source ~/dotfiles/roles/z/enable.zsh

# use .localrc for SUPER SECRET CRAP that you don't
# want in your public, versioned repo.
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# Enable colour
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color

# config prompt
# Reference for colors: http://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  extract
  z
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source ~/.oh-my-zsh/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

autoload -U colors && colors

setopt PROMPT_SUBST

set_prompt() {

	# [
	PS1="%{$fg[white]%}[%{$reset_color%}"

	# Path: http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
	PS1+="%{$fg_bold[cyan]%}${PWD/#$HOME/~}%{$reset_color%}"

	# Status Code
	PS1+='%(?.., %{$fg[red]%}%?%{$reset_color%})'

	# Git
	if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
		PS1+=', '
		PS1+="%{$fg[blue]%}$(git rev-parse --abbrev-ref HEAD 2> /dev/null)%{$reset_color%}"
		if [ $(git status --short | wc -l) -gt 0 ]; then 
			PS1+="%{$fg[red]%}+$(git status --short | wc -l | awk '{$1=$1};1')%{$reset_color%}"
		fi
	fi


	# Timer: http://stackoverflow.com/questions/2704635/is-there-a-way-to-find-the-running-time-of-the-last-executed-command-in-the-shel
	if [[ $_elapsed[-1] -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[magenta]%}$_elapsed[-1]s%{$reset_color%}"
	fi

	# PID
	if [[ $! -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[yellow]%}PID:$!%{$reset_color%}"
	fi

	# Sudo: https://superuser.com/questions/195781/sudo-is-there-a-command-to-check-if-i-have-sudo-and-or-how-much-time-is-left
	CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
	if [ ${CAN_I_RUN_SUDO} -gt 0 ]
	then
		PS1+=', '
		PS1+="%{$fg_bold[red]%}SUDO%{$reset_color%}"
	fi

	PS1+="%{$fg[white]%}]: %{$reset_color%}% "
}

precmd_functions+=set_prompt

preexec () {
   (( ${#_elapsed[@]} > 1000 )) && _elapsed=(${_elapsed[@]: -1000})
   _start=$SECONDS
}

precmd () {
   (( _start >= 0 )) && _elapsed+=($(( SECONDS-_start )))
   _start=-1 

# KEYBINDINGS

# up
	function up_widget() {
		BUFFER="cd .."
		zle accept-line
	}
	zle -N up_widget
	bindkey "^k" up_widget

# git
	function git_prepare() {
		if [ -n "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -m \"$BUFFER\" && git push"
		fi

		if [ -z "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -v && git push"
		fi
				
		zle accept-line
	}
	zle -N git_prepare
	bindkey "^g" git_prepare

# home
	function goto_home() { 
		BUFFER="cd ~/"$BUFFER
		zle end-of-line
		zle accept-line
	}
	zle -N goto_home
	bindkey "^h" goto_home

# Edit and rerun
	function edit_and_run() {
		BUFFER="fc"
		zle accept-line
	}
	zle -N edit_and_run
	bindkey "^v" edit_and_run

# LS
	function ctrl_l() {
		BUFFER="ls"
		zle accept-line
	}
	zle -N ctrl_l
	bindkey "^l" ctrl_l

# Enter
	function enter_line() {
		zle accept-line
	}
	zle -N enter_line
	bindkey "^o" enter_line

# Sudo
	function add_sudo() {
		BUFFER="sudo "$BUFFER
		zle end-of-line
	}
	zle -N add_sudo
        bindkey "^s" add_sudo
}
#aliases
alias gdry='git commit --dry-run'
alias core='cd ~/eclipse-workspace/core'
alias dui='cd ~/Documents/ali/UI_DEPLOY/Deploy; bash ./deploy_ui.sh; cd -'
alias cpui='cd ~/Documents/ali/UI_DEPLOY; bash ./copy_files.sh; cd -'
function go {
    cd ~/eclipse-workspace/"$1"
}

PATH="/home/fozi/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/fozi/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/fozi/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/fozi/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/fozi/perl5"; export PERL_MM_OPT;
#source $HOME/.nvm/nvm.sh
#nvm use 16.16.0
