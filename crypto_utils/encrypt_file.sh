#!/bin/bash
#
# encrypt.sh - Encryption script using OpenSSL
#
# Description:
#   This script encrypts a file using the AES-256-CBC algorithm with
#   base64 encoding. It applies a salt and 5 iterations to enhance
#   security. The user can provide a passphrase directly via the command line.
#
# Usage:
#   ./encrypt.sh -f <file_to_encrypt> -o <encrypted_file> [-pass <passphrase>] [-h]
#
# Options:
#   -f      Name of the file to encrypt (required)
#   -o      Name of the output encrypted file (required)
#   -pass   Passphrase for encryption (optional)
#   -h      Display this help message
#
# Examples:
#   ./encrypt.sh -f data.tar.gz -o data.enc -pass "taveren"
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
#   The command used for encryption is:
#   openssl aes-256-cbc -a -salt -iter 5 -in <input_file> -out <output_file> -pass pass:<passphrase>
#
#   - `openssl`: This is a command-line tool for using the OpenSSL library,
#     which provides various cryptographic operations.
#
#   - `aes-256-cbc`: This specifies the encryption algorithm to use. 
#     AES (Advanced Encryption Standard) is a symmetric encryption algorithm, 
#     and "256" indicates the key size in bits. "cbc" refers to the mode of 
#     operation, which stands for Cipher Block Chaining. This mode provides 
#     strong encryption by combining blocks of plaintext with previous ciphertext.
#
#   - `-a`: This option specifies that the output should be encoded in 
#     base64. Base64 encoding is used to represent binary data in an ASCII 
#     string format, making it easier to store and transmit over text-based 
#     protocols.
#
#   - `-salt`: This option adds a random salt to the encryption process. 
#     A salt is a random value that is added to the input of the encryption 
#     algorithm to ensure that the same plaintext encrypts to different 
#     ciphertexts each time. This helps protect against certain types of 
#     attacks, such as dictionary attacks.
#
#   - `-iter 5`: This option specifies the number of iterations for the 
#     key derivation function. Iterating the key derivation function makes 
#     it more difficult for an attacker to crack the password used for 
#     encryption by increasing the time it takes to test each possible 
#     password.
#
#   - `-in <input_file>`: This specifies the input file that you want to 
#     encrypt.
#
#   - `-out <output_file>`: This specifies the output file where the 
#     encrypted data will be saved.
#
#   - `-p <passphrase>`: This option allows the user to specify a 
#     passphrase directly for encryption.
#
# Note: The following command displays the cryptographic fingerprint
#       (or hashes) of files or data.
#   - `openssl dgst -sha256 "$ENCRYPTED_FILE"`
#

# Check if openssl is installed
if ! command -v openssl &> /dev/null; then
    echo "Error: openssl is not installed on this system."
    exit 1
fi

# Function to display help
display_help() {
    echo "Usage: $0 [-f file_to_encrypt] [-o output_file] [-pass passphrase] [-h]"
    echo
    echo "Options:"
    echo "  -f      Name of the file to encrypt (required)"
    echo "  -o      Name of the output encrypted file (required)"
    echo "  -p      Passphrase for encryption (optional)"
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
    echo "Error: You must specify a file to encrypt (-f) and an output file (-o)."
    display_help
fi

# Check if the file to encrypt exists
if [ ! -f "$input_file" ]; then
    echo "Error: The file '$input_file' does not exist."
    exit 1
fi

# Apply the encryption
if [ -z "$passphrase" ]; then
    openssl aes-256-cbc -a -salt -iter 5 -in "$input_file" -out "$output_file"
else
    openssl aes-256-cbc -a -salt -iter 5 -in "$input_file" -out "$output_file" -pass pass:"$passphrase"
fi

# Check if the openssl command succeeded
if [ $? -eq 0 ]; then
    echo "The file '$input_file' has been successfully encrypted to '$output_file'."
else
    echo "Error during encryption."
    exit 1
fi
