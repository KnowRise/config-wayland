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
function start_docker_compose() {
	echo "Menjalankan docker-compose 🔄"
	docker-compose -f /home/knowrise/DATA/Programming/docker-service/docker-compose.yml up -d
	echo "✅ Selesai!"
}
# Function biar laptop GAK SLEEP pas ditutup
# Cara pakai: nosleep 1h (atau 30m, 2h, dll)
function nosleep() {
    # Ambil durasi dari input pertama, kalau kosong default 2 jam
    local DURATION=${1:-2h} 
    
    echo "👁️  MODE BEGADANG AKTIF!"
    echo "💻  Laptop GAK BAKAL SLEEP (Lid Switch Ignored) selama: $DURATION"
    echo "❌  Tekan [Ctrl + C] untuk membatalkan manual."
    echo "---------------------------------------------------"
    
    # Jalankan perintah penahan
    systemd-inhibit --what=handle-lid-switch --who="KnowRise" --why="Manual Override" sleep "$DURATION"
    
    echo "😴  Waktu habis ($DURATION). Kembali ke mode normal."
}
