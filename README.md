# Date Finder 
> Originally completed as an assignment for the class CS3377 - Systems Programming in UNIX

***Date Finder*** is a bash script that finds every occurence of possible dates in a text file. The list of dates found and the match count are written to an output file and displayed to the console. The dates are checked for validity, including valid month and day numbers, as well as valid month names or abbreviations.

## How to Run

If you have not done so already, give execution privileges to the script:
```bash
$ chmod +x ./date_finder.sh
```

Execute the script with the input file and output file parameters:
```bash
$ ./date_finder.sh <input_file> <output_file>
```
- `<input_file>` is the text file that is to be searched for dates.
- `<output_file>` is the text file that the output report will be written to.


## Example Run

The input file `input_dates.txt` is a text document containing multiple different variations of ways to write dates:
```txt
The due date for this assignment is 23 October 2022!!!
10-19-2022
12th May, 1980
May 12, 1980
May 12th, 1980
12 May 1980
hello world
12 May, 1980
12th of May 1980
dont match me
2nd Feb. 1980
01st January 02
1980/05/12
1980.05.12
53/65/2002
12/33/1998
hello 2 Mar. 1965 goodbye

```
> Note: Do not forget to end the file with a new line! Otherwise, the last line in the document will not be parsed.

Run the script with the created input file:
```bash
$ ./date_finder.sh input_dates.txt output_report.txt
23 October 2022
10-19-2022
12th May, 1980
May 12, 1980
May 12th, 1980
12 May 1980
12 May, 1980
12th of May 1980
2nd Feb. 1980
01st January 02
1980/05/12
1980.05.12
2 Mar. 1965
-----------------------------
Total valid dates found: 13
```
The output is also stored in the output file. In this case, `output_report.txt`

## Report

<!-- `short description of your experiential learning while working on this project. The second part should be about 5-10 sentences (less than 150 words) talking about what you learned and the process you used to find the patterns and extract the patterns.` -->

In this assignment, I learned about the bash scripting language, including its control structures and regular expressions. In order to come up with the regular expressions to use for the dates, I began writing in a text file all of the possible ways to list a date that I could think of. After I had a long list, I analyzed the dates to see which ones had certain attributes in common, and began to build multiple different regular expressions that matched the dates. In this process, I learned that bash unfortunately does not support non-capturing groups, so instead I created a work-around by allowing capture groups to also capture the empty string, and then I ignored the index of that specific capture group when parsing the date. In addition to regular expressions, I also learned how to read a file line-by-line, how to remove leading zeros from number and convert it to an integer, and how to convert a string to lower case.
