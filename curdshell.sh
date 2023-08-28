#!/bin/bash

# Crud Sederhana menggunakan BASH SHELL/UNIX

data_file="barang.json"
if [[ -f $data_file ]]; then
clear
while true; do
    echo "Menu:"
    echo "1. Tambah Barang"
    echo "2. Tampilkan Barang"
    echo "3. Ubah Harga atau Nama Barang"
    echo "4. Hapus Barang"
    echo "5. Jumlah seluruh harga"
    echo "6. Keluar"
    read -p "Pilih menu: " choice;

    case $choice in
        1)
            clear
	    jq '.' $data_file
            echo -n "Masukkan Nama Barang : ";read nama_barang;
            echo -n "Masukkan Harga Barang : ";read harga_barang;
            id=$(jq '.[-1].id + 1' $data_file)
            new_entry="{\"id\": $id, \"nama\": \"$nama_barang\", \"harga\": $harga_barang}"
            jq ". += [$new_entry]" $data_file > tmpfile && mv tmpfile $data_file
	    clear
            echo "Barang ditambahkan dengan ID $id"
            sleep 1
            jq '.' $data_file
            ;;
        2)
            clear
            jq '.' $data_file
            ;;
        3)
            clear
            jq '.' $data_file
            echo -n "Masukkan ID Barang yang ingin diubah : ";read target_id;
            echo "Pilih yang ingin diubah:"
            echo "1. Nama Barang"
            echo "2. Harga Barang"
            echo -n "Pilih : ";read ubah_choice;

            case $ubah_choice in
                1)
                    clear
		    jq '.' $data_file
                    echo -n "Masukkan Nama Barang Baru : ";read new_nama;
                    jq ".[$target_id-1].nama = \"$new_nama\"" $data_file > tmpfile && mv tmpfile $data_file
		    jq '.' $data_file
                    ;;
                2)
		    clear
	            jq '.' $data_file
                    echo -n "Masukkan Harga Barang Baru : ";read new_harga;
                    jq ".[$target_id-1].harga = $new_harga" $data_file > tmpfile && mv tmpfile $data_file
 		    jq '.' $data_file
                    ;;
            esac
            ;;
        4)
            clear
            jq '.' $data_file
            echo -n "Masukkan ID Barang yang ingin dihapus : ";read del_id;
            jq "del(.[$del_id-1])" $data_file > tmpfile && mv tmpfile $data_file
            clear
 	    jq '.' $data_file
            ;;
        5)
            clear
            total=0
            for row in $(jq -r '.[] | @base64' $data_file); do
           _jq() {
             echo ${row} | base64 --decode | jq -r ${1}
            }
            harga=$(_jq '.harga')
            total=$((total + harga))
            done
            jq '.' $data_file
            echo "Total Harga Semua Barang: $total"
            ;;
        6)
	    echo "Terimakasih"
            exit
	    ;;
        *)
            echo "Pilihan tidak valid."
            ;;
    esac
done
else
echo "[]" > barang.json
fi
