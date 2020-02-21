
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

$0 ~ /^#/ {print; next}

$0 ~ /^[0-9]/ && NF == 10 {
    pmisc = $10;
    delete a;
    delete b;
    
    str2map(pmisc,"|","=",a)
    frame = a["Framefile"]
    delete a["Framefile"]
    if ( frame == "-") frame = "_"
    role = a["Roleset"]
    delete a["Roleset"]
    if ( role == "-" ) role = "_"

    args=a["Args"]
    delete a["Args"]
    split(args,b,/\//)
    margs = join1(b,"\t")
    
    misc  = join2(a,"|","=")
    if (misc == "") misc = "_"

    print $1,$2,$3,$4,$5,$6,$7,$8,$9,misc,role,margs
    next
}

{print}
