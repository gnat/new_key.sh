#!/bin/bash
# Generates new key pair.
#     * RSA 4096 bit standard.
#     * Can be upgraded to ed25519 when dropbear supports it.
# Examples:
#     new_key.sh domain.com
#     echo "domain.com" | new_key.sh
#     new_key.sh
#         Interactive mode.

set -e

# Change to script directory in case we're running through a desktop GUI.
cd "$(dirname "$0")"

if [ "$1" ]; then
    # Non-Interactive mode.
    CHOICE=$1
else
    # Interactive mode.
    echo "This will generate new SSH keys. Enter the domain or service name. Example: yourwebsite.com"
    read -r CHOICE
fi

CHOICE=${CHOICE,,*( )} # Lowercase and trim.
if [[ ("$CHOICE" == "" || ${#CHOICE} -le 5 ) ]]; then
    echo "'${CHOICE}' is too short or invalid."
    exit 1
fi
    
# Auto overwrite is "<<< y"
ssh-keygen -t rsa -b 4096 -C "" -f ${CHOICE} -N "" <<< y

echo "Done. Use with \$ssh -i ./${CHOICE} user@${CHOICE}"
