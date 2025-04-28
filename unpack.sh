#!/bin/bash 

# varibels
is_output=false
is_rec=false
count_sucsses=0
count_fail=0

##########################################################
function extract_file {
    # Check if the file exists
    if [ ! -e "$1" ]; then
        [ "$is_output" = true ] && echo "Ignoring $1"
		((count_fail++))
		#echo "count_fail: $count_fail"
        return 1
    fi
    
    # Identify the file type
    local file_type=$(file --brief "$1" | awk '{print $1}')
    
    # Extract based on the file type
	# overide if exists target file
    case $file_type in 
        Zip)
            unzip -o "$1" > /dev/null 2>&1
            ;;
        gzip)
            gunzip -kf "$1" > /dev/null 2>&1
            ;;
        bzip2)
            bunzip2 -kf "$1" > /dev/null 2>&1
            ;;
        *compress\'d*)
            uncompress -fk "$1" > /dev/null 2>&1
            ;;
        *)
            [ "$is_output" = true ] && echo "Ignoring $1"
			((count_fail++))
			#echo "count_fail: $count_fail"
            return 1
            ;;
    esac
    
    # Check if the extraction succeeded
    if [[ $? -eq 0 ]]; then
        ((count_sucsses++))
		#echo "count_sucsses: $count_sucsses"
        [ "$is_output" = true ] && echo "Unpacking $1"
        return 0
    else
        [ "$is_output" = true ] && echo "Ignoring $1"
		((count_fail++))
		#echo "count_fail: $count_fail"
        return 1
    fi
}
###########################################################



# check the switches
while getopts ":vr" opt; do
    case $opt in
        v)
            is_output=true
            ;;
        r)
            is_rec=true
            ;;
        ?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

#echo "is_rec: $is_rec"
#echo "is_output: $is_output"

# Remove the switches
shift $((OPTIND - 1)) 

############################################################

# get the arguments
files=("$@")

# check if there no arguments accept
if [ "${#files[@]}" -eq 0 ]; then
    echo "no entering files/folder to extract!"
	exit 1
fi


# Process each file or directory
for file in "${files[@]}"; do

    # If it's a directory
	if [ -d "$file" ]; then
	
		# Set the find command based on recursion flag
		find_cmd=$([ "$is_rec" = true ] && echo "find $file -type f" || echo "find $file -maxdepth 1 -type f")
    
		# Extract files found by the command
		while IFS= read -r inner_file; do
			extract_file "$inner_file"
		done < <($find_cmd)
		continue
	fi


    # If it's a file
    extract_file "$file"
done

# output
echo "Decompressed $count_sucsses archive(s)"
echo "Command returned $count_fail (failure for $((count_fail + count_sucsses)) file)"
 
if [ "$count_fail" -gt 0 ]; then
    exit 1  # exit can return num till 255
else
    exit 0
fi