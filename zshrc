# zmodload zsh/zprof
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="trapd00r"
# trapd00r

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "xiong-chiamiov" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

##
# History
##
setopt hist_ignore_all_dups # no duplicate
# setopt PROMPT_SUBST

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-completions zsh-syntax-highlighting zsh-autosuggestions z ssh-agent)
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Funciones

function docker_list () {
containers=$(docker ps | awk '{if (NR!=1) print $1 ": " $(NF)}')
echo "👇 Containers 👇"
echo $containers
}

function prompt_exit_code() {
  local EXIT="$?"

  if [ $EXIT -eq 0 ]; then
    echo -n green
  else
    echo -n red
  fi
}


# Configuracioon de atajos

_display_message() {
  dirtomove=$(ls -ad */ | fzf)
  cd "$dirtomove"
}

zle         -N    _display_message
bindkey  '^l'  _display_message

_display_docker() {

    dockerps=$(docker ps --format '{{.ID}}\t{{.Names}}\t\t{{.Image}}\t\t{{.Status}}')
    container=$(echo $dockerps | fzf --layout=reverse-list --header "<CONTAINER ID> <NAME> <IMAGE> <Status>" --tabstop=4)
    containerid=$(echo $container | awk '{print $1;}')
    containername=$(echo $container | awk '{print $2;}')

    answer=$(echo "No\nYes" | fzf --tac --no-sort --header "Do you want to stop the container <${containername}> (if is not stopped) and removeit?")

    case ${answer:0:1} in
        [nN])
            #echo "Nothing to do. Bye!"
            ;;
        *)
            if [[ ! -z $containerid ]]; then
                docker stop -t 0 "$containerid"
                docker rm -v "$containerid"
            fi
            ;;
    esac
}

zle -N _display_docker
bindkey '^k' _display_docker

_reverse_search() {
  local selected_command=$(fc -rl 1 | awk '{$1="";print substr($0,2)}'| fzf)
  LBUFFER=$selected_command
}

zle -N _reverse_search
bindkey '^r' _reverse_search

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias cdc="$HOME/Code"
alias cdw="$HOME/Work"
alias cdh="$HOME"
alias ll="exa -l"
alias la="exa -la"
alias lha="exa -lha"
alias vpnstop='systemctl stop openfortivpn'
alias vpnstart='systemctl start openfortivpn'
alias vpnstatus='systemctl status openfortivpn'
alias install='apt install'
alias cheat='docker run --rm bannmann/docker-cheat'
alias shfmt='docker run --rm -it -v "$(pwd)":/scripts -w /scripts peterdavehello/shfmt:latest shfmt'
alias dl="docker_list"
alias ps2='ps -ef | grep -v $$ | grep -i'
alias zsh1="vim $HOME/.zshrc"
alias zsh2="source $HOME/.zshrc"
alias icat="kitty +kitten icat"
alias idiff="kitty +kitten diff"
alias iola="$HOME/Work/iol-argentina"
alias cdp="$HOME/.pem"
alias j="z"

# zprof

