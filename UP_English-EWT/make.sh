
sbcl --load merge.lisp --eval "(in-package :merge-pb)" --eval "(main)" --eval "(sb-ext:quit)"

for f in en_ewt-up-{dev,test,train}.conllu.new; do
    awk -f conllu-to-conll.awk $f > $(basename $f .conllu.new).conllu;
done
rm en_ewt-up-{dev,test,train}.conllu.new


