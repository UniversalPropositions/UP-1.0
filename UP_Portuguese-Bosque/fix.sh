
for f in *.conll; do
    awk -f fix-meta.awk $f > tmp;
    awk -f fix-columns.awk tmp > $(basename $f .conll).conllu;
    rm tmp
done
