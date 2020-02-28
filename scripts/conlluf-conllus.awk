
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

$0 ~ /^[0-9]/ {
    if(NF == 10)
	print $1,$2,$3,$4,$5,$6,$7,$8,"_","_",$10
    else {
	args=$11
	for(i=11; i < NF; i+=1) {args = args "/" $(i+1)}
	split(args,b,/\//)
	margs = join1(b,"\t")
	print $1,$2,$3,$4,$5,$6,$7,$8,"_","_",$10,margs
    }
    next
}

{print}
