#!/bin/bash

# --- KONFIGURASI ---
BATTERY_PATH="/sys/class/power_supply/BAT1" # Cek dulu, bisa BAT0 atau BAT1
LOW_LEVEL=15      # Level untuk Peringatan (Notifikasi)
CRITICAL_LEVEL=10 # Level untuk KUNCI PAKSA (Lock)
CHECK_INTERVAL=5  # Cek setiap 5 detik

# Variabel bantu biar notifikasi gak spam
notified_low=false

while true; do
    # 1. Ambil data baterai
    # Kalau folder BAT0 gak ada, coba ganti jadi BAT1 atau cari pake 'ls /sys/class/power_supply/'
    if [ -d "$BATTERY_PATH" ]; then
        CAPACITY=$(cat "$BATTERY_PATH/capacity")
        STATUS=$(cat "$BATTERY_PATH/status")
    else
        echo "Baterai tidak ditemukan di $BATTERY_PATH"
        exit 1
    fi

    # 2. Logika Satpam

    # KONDISI A: Sedang Di-Charge (Aman)
    if [ "$STATUS" == "Charging" ] || [ "$STATUS" == "Full" ]; then
        # Reset notifikasi biar nanti kalau dicabut bisa warning lagi
        notified_low=false

    # KONDISI B: Baterai Kritis (< 10%) DAN Tidak Di-Charge
    elif [ "$CAPACITY" -le "$CRITICAL_LEVEL" ]; then
        # Cek apakah Hyprlock sudah jalan? Kalau belum, jalankan!
        # Ini bikin loop: Kalau kamu unlock tapi belum colok, dia lock lagi sedetik kemudian.
        if ! pidof hyprlock > /dev/null; then
            notify-send -u critical "KRITIS! BATERAI $CAPACITY%" "Laptop dikunci sampai dicolok charger!"
            hyprlock
        fi

    # KONDISI C: Baterai Rendah (< 15%) - Kasih Peringatan Dulu
    elif [ "$CAPACITY" -le "$LOW_LEVEL" ]; then
        if [ "$notified_low" = false ]; then
            notify-send -u critical "Baterai Lemah ($CAPACITY%)" "Segera colok charger atau laptop akan terkunci otomatis!"
            notified_low=true
        fi
    fi

    # Tidur sebentar sebelum cek lagi
    sleep $CHECK_INTERVAL
done
