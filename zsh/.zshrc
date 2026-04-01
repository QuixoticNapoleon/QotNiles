# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
# ░     ░░░░░   ░░░░   ░░░░░░░        ░   ░░░      ░░░   ░░░░   
# ▒  ▒▒   ▒▒▒   ▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒   ▒▒▒   ▒▒▒▒   ▒   ▒▒▒▒   
# ▒  ▒▒▒   ▒▒   ▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒▒▒▒   ▒▒▒▒▒   ▒▒▒▒▒▒▒   ▒▒▒▒   
# ▓      ▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓          
# ▓  ▓▓▓▓   ▓   ▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓   ▓▓▓▓   
# ▓  ▓▓▓▓▓  ▓   ▓▓▓▓   ▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓   ▓▓▓▓   ▓   ▓▓▓▓   
# █    █   ██   ████   ███████            ███      ███   ████   
# ██████████████████████████████████████████████████████████████

# ╔══════════════════════════════════════════════════════════════╗
# ║                    ⚡ ZSH Configuration ⚡                  ║
# ╚══════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────────────────┐
# │ 🚀 Powerlevel10k Instant Prompt                              │
# │ Must stay near top. Console input goes ABOVE this block.     │
# └──────────────────────────────────────────────────────────────┘
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ┌──────────────────────────────────────────────────────────────┐
# │ 🎨 Oh My Zsh                                                 │
# └──────────────────────────────────────────────────────────────┘
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# ┌──────────────────────────────────────────────────────────────┐
# │ ⚙️  Settings                                                 │
# └──────────────────────────────────────────────────────────────┘
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="%F{yellow}...%f"

setopt beep notify
setopt CORRECT

# ┌──────────────────────────────────────────────────────────────┐
# │ 📜 History                                                   │
# └──────────────────────────────────────────────────────────────┘
HIST_STAMPS="%Y-%m-%d %H:%M:%S"
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000000000

# ┌──────────────────────────────────────────────────────────────┐
# │ 🧩 Plugins                                                   │
# └──────────────────────────────────────────────────────────────┘
plugins=(git)
source $ZSH/oh-my-zsh.sh
unset LS_COLORS #unset ls colors

# ┌──────────────────────────────────────────────────────────────┐
# │ 🔍 FZF                                                       │
# └──────────────────────────────────────────────────────────────┘
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--color=fg+:#8affff,bg+:#225859,header:#FFC600,info:#FFC600,pointer:#8affff,marker:#8affff,prompt:#ffC600,spinner:#FFC600,query:#8affff,hl:#FFC600,hl+:#FFC600,border:#00b4b4"

# ┌──────────────────────────────────────────────────────────────┐
# │ 📂 Zoxide                                                    │
# └──────────────────────────────────────────────────────────────┘
eval "$(zoxide init zsh)"

# ┌──────────────────────────────────────────────────────────────┐
# │ 🔧 Completion                                                │
# └──────────────────────────────────────────────────────────────┘
zstyle :compinstall filename '/home/bh/.zshrc'
autoload -Uz compinit
compinit

# ┌──────────────────────────────────────────────────────────────┐
# │  Python
# └──────────────────────────────────────────────────────────────┘
export PYTHONSTARTUP="$HOME/.pythonrc"

# ┌──────────────────────────────────────────────────────────────┐
# │ ✏️  Editor                                                   │
# └──────────────────────────────────────────────────────────────┘
export EDITOR="nvim"
export VISUAL="nvim"

# ┌──────────────────────────────────────────────────────────────┐
# │ 🏷️  Aliases                                                  │
# └──────────────────────────────────────────────────────────────┘
# ls Commands
alias ls="eza --icons --group-directories-first"
alias l='eza -laahg --icons --group-directories-first --time-style="+%d %b %Y %H:%M:%S"'
alias ll='eza -laahg --icons --group-directories-first --time-style="+%d %b %Y %H:%M:%S"'
alias tree='eza --tree --icons --group-directories-first --time-style="+%d %b %Y %H:%M:%S"'
# Other Commands
alias vi="nvim"
alias sudo='sudo '
alias icat="kitty icat"
alias py="python"
alias rename="perl-rename"
alias vimv="~/Scripts/vimv"
alias fetch="fastfetch"

# ┌──────────────────────────────────────────────────────────────┐
# │ ⚙️  Functions
# └──────────────────────────────────────────────────────────────┘
takedir() {
	if [[ $# -eq 1 ]]; then
		mkdir -p "$1" && cd "$1"
	elif [[ $# -ge 2 ]]; then
		local dest="${@:$#}"
		mkdir -p "$dest"
		local abs_dest srcs=() src
		abs_dest=$(realpath "$dest")
		for src in "${@:1:$#-1}"; do
			[[ "$(realpath "$src" 2>/dev/null)" != "$abs_dest" ]] && srcs+=("$src")
		done
		[[ ${#srcs[@]} -gt 0 ]] && mv "${srcs[@]}" "$dest"
		cd "$dest"
	else
		echo "usage: take <dir> OR take <sources...> <destdir>"
		return 1
	fi
}

tt() {
	kitty @ set-font-size +12
	~/Scripts/tt -notheme
	kitty @ set-font-size 10.5
}


# ┌──────────────────────────────────────────────────────────────┐
# │ 🎯 Prompt                                                    │
# └──────────────────────────────────────────────────────────────┘
# To customize, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ┌──────────────────────────────────────────────────────────────┐
# │ 📦 PATH                                                      │
# └──────────────────────────────────────────────────────────────┘
export PATH="$PATH:/home/bh/.local/bin"
