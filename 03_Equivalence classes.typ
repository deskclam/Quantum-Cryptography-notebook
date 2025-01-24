#import "imports.typ":*

= Equivalence relations

#definition("Equivalence relation")[
  Let $A$ be a set. A relation of equivalence is a law between couples of elements of $A$ s.t. $x tilde y$.
  

]
== Properties

+ Reflexivity: $ x tilde x $

+ Symmetry: $ x tilde y arrow.double.long y tilde x $

+ Transitivity: $ x tilde y and y tilde z arrow.double x tilde z $

== Equivalence class

#definition("Equivalence class")[
Let $A$ be a set with an equivalence relation and let $x in A$. The equivalence class $[x]$ of $x$ is the subset of $A$ with all the elements equivalent to $x$:

$
[x] ={y in A "s.t." y tilde x}
$
]
#theorem[
Two equivalence classes either coincide or are disjoint.
]

#proof[ Suppose that $[x]$ and $[y]$ are not disjoint.
Let us consider $z in [x]sect [y]$

Since $z in [x] "implies" z ~ x $ and $ z in [y] "implies" z ~ y$  for symmetry and transitivity $ ==> x ~ y$.


Consider $ u in  [x]$, then $u~x$ but since also $x~y$ we conclude by transitivity $u~y ==> u in [y]==> [x] subset [y]$.

Analogously we obtain that $[y]subset[x]$, thus we can conclude that $[x]=[y].$
]

== Partitions

A partition of a set is a grouping of its elements into non-empty subsets, in such a way that every element is included in exactly one subset.
=== Properties

+ $ forall E in cal(F), E != emptyset $
+ $ forall E, E' in cal(F) , E != E', E sect E' = emptyset $
+ $ union.big_(E in cal(F)) {x in E} = A $

Given $A$ with "$tilde$", a family of subset of $A$ is naturally induced:
$ cal(F) = {[x], x in A} $

== Relations

A relation in a set denotes a relationship between two objects in a set. $A$ is a subset of $A times A$. 

*In general a relation is not an equivalence of relation.*

=== Equivalence classes

#example("Important")[
Given $a, b, r in ZZ$ we say:

$ a ~ b $ if and only if exists $k in ZZ st a-b = k r$ (with $r$ fixed).

+ Reflexivity: $ a-a = 0 = 0 dot r ==> a~a $
+ Symmetry: $ a- b =k r, space b-a= -k r, space -k in ZZ \ arrow.double.b \ (a~b ==> b ~a) $
+ Transitivity: $ a-b =k r "and" b-c =h r \ arrow.double.b \ a-c = (k + h)r quad "with" (h+k)in ZZ  \ arrow.double.b \ a~b "and" b~c \ arrow.double.b \ a~c  space $
*This is an equivalent relation*: $a-b =k r <==> a= b mod r $.
]
#example[
For $r = 4$


$[0]= {a in ZZ st a=4k}= {...,-8, -4, 0, 4, 8,...} \

[1]= {a in ZZ st a=4k+1}= {...,-7, -3, 1, 5, 9,...}\ 

[2]= {a in ZZ st a=4k+2}= {...,-6, -2, 2, 6,...} \

[3]= {a in ZZ st a=4k+3}= {...,-5, -1, 3, 7,...}\
[4]= {a in ZZ st a=4k+4}= {...,-8, -4, 0, 4, 8,...} = [0]
$

The set $ZZ$ is partitioned in $4$ subsets called *modulo-rect classes*.
This example can be used to introduce rings, since we have _sum_ and _product_.

]

== Rings <rings>

A set $R$ is called a ring if it has 2 inner operations _sum_ and _product_ such that:

+ Sum is associative and commutative $forall x,y,z in RR$: $ (x + y) + z = x + (y + z) \ x + y = y +z $
+ $exists$ a neutral element of the sum, called the "_zero_" "0" s.t.: $ x + 0 =x space forall x in RR $
+ $forall x in RR space exists$ the _inverse_ of $x, x'$ with respect to the sum s.t.: $ x + x' = 0 $
+ Product is associative $forall x, y, z in RR$: $ (x y)z = x (y z) $
+ Product is distributive with respect to the sum: $ (x + y) z = x z + y z \ x (y + z) = x y +x z $

We do not require that the product is commutative.

#remark[
  Modulo-rect classes $ZZ_r = {[0], ..., [r-1]}$ form a ring which is commutative with respect to product ("commutative ring").

  Given $ZZ_r^*$, for some element there exists the inverse with respect to the product ($exists [a]^(-1) <==> gcd(a, r) = 1$)
]