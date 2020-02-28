
function join1(array, sep) {
    result = ""
    for(i in array)
        if(result == "")
            result = array[i]
        else
            result = result sep array[i]
    return result
}

BEGIN {OFS = "\t" ; FS="\t"}

$0 ~ /^[0-9]/ && NF > 11 {
    for(i=12; i <= NF; i++) {
	aold = $i
	anew = gensub(/ARG([0-9M])/,"A\\1","g",aold)
	$i = anew
    }
    print
    next
}

{print}
