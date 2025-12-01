#!/bin/bash

# ID Hardware Audio kamu (Dapet dari pactl list tadi)
# Formatnya: 0000:05:00.6 (titik dua, bukan underscore)
PCID="0000:05:00.6"

echo "🔌 Mencabut Audio Device secara Virtual..."

# 1. Hapus device dari sistem (Seolah dicabut)
# Pakai 'tee' karena butuh akses root ke file sistem
echo 1 | sudo tee /sys/bus/pci/devices/$PCID/remove > /dev/null

sleep 2

echo "🔋 Mencolok Audio Device kembali..."

# 2. Suruh sistem scan ulang (Seolah dicolok)
echo 1 | sudo tee /sys/bus/pci/rescan > /dev/null

echo "✅ Selesai. Tunggu sebentar sampai Pipewire nangkep lagi."

# Opsional: Paksa set profile lagi biar yakin
sleep 2
# Ganti nama card di bawah ini pake underscore '_' sesuai pactl list
pactl set-card-profile alsa_card.pci-0000_05_00.6 output:analog-stereo+input:analog-stereo
