#!/bin/sh

#==============================================================================
# Script Name    : change_hostname.sh
# Description    : This script prompts the user for a new hostname and updates
#                  the system configuration files accordingly.
# Author         : Alan MARCHAND
# Compatibility  : POSIX compliant
#==============================================================================

###############################################################################
# Function to prompt the user for a new hostname                              #
###############################################################################
prompt_new_hostname() {
  echo -n "Enter the new hostname: "
  read new_hostname
  echo "You have chosen the new hostname: $new_hostname"
}

###############################################################################
# Function to replace the hostname in a file                                  #
###############################################################################
replace_hostname_in_file() {
  file="$1"
  # Replace the old hostname with the new one, escaping special characters
  sed -i "s/$(echo "$current_hostname" | sed 's/[.[\^$*]/\\&/g')/$new_hostname/g" "$file"
}

###############################################################################
# Script Execution                                                            #
###############################################################################

# Must be root to execute the script
if [ "$(id -u)" -ne 0 ]; then
  echo "You must be a root user" >&2
  exit 1
fi

# Current hostname
current_hostname=$(hostname)

# Prompt the user for a new hostname
prompt_new_hostname

# if the new hostname is the same as current one, there is nothing to do
if [ "$new_hostname" = "$current_hostname" ]; then
  echo "New hostname is same as the current one. There is nothing to do !"
  exit 1
fi

# List of files to modify (add other files if necessary)
files_to_modify="/etc/hostname /etc/hosts"

# Replace the hostname in each file
for file in $files_to_modify; do
  replace_hostname_in_file "$file"
done

# Apply the new hostname persistently
hostname "$new_hostname"

# Display a confirmation message
echo "The hostname has been changed to: $new_hostname"
