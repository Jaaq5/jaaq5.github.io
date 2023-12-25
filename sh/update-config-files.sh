#!/bin/bash

# Get the directory where the script is located
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to move a configuration file or dir to a specified folder with a custom name
move_config_file() {
    local config_file="$1"
    local destination_folder="$2"
    local destination_name="$3"

    local source_path="$script_dir/$config_file"
    local destination_path="$destination_folder/$destination_name"

    if [ -e "$source_path" ]; then
        if [ -d "$source_path" ]; then
            # If it's a directory, use -r (recursive) option
            cp -r "$source_path" "$destination_path"
        else
            # If it's a file, simply copy it
            cp "$source_path" "$destination_path"
        fi

        if [ $? -eq 0 ]; then
            echo "$config_file has been copy to $destination_folder with the name $destination_name"
        else
            echo "Error: Failed to copy $config_file to $destination_folder with the name $destination_name"
        fi
    else
        echo "$config_file does not exist in the script directory"
    fi
}

# Move .icons 
move_config_file "1-dot_icons" "/home/alex" ".icons"

# Move fish 
move_config_file "1-fish" "/home/alex/.config" "fish"

# Move kitty 
move_config_file "1-kitty" "/home/alex/.config" "kitty"

# Move MangoHud 
move_config_file "1-MangoHud" "/home/alex/.config" "MangoHud"

# Move .bash_history
move_config_file "2-dot_bash_history" "/home/alex" ".bash_history"

# Move .bashrc
move_config_file "2-dot_bashrc" "/home/alex" ".bashrc"

# Move .gitconfig 
move_config_file "2-dot_gitconfig" "/home/alex" ".gitconfig"

# Move .gitmessage 
move_config_file "2-dot_gitmessage" "/home/alex" ".gitmessage"

# Move .vimrc 
move_config_file "2-dot_vimrc" "/home/alex" ".vimrc"

# Move fish_history 
move_config_file "2-fish_history" "/home/alex/.local/share/fish" "fish_history"

# Move gpg-agent.config
move_config_file "2-gpg-agent.config" "/home/alex/.gnupg" "gpg-agent.config"

# Move pacman.config
move_config_file "2-pacman.config" "/etc" "pacman.config"

# Reload the gpg agent
gpg-connect-agent reloadagent /bye

# Create symlink to the kitty theme
cd /home/alex/.config/kitty
ln -s ./kitty-themes/themes/Monokai_Classic.conf /home/alex/.config/kitty/theme.conf
