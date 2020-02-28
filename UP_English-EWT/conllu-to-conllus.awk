
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

$0 ~ /^# propbank-nprop =/ {
    nprop = substr($0,19)
    next
}    

$0 ~ /^#/ {print; next}

$0 ~ /^[0-9]/ && NF == 10 {
    pmisc = $10;
    delete a;
    delete b;

    str2map(pmisc,"|","=",a)

    role = a["Roleset"]
    if ( role == "-" || role == "" ) role = "_"

    args=a["Args"]
    if(args == ""){
	for(i=1; i <= (nprop + 0); i++) b[i] = "_"
    }
    else {
	nprop = split(args,b,/\//)
    }
    margs = join1(b,"\t")

    delete a["Framefile"]	
    delete a["Roleset"]
    delete a["Args"]
    
    misc  = join2(a,"|","=")
    if (misc == "" || pmisc == "_") misc = "_"

    if(margs == "")
	print $1,$2,$3,$4,$5,$6,$7,$8,$9,misc,role
    else
	print $1,$2,$3,$4,$5,$6,$7,$8,$9,misc,role,margs
    next
}

{print}
