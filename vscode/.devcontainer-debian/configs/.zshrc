#   --------------------------------------------------------------------------------------------------------------------
#   1. PARAMETER OH MY ZSH SHELL
#   --------------------------------------------------------------------------------------------------------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export PATH=/bin:/usr/bin:/usr/local/bin:${PATH}

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
ZDOTDIR=~/.config/zsh

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
plugins=(git)

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


#   --------------------------------------------------------------------------------------------------------------------
#   2. MAKE TERMINAL BETTER
#   --------------------------------------------------------------------------------------------------------------------

# Definition of aliases for the most useful commands
alias gibboneto_ssh='ssh-add -K ~/.ssh/gibboneto_rsa'   # Activate SSH for personal GitHub
alias ledger_ssh='ssh-add -K ~/.ssh/id_rsa; git config user.name Quentin Gaborit; git config user.email quentin.gaborit@ledger.fr'

alias cp='cp -iv'                                       # Preferred 'cp' implementation
alias mv='mv -iv'                                       # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                                 # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                                   # Preferred 'ls' implementation
alias less='less -FSRXc'                                # Preferred 'less' implementation
alias cd..='cd ../'                                     # Go back 1 directory level (for fast typers)
alias ..='cd ../'                                       # Go back 1 directory level
alias ...='cd ../../'                                   # Go back 2 directory levels
alias .3='cd ../../../'                                 # Go back 3 directory levels
alias .4='cd ../../../../'                              # Go back 4 directory levels
alias .5='cd ../../../../../'                           # Go back 5 directory levels
alias .6='cd ../../../../../../'                        # Go back 6 directory levels
alias edit='code'                                       # edit:         Opens any file in code editor
alias f='open -a Finder ./'                             # f:            Opens current directory in MacOS Finder

#   ----------------------------------------------------------
#   Show and hide files in finder
#   ----------------------------------------------------------
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE; killAll Finder'        # Show hidden files in Finder
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE; killAll Finder'       # Hide hidden files in Finder

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
