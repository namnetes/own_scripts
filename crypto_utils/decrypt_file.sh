#!/bin/bash
#
# decrypt.sh - Decryption script using OpenSSL
#
# Description:
#   This script decrypts a file that was encrypted using the AES-256-CBC 
#   algorithm with base64 encoding. It applies the same salt and iterations 
#   used during encryption to successfully restore the original file. The user 
#   can provide a passphrase directly via the command line.
#
# Usage:
#   ./decrypt.sh -f <file_to_decrypt> -o <decrypted_file> [-pass <passphrase>] [-h]
#
# Options:
#   -f      Name of the encrypted file to decrypt (required)
#   -o      Name of the output decrypted file (required)
#   -pass   Passphrase for decryption (optional)
#   -h      Display this help message
#
# Examples:
#   ./decrypt.sh -f data.enc -o data.tar.gz -pass "taveren"
#
# Author: Alan MARCHAND
# Version: 1.1
# License: MIT
# Date: 2024-09-22
#
# Changelog:
#   - 1.1 : Added -pass option to allow specifying a passphrase directly
#
# Technical Notes:
#   The command used for decryption is:
#   openssl aes-256-cbc -d -a -salt -iter 5 -in <input_file> -out <output_file> -pass pass:<passphrase>
#
#   - `openssl`: This is a command-line tool for using the OpenSSL library,
#     which provides various cryptographic operations.
#
#   - `aes-256-cbc`: This specifies the decryption algorithm to use. 
#     AES (Advanced Encryption Standard) is a symmetric encryption algorithm, 
#     and "256" indicates the key size in bits. "cbc" refers to the mode of 
#     operation, which stands for Cipher Block Chaining.
#
#   - `-d`: This option specifies that the operation is decryption.
#
#   - `-a`: This option specifies that the input is encoded in 
#     base64.
#
#   - `-salt`: This option indicates that the encrypted file was 
#     created with a salt, which adds randomness to the encryption process.
#
#   - `-iter 5`: This option specifies the number of iterations used 
#     for key derivation, matching the value used during encryption.
#
#   - `-in <input_file>`: This specifies the encrypted file that you want 
#     to decrypt.
#
#   - `-out <output_file>`: This specifies the output file where the 
#     decrypted data will be saved.
#
#   - `-p <passphrase>`: This option allows the user to specify a 
#     passphrase directly for decryption.
#

# Check if openssl is installed
if ! command -v openssl &> /dev/null; then
    echo "Error: openssl is not installed on this system."
    exit 1
fi

# Function to display help
display_help() {
    echo "Usage: $0 [-f file_to_decrypt] [-o output_file] [-pass passphrase] [-h]"
    echo
    echo "Options:"
    echo "  -f      Name of the encrypted file to decrypt (required)"
    echo "  -o      Name of the output decrypted file (required)"
    echo "  -p      Passphrase for decryption (optional)"
    echo "  -h      Display this help message"
    echo
    exit 0
}

# Initialize variables for the files and passphrase
input_file=""
output_file=""
passphrase=""

# Handle options
while getopts ":f:o:p:h" option; do
    case $option in
        f) input_file="$OPTARG" ;;
        o) output_file="$OPTARG" ;;
        p) passphrase="$OPTARG" ;;
        h) display_help ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done

# Check if the files have been specified
if [ -z "$input_file" ] || [ -z "$output_file" ]; then
    echo "Error: You must specify an encrypted file to decrypt (-f) and an output file (-o)."
    display_help
fi

# Check if the file to decrypt exists
if [ ! -f "$input_file" ]; then
    echo "Error: The file '$input_file' does not exist."
    exit 1
fi

# Apply the decryption
if [ -z "$passphrase" ]; then
    openssl aes-256-cbc -d -a -salt -iter 5 -in "$input_file" -out "$output_file"
else
    openssl aes-256-cbc -d -a -salt -iter 5 -in "$input_file" -out "$output_file" -pass pass:"$passphrase"
fi

# Check if the openssl command succeeded
if [ $? -eq 0 ]; then
    echo "The file '$input_file' has been successfully decrypted to '$output_file'."
else
    echo "Error during decryption."
    exit 1
fi
