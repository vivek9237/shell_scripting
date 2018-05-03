#Command to execute the script :
#./script_name<space>num_of_days/weeks/months<space>days/weeks/months
# Example:
#
# ./genIgnoreFiles.sh feature/3_31_enhancements 2 weeks
#
_inputFile=test.lst
_finalFile=filesToInclude.lst
_finalGITignore=dev.ignorefiles2.lst
rm all.lst >/dev/null 2>/dev/null
rm dev.ignorefiles2.lst >/dev/null 2>/dev/null
rm filesToInclude.lst >/dev/null 2>/dev/null
rm filesToInclude2.lst >/dev/null 2>/dev/null
rm test.lst >/dev/null 2>/dev/null
rm temp1.txt >/dev/null 2>/dev/null
rm tempFile.lst >/dev/null 2>/dev/null
rm $_finalFile >/dev/null 2>/dev/null

cd iiq
git checkout $1 >/dev/null 2>/dev/null
echo "Getting all commits and files for last $2 $3"
echo ""
git log --pretty=format:"%h" --since=$2.$3 --name-only|grep config\/|cut -d "/" -f 2,3,4,5,6,7,8,9,10,11,12,13,14,15 >../test.lst
cd ..

echo "# A file that contains which XML files should be removed/redacted from the " >>tempFile.lst
echo "# automated imports for a specific environment\.  For example:" >>tempFile.lst
echo "#  dev\.ignorefiles\.properties - lists files not imported into Dev " >>tempFile.lst
echo "#  int\.ignorefiles\.properties     - lists files not imported intoa INT (TCOE)" >>tempFile.lst
echo "#  stage\.ignorefiles\.properties    - lists files not imported into SIT (Stage 1 and 2)" >>tempFile.lst
echo "#  iadd1\.ignorefiles\.properties    - lists files not imported into PRODuction (DC4)" >>tempFile.lst
echo "#  sjcd1\.ignorefiles\.properties    - lists files not imported into PRODuction (SC9)" >>tempFile.lst
echo "#" >>tempFile.lst
echo "# The file format:" >>tempFile.lst
echo "#  The # signs are comments, like unix shell script fashion\." >>tempFile.lst
echo "#  Files to ignore should be named in path relative to the \.\.\./config/ " >>tempFile.lst
echo "#  directory of the services standard build\.  One file name should be" >>tempFile.lst
echo "#  specified per line of this file\.  Unix slashes (/) should be used" >>tempFile.lst
echo "#  as separators on both Windows and unix environments\. BUT NOTE:" >>tempFile.lst
echo "# The file names are from when the files are staged in to the " >>tempFile.lst
echo "# \.\.\./build/extract/WEB-INF/config/custom/\.\.\. directories so all of the " >>tempFile.lst
echo "# file names start with a \"custom/\" prefix and not a \"config/\" prefix\." >>tempFile.lst
echo "#" >>tempFile.lst
echo "# Examples:" >>tempFile.lst
echo "#  custom/Application/Application-AD-Partner\.xml" >>tempFile.lst
echo "#  custom/Workflow/Workflow-QuickTermination\.xml" >>tempFile.lst
echo "#" >>tempFile.lst
echo "# All non-filename lines in this file should start with a # (comment sign)\." >>tempFile.lst
echo "#" >>tempFile.lst
echo "# custom/Application/Application-Your-App-Here\.xml" >>tempFile.lst
echo "# custom/Workflow/Workflow-Insert-Your-Workflow-Filename\.xml" >>tempFile.lst
echo "################################################################" >>tempFile.lst
echo "#" >>tempFile.lst
echo "getting list of all files from git(from local).."
echo ""
cd iiq
cd config
find . -name "*.*"|cut -d "/" -f 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18 > ../../all.lst
cd ..
cd ..
while read _line
do
    echo custom/$_line >> $_finalGITignore
done<"all.lst"
sed -e 's/^/custom\//' $_inputFile >>$_finalFile
echo "finding list of unique files from git commits.."
echo ""
awk '!a[$0]++' filesToInclude.lst > filesToInclude2.lst
sort filesToInclude2.lst $_finalGITignore | uniq -d >>temp1.txt
echo "pre-pending # on git commit file list.."
echo ""
sed -e 's/^/#/' temp1.txt >>tempFile.lst
echo "Preparing the gitIgnore file.."
echo ""
grep -v -F -x -f temp1.txt $_finalGITignore >> tempFile.lst
sed '/custom\/\./d' ./tempFile.lst > ./dev.ignorefiles.properties
echo "gitIgnore file prepared."
echo ""
rm all.lst >/dev/null 2>/dev/null
rm dev.ignorefiles2.lst >/dev/null 2>/dev/null
rm filesToInclude.lst >/dev/null 2>/dev/null
rm filesToInclude2.lst >/dev/null 2>/dev/null
rm test.lst >/dev/null 2>/dev/null
rm temp1.txt >/dev/null 2>/dev/null
rm tempFile.lst >/dev/null 2>/dev/null