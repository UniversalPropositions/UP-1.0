
BEGIN {OFS = "\t"; new_sent = 1}

NF == 0 { new_sent = 1; print ""; next }

new_sent == 1 && NF > 0 {
    new_sent = 0;
    doc = $1;
    sent = $2;
    print "# filename = " FILENAME
    print "# sent_id = " $2
    print "# doc_id = " $1
}

new_sent == 0 && NF > 1 {
    for(i=j=9; i < NF; i+=1) {$j = $j"/"$(i+1)}
    # ID form lemma upos xpos feats head deprel deps misc
    print $3, $4, $4, $5, "_", "_", "_", "_", $6, "Framefile=" $7 "|" "Roleset=" $8 "|" "Args=" $9
} 
