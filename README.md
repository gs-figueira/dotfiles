# dotfiles

## Maquina Nova
sudo pacman -Syu git
git clone https://github.com/gs-figueira/dotfiles ~/dotfiles

~/dotfiles/install/dev.sh

## Atualziar o Sistema
1. Trocar a data em `packages/arch.lock`
2. Rodar `install/dev.sh`
3. Se funcionar: commit. Se quebrou: volta a data e roda de novo.

## Para adicionar pacotes
1. Adicionar o pacote em `packages/dev.txt`
2. Instalar e testar.
3. Se funcionar: commit. Se quebrar: remove o pacote do dev.txt
