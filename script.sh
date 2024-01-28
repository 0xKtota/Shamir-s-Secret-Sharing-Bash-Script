#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Ensure ssss is installed:
# sudo apt-get install ssss

function check_for_non_ascii {
    if LC_ALL=C grep -q '[^ -~]' <<<"$1"; then
        echo -e "${RED}ERROR: Non-ASCII characters (such as Umlauts) are not supported. Please remove them and try again.${NC}"
        exit 1
    fi
}

function split_key {
    echo -e "\nEnter the private key (input will be hidden):"
    read -s private_key
    check_for_non_ascii "$private_key"
    echo -e "\nWould you like to verify the key? Type 'full' to display the full key, 'part' to display the first and last part, or anything else to skip:"
    read verify_option
    
    if [[ "$verify_option" == "full" ]]; then
        echo -e "Full key: $private_key"
    elif [[ "$verify_option" == "part" ]]; then
        echo -e "Key preview: $(echo $private_key | cut -c1-5).....$(echo $private_key | rev | cut -c1-5 | rev)"
    fi
    
    echo -e "\nEnter the number of parts to split the key into:"
    read n
    echo -e "\nEnter the number of parts required to reassemble the key:"
    read t
    echo -e "\nEnter the security level (e.g., 128, 256, 512; or leave blank for automatic):"
    read s
    
    if [[ -z "$s" ]]; then
        echo "$private_key" | ssss-split -t $t -n $n -Q > key_parts.txt
    else
        echo "$private_key" | ssss-split -t $t -n $n -s $s -Q > key_parts.txt
    fi
    
    echo -e "${GREEN}Key parts have been saved in the file key_parts.txt${NC}\n"
    
    # Overwrite and delete the private key variable immediately after use
    private_key=""
}

function combine_key {
    echo -e "\nEnter the number of parts required to reassemble the key:"
    read t

    # Checking the number of key parts
    key_parts_count=$(grep -c '^' key_parts.txt)
    if [ "$key_parts_count" -lt "$t" ]; then
        echo -e "${RED}Error: Not enough key parts in key_parts.txt to reassemble the key${NC}\n"
        exit 1
    elif [ "$key_parts_count" -gt "$t" ]; then
        echo -e "${RED}Error: Too many key parts in key_parts.txt. Only $t parts are needed${NC}\n"
        exit 1
    fi

    echo -e "\nCopy the key parts into the file key_parts.txt in the current directory and press [ENTER]"
    read
    echo "Reassembled Key:"
    ssss-combine -t $t -Q < key_parts.txt

    echo -e "\nIs the above key correct? (y/n)"
    read is_key_correct
    if [[ "$is_key_correct" == "y" || "$is_key_correct" == "Y" ]]; then
        echo -e "${GREEN}Confirmed: The key is correct!${NC}"

        # Ask the user if they want to delete the key parts file
        echo -e "\nDo you want to securely delete the key parts file? (y/n)"
        read delete_confirmation
        if [[ "$delete_confirmation" == "y" || "$delete_confirmation" == "Y" ]]; then
            shred -u key_parts.txt
            echo -e "${GREEN}The key parts file has been securely deleted${NC}\n"
        else
            echo -e "${RED}The key parts file has not been deleted${NC}\n"
        fi
    else
        echo -e "${RED}Key verification failed. Please retry the process${NC}\n"
    fi
# fi
}

echo -e "\nSelect an option:"
echo "1. Split key"
echo "2. Combine key"
read option

echo
case $option in
    1)
        split_key
        ;;
    2)
        combine_key
        ;;
    *)
        echo -e "${RED}Invalid option.${NC}"
        ;;
esac
