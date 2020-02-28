

BEGIN {OFS = "\t" ; FS="\t"}

$0 ~ /^[0-9]/ && NF > 11 {
    for(i=12; i <= NF; i++) {
	print $i
    }
    next
}
