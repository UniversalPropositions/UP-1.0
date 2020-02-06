
BEGIN {OFS = "\t"}

$0 ~ /^[0-9]/ && NF > 1 {
    for(i=j=11; i < NF; i+=1) {$j = $j"/"$(i+1)}
    # ID form lemma upos xpos feats head deprel deps misc
    print $1, $2, $3, $4, $5, $6, $7, $8, "_", "SRL=" $9 "|" "Roleset=" $10 "|" "Args=" $11
    next
} 

{print}
