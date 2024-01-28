# Shamir's Secret Sharing Bash Script

This repository contains a Bash script for splitting and recombining a private key using Shamir's Secret Sharing scheme. This can be useful for securely storing and sharing sensitive information such as private keys.

## Dependencies

- ssss: Install using your package manager, e.g., `sudo apt-get install ssss`.

## Usage

1. Clone this repository to your local machine.
2. Navigate to the repository directory in your terminal.
3. Run the script using the command `bash script.sh`.
4. Follow the prompts to either split or combine a private key.

### Splitting a key

- Enter the private key (input will be hidden for security).
- Choose whether to verify the key. Type 'full' to display the full key, 'part' to display the first and last part, or anything else to skip.
- Enter the number of parts to split the key into.
- Enter the number of parts required to reassemble the key.
- Enter the security level (e.g., 128, 256, 512; or leave blank for automatic).
- The key parts will be saved in files named `key_parts-1` to `key_parts-n`.

### Combining a key

- Enter the number of parts required to reassemble the key.
- Place the key parts files in the current directory.
- Press Enter to combine the key parts and reassemble the private key.
- The reassembled private key will be saved in the file `key_parts_recovered`.

## Security Notes

- This script is a basic implementation and may not be suitable for production use without further security enhancements.
- Ensure to securely delete the key parts files and the reassembled private key file after use.
- It's recommended to run this script in a secure environment to prevent potential eavesdropping or other security threats.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
