#!/bin/bash

echo -e "\033[1;31mPERHATIAN!!\033[0m"
echo " "
echo -e "\033[1;33mKata sandi ini akan digunakan untuk memasuki server Anda
\033[0m"
echo -e "\033[1;32mKETIKPASSWORD BARU \033[1;32m
untuk melanjutkan...\033[1;31m\033[0m"
read  -p : pass
(echo $pass; echo $pass)|passwd 2>/dev/null
sleep 1s
echo -e "\033[1;31mGANTI PASSWORD SUKSES!\033[0m"
sleep 5s
cd
clear

