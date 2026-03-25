#!/bin/bash


function get_args() {
#       echo "args num = $#"
    if [[ $# -lt "2" ]]
    then
        return 1;
    fi

    #if [[ ! -f "$1" ]]
    #then
    #        echo "$1 not a file"
    #        return 1;
    #else
            WRITE_FILE="$1"
    #fi

    if [[ -z "$2" ]]
    then
            echo "String not provided or empty."
            return 1;
    else
            WRITE_STR="$2"
    fi

    return 0;
}

# This function creates a file.
function create_file() {
	DIR=$(dirname ${WRITE_FILE})
	FILENAME=$(basename ${WRITE_FILE})

   if [[ ! -d ${DIR} ]]
   then
	   mkdir -p ${DIR}
   fi

   $(touch ${WRITE_FILE})
   if [[ $? == 0 ]]
   then
	   return 0;
   else
	   echo "Could not create file: ${WRITE_FILE}"
	   return 1;
   fi	   
}

# This function writes to the file, if the file exists.
function write_to_file() {
    if [[ -f ${WRITE_FILE} ]]
    then
	    echo "${WRITE_STR}" > "${WRITE_FILE}"
	    return 0
    else
	    echo "The file ${WRITE_FILE} could not be found"
	    return 1
    fi

}

### main starts here ###
get_args $@
ret=$?
if [[ $ret == 1 ]]
then
        echo "Error while parsing args. Exit with error $ret".
        exit $ret;
fi

# Create a file
create_file
ret=$?
if [[ $ret != 0 ]]
then
        echo "Error while creating file. Exit with error $ret".
        exit $ret;
fi

write_to_file
ret=$?
if [[ $ret != 0 ]]
then
        echo "Error while writing to file. Exit with error $ret".
        exit $ret;
fi

exit 0
