
sbcl --load merge.lisp --eval "(in-package :merge-pb)" --eval "(main)" --eval "(sb-ext:quit)"

for f in en_ewt-up-{dev,test,train}.conllu.new; do
    awk -f conllu-to-conllup.awk $f > $(basename $f .conllu.new).conllup;
done
rm en_ewt-up-{dev,test,train}.conllu.new


