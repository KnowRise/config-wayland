#!/bin/bash

echo "🔄 Memulai Reset Audio..."

# 1. Matikan service audio user (biar driver dilepas)
systemctl --user stop wireplumber pipewire pipewire-pulse
echo "✅ Pipewire dimatikan."

# 2. Paksa bunuh proses yang masih bandel pake sound card
# (Ini mencegah crash 'Module is in use')
sudo fuser -k -v /dev/snd/* > /dev/null 2>&1
echo "✅ Aplikasi audio dibunuh."

# 3. Reload Driver Kernel (Inti dari solusi Forum Arch)
# Kita coba reload modul utama dan modul AMD spesifik
echo "🔄 Reloading Kernel Modules..."
sudo modprobe -r snd_rn_pci_acp3x 2>/dev/null
sudo modprobe -r snd_pci_acp6x 2>/dev/null
sudo modprobe -r snd_pci_acp5x 2>/dev/null
sudo modprobe -r snd_acp3x_pdm_dma 2>/dev/null
sudo modprobe -r snd_acp3x_rn 2>/dev/null
sudo modprobe -r snd_hda_intel 
sudo modprobe -r snd_hda_codec_realtek 2>/dev/null

sleep 1

# 4. Pasang ulang drivernya
sudo modprobe snd_hda_intel
sudo modprobe snd_rn_pci_acp3x 2>/dev/null
echo "✅ Driver direload."

# 5. Nyalakan lagi audio service
systemctl --user start wireplumber pipewire pipewire-pulse
echo "🎉 Selesai! Cek Mic sekarang."
