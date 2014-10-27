#!/bin/bash

# This generates the base HTML files.

set -o nounset

if [ $# -ne 1 ]; then
    echo "ERROR: You must specify the location of the Thrift compiler and schema files:"
    echo
    echo "  $0 path_to_thrift_compiler"
    exit
fi

THRIFT_EXEC="$1"
THRIFT_FILES="../thrift"

for f in $(find "${THRIFT_FILES}" -type f -name '*.thrift' ); do 
    "${THRIFT_EXEC}" --gen html -r $f; 
done
rm gen-html/index.html

for f in $(find gen-html -type f -name '*.html' ); do
    cp header_template.html schema/$(basename $f)
    tail -n +5 $f | python reorder_divs.py >> schema/$(basename $f)
done

# Create JavaScript file with array of Thrift types
CONCRETE_FILELIST="schema/concrete_filelist.js"
echo "var CONCRETE_FILELIST = [" > ${CONCRETE_FILELIST}
for f in $(find "${THRIFT_FILES}" -type f -name '*.thrift' | sort); do 
    filename=$(basename $f)
    filename_without_prefix="${filename%.*}"
    echo "'${filename_without_prefix}'," >> ${CONCRETE_FILELIST}
done
echo "];" >> ${CONCRETE_FILELIST}
