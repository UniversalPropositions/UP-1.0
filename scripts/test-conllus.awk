
function str2map(str,fs1,fs2,map) {
   n=split(str,lmap,fs1)
   for (x in lmap) { 
     split(lmap[x],tmp,fs2);
     map[tmp[1]]=tmp[2];
   }
   return n
}

function join1(array, sep) {
    result = ""
    for(i in array)
	if(result == "")
	    result = array[i]
	else
	    result = result sep array[i]
    return result
}

function join2(array, sep1, sep2) {
    result = ""
    for(i in array)
	if(result == "")
	    result = i sep2 array[i]
	else
	    result = result sep1 i sep2 array[i]
    return result
}


BEGIN {OFS = "\t";}

$0 ~ /^#/ {news=1}

$0 ~ /^[0-9]/ {
    if(news==1) {
	lnf = NF
	news = 0
    }
    print NF, lnf
    next
}

{print}

