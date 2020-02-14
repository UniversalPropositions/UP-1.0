
http://pragmaticemacs.com/emacs/aligning-text/
https://ufal.mff.cuni.cz/conll2009-st/eval-data.html


1. run the AWK script to produce the en-ewt.conllu file.
2. run the merge.lisp to produce the ud+prop.conllu (revise, kept the dev,train,test sets)
3. project spans to head-words


Statistics:


total number of sentences:

% grep "sent_id" ud+prop.conllu | wc -l
   16622

verbs not tagged as predicate:

% awk '$4 ~ /VERB/ && $10 !~ /\(V\*/ {print}' ud+prop.conllu | wc -l
    1097

non verb tagged as predicate:

% awk '$10 ~ /\(V\*/ {print $4}' ud+prop.conllu | sort | uniq -c
 2849 ADJ
    2 ADV
11325 AUX
 8763 NOUN
    1 NUM
27312 VERB
    3 X

C-V cases (ignore the verbs):

% awk '$0 ~ /C-V\*/ {print}' ud+prop.conllu | wc -l
     187

C-ARG? discontinue (ignore the verb+args):

% awk '$0 ~ /C-ARG[0-9]\*/ {print}' ud+prop.conllu | wc -l
     695

R-ARG? references (ignore the verb+args):

% awk '$0 ~ /R-ARG[0-9]\*/ {print}' ud+prop.conllu | wc -l
    1291
     
     

sent_id = reviews-319816-0022
text = Of course, they would be closing in 5 minutes, so I would have to hurry up or get it the next day.
─┮  
 │ ╭─┮Of ADV advmod		*	(ARGM-DIS 
 │ │ ╰─╼course ADV fixed 	*	*)	 
 │ ├─╼, PUNCT punct   
 │ ├─╼they PRON nsubj		*	(ARG1*)	 
 │ ├─╼would AUX aux 		*	(ARGM-MOD*)	 
 │ ├─╼be AUX aux  		(V*)	 
 ╰─┾closing VERB root		*	(V*)	 
   │ ╭─╼in ADP case 		*	(ARGM-TMP 
   │ ├─╼5 NUM nummod   
   ├─┶minutes NOUN obl		*	*)	 
   ├─╼, PUNCT punct   
   │ ╭─╼so ADV advmod   
   │ ├─╼I PRON nsubj		*	*	*	(ARG1*)	(ARG0*) 
   │ ├─╼would AUX aux   
   ├─┾have VERB parataxis 	*	*	(V*)	 
   │ │ ╭─╼to PART mark   
   │ ╰─┾hurry VERB xcomp 	*	*	*	(V*)	 
   │   ├─╼up ADP compound:prt 	*	*	*	(ARGM-PRD*)	 
   │   │ ╭─╼or CCONJ cc   
   │   ╰─┾get VERB conj 	*	*	*	*	(V*) 
   │     ├─╼it PRON obj 	*	*	*	*	(ARG1*) 
   │     │ ╭─╼the DET det 	*	*	*	*	(ARGM-TMP 
   │     │ ├─╼next ADJ amod   
   │     ╰─┶day NOUN obl:tmod 	*	*	*	*	*) 
   ╰─╼. PUNCT punct   



sent_id = reviews-319816-0020
text = Over two hours later (and ten minutes before they closed) my car was finally finished.
─┮  
 │       ╭─╼Over ADP advmod  	*	*	(ARGM-TMP 
 │     ╭─┶two NUM nummod   
 │   ╭─┶hours NOUN obl:npmod   
 │ ╭─┾later ADV advmod   
 │ │ ├─╼( PUNCT punct   
 │ │ │ ╭─╼and CCONJ cc   
 │ │ │ │   ╭─╼ten NUM nummod   
 │ │ │ │ ╭─┶minutes NOUN obl:npmod   
 │ │ │ ├─┶before SCONJ mark   
 │ │ │ ├─╼they PRON nsubj  	(ARG1*)	 
 │ │ ├─┶closed VERB conj  	(V*)	 
 │ │ ╰─╼) PUNCT punct  		*	*	*) 
 │ │ ╭─╼my PRON nmod:poss  	*	*	(ARG1 
 │ ├─┶car NOUN nsubj:pass  	*	*	*) 
 │ ├─╼was AUX aux:pass  	*	(V*)	 
 │ ├─╼finally ADV advmod  	*	*	(ARGM-TMP*) 
 ╰─┾finished VERB root  	*	*	(V*) 
   ╰─╼. PUNCT punct   




sent_id = reviews-319816-0028
text = The employees at this Sear's are completely apathetic and there didn't seem to be any sort of management that I could see.
─┮  
 │   ╭─╼The DET det			(ARG1 
 │ ╭─┾employees NOUN nsubj   
 │ │ │ ╭─╼at ADP case   
 │ │ │ ├─╼this DET det   
 │ │ ╰─┶Sear's PROPN nmod		*)	 
 │ ├─╼are AUX cop			(V*)	 
 │ ├─╼completely ADV advmod		(ARG2 
 ╰─┾apathetic ADJ root			*)	 
   │ ╭─╼and CCONJ cc   
   │ ├─╼there PRON expl			*	*	(ARG1*)		(ARG1*)	 
   │ ├─╼did AUX aux			*	(V*)	 
   │ ├─╼n't PART advmod			*	*	(ARGM-NEG*)	 
   ├─┾seem VERB conj			*	*	(V*)		 
   │ │ ╭─╼to PART mark			*	*	(C-ARG1 
   │ ╰─┾be VERB csubj			*	*	*		(V*)		 
   │   │ ╭─╼any DET det			*	*	*		(ARG2 
   │   ╰─┾sort NOUN nsubj   
   │     │ ╭─╼of ADP case   
   │     ╰─┾management NOUN nmod	*	*	*		*		(V*)		(ARG1*) 
   │       │ ╭─╼that PRON obj		*	*	*		*		(ARGM-ADJ*	(R-ARG1*) 
   │       │ ├─╼I PRON nsubj		*	*	*		*		*		(ARG0*) 
   │       │ ├─╼could AUX aux		*	*	*		*		*		(ARGM-MOD*) 
   │       ╰─┶see VERB acl:relcl	*	*	*)		*)		*)		(V*) 
   ╰─╼. PUNCT punct   



sent_id = reviews-333243-0014
text = In the words of my new accountant, THEY LET ME DOWN!
─┮  
 │   ╭─╼In ADP case		(ARGM-ADV 
 │   ├─╼the DET det   
 │ ╭─┾words NOUN obl   
 │ │ │ ╭─╼of ADP case   
 │ │ │ ├─╼my PRON nmod:poss   
 │ │ │ ├─╼new ADJ amod   
 │ │ ╰─┶accountant NOUN nmod	*) 
 │ ├─╼, PUNCT punct   
 │ ├─╼THEY PRON nsubj		(ARG0*) 
 ╰─┾LET VERB root		(V*) 
   ├─╼ME PRON obj		(ARG1*) 
   ├─╼DOWN ADP compound:prt	(C-V*) 
   ╰─╼! PUNCT punct   


sent_id = weblog-blogspot.com_thelameduck_20041119192207_ENG_20041119_192207-0008
text = With the demand so high, the question arises on to who should be or has the right to be the Santa of nuclear weapons.
─┮  
 │   ╭─╼With SCONJ mark		*	*		*	(ARGM-ADV 
 │   │ ╭─╼the DET det		*	(ARG1 
 │   ├─┶demand NOUN nsubj	(V*)	*)		 
 │   ├─╼so ADV advmod		*	(ARGM-EXT*)	 
 │ ╭─┶high ADJ advcl		*	(V*)		*	*)	 
 │ ├─╼, PUNCT punct   
 │ │ ╭─╼the DET det		*	*		*	(ARG1 
 │ ├─┶question NOUN nsubj	*	*		(V*)	*)	 
 ╰─┾arises VERB root		*	*		*	(V*)	 
   │ ╭─╼on ADP mark		*	*		(ARG1*	(C-ARG1 
   │ ├─╼to SCONJ mark   
   │ ├─╼who PRON nsubj		*	*		*	*	(ARG1*)	(ARG0*)	 
   │ ├─╼should AUX aux		*	*		*	*	(ARGM-MOD*)	 
   ├─┾be AUX obl		*	*		*	*	(V*)		 
   │ │ ╭─╼or CCONJ cc   
   │ ╰─┾has VERB conj		*	*		*	*	*		(V*)		 
   │   │ ╭─╼the DET det		*	*		*	*	*		(ARG1 
   │   ╰─┾right NOUN obj	*	*		*	*	*		*		(V*)	 
   │     │ ╭─╼to PART mark	*	*		*	*	*		*		(ARG2 
   │     │ ├─╼be AUX cop	*	*		*	*	*		*		*	(V*) 
   │     │ ├─╼the DET det	*	*		*	*	(ARG2*		*		*	(ARG2 
   │     ╰─┾Santa PROPN acl   
   │       │ ╭─╼of ADP case   
   │       │ ├─╼nuclear ADJ amod   
   │       ╰─┶weapons NOUN nmod *	*		*)	*)	*)		*)		*)	*) 
   ╰─╼. PUNCT punct   

