#!/bin/bash

#------------------------------------------------------------

# Name:         Bradley Johnson
# NetID:        BWJ200000
# Class:        CS 3377.008 - Dr. Satpute
# Assignment:   Assignment 2 - A bash script that finds every occurrence of possible dates in a file.
#               The list of dates found and the match count are written to an output file and displayed to the console.

# Usage:    ./date_finder.sh <input_file> <output_file>
#
#               <input_file> is the text file that is to be searched for dates
#               <output_file> is the text file that the output report will be written to
#
# Example:  ./date_finder.sh input_dates.txt output_report.txt

#------------------------------------------------------------

# $1 contains input file
# $2 contains output file
input_file="$1"
output_file="$2"

# Check if all args are present
if [[ -z $input_file || -z $output_file ]]; then
    echo "Please provide path to both an input file and an output file."
    echo "Usage: ./date_finder.sh <input_file> <output_file>"
    echo "Example: ./date_finder.sh input_dates.txt output_report.txt"
    exit 1
fi

# Check if input file exists
if [[ ! -f $input_file ]]; then
    echo "Input file '$1' does not exist!"
    exit 1
fi

# possible months
declare -A months=(
    ['january']=1 
    ['february']=2 
    ['march']=3 
    ['april']=4 
    ['may']=5 
    ['june']=6 
    ['july']=7 
    ['august']=8 
    ['september']=9 
    ['october']=10 
    ['november']=11 
    ['december']=12
)

# possible abberviated months
declare -A months_abbr=(
    ['jan']=1 
    ['feb']=2 
    ['mar']=3 
    ['apr']=4 
    ['may']=5 
    ['jun']=6 
    ['jul']=7 
    ['aug']=8 
    ['sep']=9 
    ['oct']=10 
    ['nov']=11 
    ['dec']=12
)

# list of regex patterns to match dates
regex_list=(
    # e.g. 2019/05/16   19.5.16     19-4-3
    "([0-9]{2,4})[-/\.]([0-9]{1,2})[-/\.]([0-9]{1,2})"
    # e.g. 05/16/2019   5.16.19     3-4-2019
    "([0-9]{1,2})[-/\.]([0-9]{1,2})[-/\.]([0-9]{2,4})"
    # e.g. 16 May 2019      16th May, 19    16th of Jan. 2019
    "([0-9]?[1-9])(th|rd|st|nd|) (of |)([A-Za-z]{3,9})\.?,? ([0-9]{2,4})"
    # e.g. May 16, 2019     May 16th of 19    Jan. 16 2019   
    "([A-Za-z]{3,9})\.? ([0-9]?[1-9])(th|rd|st|nd|),? (of |)([0-9]{2,4})"
)

# $1=day
# $2=month
# $3=year
#
# returns false if the date is not valid
verify_date() {
    local day=$1
    local month=$2
    local year=$3

    local day_valid=0
    local month_valid=0
    local year_valid=1 # assume year is valid

    # remove leading zero from day
    day=$((10#$day))
    # check that 1 <= day <= 31
    [[ $day -ge 1 && $day -le 31 ]] && day_valid=1

    # check if month is string
    if [[ $2 =~ [A-Za-z]+ ]]; then
        # convert month to lower case
        local month_lower
        month_lower=$(echo "$month" | tr '[:upper:]' '[:lower:]')
        # check if month exists in months or abbreviated months array
        [[ ${months[$month_lower]} || ${months_abbr[$month_lower]} ]] && month_valid=1
    else
        # remove leading zero from month
        month=$((10#$month))
        # check that 1 <= month <= 12
        [[ $month -ge 1 && $month -le 12 ]] && month_valid=1
    fi

    [[ $day_valid -eq 1 && $month_valid -eq 1 && $year_valid -eq 1 ]] && return
    # date is not valid, return false
    false
}

# $1=regex
# $2=day match group index
# $3=month match group index
# $4=year match group index
#
# tests the current line against the specified regex
# if matched, then increments match count and appends date to output file 
# returns false if date was not matched
test_date() {
    local regex="$1"

    # check the current line against the regex
    if [[ $line =~ $regex ]]; then
        local match=${BASH_REMATCH[0]}  # contains entire matched string
        local day=${BASH_REMATCH[$2]}   # contains the captured day
        local month=${BASH_REMATCH[$3]} # contains the captued month
        local year=${BASH_REMATCH[$4]}  # contains the captured year
        # check that the date is valid
        if verify_date "$day" "$month" "$year"; then
            ((total_matches++))
            # append match to output file
            echo "$match" >> "$output_file"
            return
        fi
    fi
    # date was not matched, return false
    false
}

# keeps track of total number of valid dates found
total_matches=0

# clear output file before writing to it
eval > "$output_file"

# loop through each line in the inputted file
while read line
do
    # test line with each regex, continue to next line in input file if matched
    if test_date "${regex_list[0]}" 3 2 1; then 
        continue 
    elif test_date "${regex_list[1]}" 1 2 3; then  
        continue 
    elif test_date "${regex_list[1]}" 2 1 3; then # same regex as before but with day and month swapped
        continue
    elif test_date "${regex_list[2]}" 1 4 5; then 
        continue
    else
        test_date "${regex_list[3]}" 2 1 5
    fi
done < "$input_file"

# append total match count to output file
echo "-----------------------------" >> "$output_file"   # line separator
echo "Total valid dates found: $total_matches" >> "$output_file"

# display contents of output file 
cat "$output_file"

exit 0
