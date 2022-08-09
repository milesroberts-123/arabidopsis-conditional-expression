#!/bin/bash
n=$(grep -c "^" rnaSra.txt)
d=1000
q=$(( n / d + 1))
split --numeric-suffixes --suffix-length=4 -l $q rnaSra.txt rnaSra_split

n=$(grep -c "^" dnaSra.txt)
d=1000
q=$(( n / d + 1))
split --numeric-suffixes --suffix-length=4 -l $q dnaSra.txt dnaSra_split

#rename -n 's/split0{1,3}/split/' sras_split*
rename 's/split0{1,3}/split/' rnaSra_split*
rename 's/split0{1,3}/split/' dnaSra_split*

#rename -n 's/split0*/split/' *split*
#rename 's/split0*/split/' *split*

#rename -n 's/split900/split9/' *split*
#rename 's/split900/split9/' *split*

#rename -n 's/split901/split10/' *split*
#rename 's/split901/split10/' *split*

#rename -n 's/split902/split11/' *split*
#rename 's/split902/split11/' *split*

#rename -n 's/split903/split12/' *split*
#rename 's/split903/split12/' *split*

#rename -n 's/split904/split13/' *split*
#rename 's/split904/split13/' *split*

