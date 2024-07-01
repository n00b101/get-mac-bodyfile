#!/bin/bash

# Step 0: Check if formatted_bodyfile.txt exists and remove it
if [ -f formatted_bodyfile.txt ]; then
  rm formatted_bodyfile.txt
fi

# Step 1: Generate the initial body file using find and stat
find . -type f -exec stat -f "%N %m %a %c %z" {} \; > bodyfile.txt

# Function to convert Unix timestamp to readable date format
convert_time() {
  date -r $1 "+%Y-%m-%d %H:%M:%S"
}

# Step 2: Read the initial body file line by line and process it
while IFS= read -r line; do
  # Extract fields from the line
  file=$(echo "$line" | awk '{print $1}')
  mtime=$(echo "$line" | awk '{print $2}')
  atime=$(echo "$line" | awk '{print $3}')
  ctime=$(echo "$line" | awk '{print $4}')
  size=$(echo "$line" | awk '{print $5}')
  
  # Convert times to readable format
  readable_mtime=$(convert_time $mtime)
  readable_atime=$(convert_time $atime)
  readable_ctime=$(convert_time $ctime)

  # Use placeholder values for fields not gathered
  inode=0
  mode=0
  uid=0
  gid=0

  # Print formatted line for body file
  echo "$file|$inode|$mode|$uid|$gid|$size|$readable_atime|$readable_mtime|$readable_ctime|" >> formatted_bodyfile.txt
done < bodyfile.txt

# Optional: Clean up the intermediate body file
rm bodyfile.txt
