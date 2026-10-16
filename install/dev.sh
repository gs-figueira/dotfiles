#!/usr/bin/bash
# Configura o ambiente de dev a partir da repo

# Fail guard
set -eou pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_DATE="$(tr -d '[:space:]' < "$DOTFILES/packages/arch.lock")"
NVIM_DIR="$HOME/.config/nvim"

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }

log "Travando repositórios em $LOCK_DATE"
if [[ ! -f /etc/pacman.d/mirrorlist.live ]]; then
  sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.live
fi
sudo tee /etc/pacman.d/mirrorlist > /dev/null <<EOF
# Gerado por dotfiles/install/dev.sh — mude packages/arch.lock
Server = https://archive.archlinux.org/repos/$LOCK_DATE/\$repo/os/\$arch
EOF

log "Sincronizando sistema e instalando pacotes"
grep -vE '^\s*(#|$)' "$DOTFILES/packages/dev.txt" | sudo pacman -Syyuu --needed -

if ! gh auth status &> /dev/null; then
  log "Login no GitHub"
  gh auth login --git-protocol https --web
fi

if [[ -z "$(git config --global user.name || true)" ]]; then
  log "Configurando identidade do git"
  read -rp "Nome para commits: " git_name
  read -rp "Email para commits: " git_email
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
  git config --global init.defaultBranch main
fi

if [[ ! -d "$NVIM_DIR/.git" ]]; then
  log "Clonando seu fork do kickstart.nvim"
  gh repo clone kickstart.nvim "$NVIM_DIR"
fi

log "Pronto! Abra o nvim: os plugins instalam nas versões do nvim-pack-lock.json"
