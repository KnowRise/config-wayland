#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
source /usr/share/nvm/init-nvm.sh
alias code="code --password-store=gnome-libsecret"
# Fungsi buat Backup Config + Update List Aplikasi
function backup_dotfiles() {
    echo "📦 Mengupdate daftar aplikasi..."
    pacman -Qqe > ~/dotfiles/pkglist_native.txt
    pacman -Qqm > ~/dotfiles/pkglist_aur.txt
    
    echo "🚀 Mengirim ke GitHub..."
    cd ~/dotfiles
    git add .
    git commit -m "Update config & package list: $(date)"
    git push origin main
    
    # Balik ke folder asal
    cd -
    echo "✅ Selesai!"
}
