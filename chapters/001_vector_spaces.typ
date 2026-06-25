#import "../utils.typ": *

= Vector Spaces

#lettrine[
  To understand what a vector space is, we first need to understand what is a *vector*. They are the building blocks for all Linear Algebra. They will come up everywhere in the rest of the book.
]

== Vectors

#definition(title: "Vector")[
  A vector is an ordered list of numbers.
]

A vector usually has a few representations. We can draw it as an arrow:

#vecplot(((3, 5), $v$), caption: "A simple vector.")

Or write is as a vertical sequence of numbers enclosed in square brackets:

$
  v = vec(3, 5)
$

== Scalars

#definition(title: "Scalar")[
  A scalar is a single number.
]

While a vector is an ordered list of numbers, a scalar is just one number on its own.

$
  s = 3
$

== Operations on Vectors

=== Addition of Vectors

#definition(title: "Vector Addition")[
  The sum of two vectors is obtained by adding their corresponding components:
  $
    vec(a_1, a_2, dots.v, a_n) + vec(b_1, b_2, dots.v, b_n) = vec(a_1 + b_1, a_2 + b_2, dots.v, a_n + b_n)
  $
]

Addition is one of the most basic operations on vectors, and its result is again a vector. Think of each vector as a path: start at the tail of the arrow and walk to its tip. Adding two vectors then answers a simple question: where do I end up if I walk along the first arrow, and from there walk along the second? Visually:

#vecplot(
  ((3, 1), $v_1$),
  ((-1, -7), $v_2$),
  ((3, 1), (2, -6), $v_1 + v_2'$),
  caption: "Sum of two vectors in 2d space.",
)

Numerically, adding two vectors means adding them component by component: each entry of the result is the sum of the corresponding entries of the two vectors.

$
  a = vec(3, 1), b = vec(-1, -7) \
  a + b = vec(3, 1) + vec(-1, -7) = vec(2, -6)
$

=== Multiplication of Vectors with Scalars

#definition(title: "Scalar Multiplication")[
  The product of a scalar $s$ and a vector is obtained by multiplying every component by $s$:
  $
    s dot vec(a_1, a_2, dots.v, a_n) = vec(s dot a_1, s dot a_2, dots.v, s dot a_n)
  $
]

Multiplying a vector by a scalar resizes it: the arrow keeps its direction but its length is scaled by that number. Numerically, we multiply every component of the vector by the scalar:

$
  3 dot vec(1, 2) = vec(3 dot 1, 3 dot 2) = vec(3, 6)
$

Geometrically, multiplying by $3$ stretches the arrow to three times its length:

#vecplot(((3, 6), $3 dot a$), ((1, 2), $a$), ((-1, -2), $-a$))

A scalar greater than $1$ stretches the vector, a scalar between $0$ and $1$ shrinks it, and a negative scalar flips it to point the opposite way.

== Vector Spaces

#definition(title: "Vector Space")[
  A *vector space* is a set $V$ together with an addition on $V$ and a scalar multiplication on $V$ such that the following properties hold:

  - *commutativity*: $u + v = v + u quad forall u, v in V$
  - *associativity*: $(u + v) + w = u + (v + w)$ and $(a b) v = a (b v) quad forall u, v, w in V, space a, b in RR$;
  - *additive identity*: $exists 0 in V$ such that $v + 0 = v quad forall v in V$;
  - *additive inverse*: $forall v in V, space exists w in V$ such that $v + w = 0$;
  - *multiplicative identity*: $1 v = v quad forall v in V$;
  - *distributive properties*: $a (u + v) = a u + a v$ and $(a + b) v = a v + b v quad forall a, b in RR, space u, v in V$.
]

Basically you can imagine a vector space as a self-contained world for vectors. The eight properties above all say the same thing in different words: whatever you do inside the space using the two allowed operations, you never leave it.
Add any two vectors and the result is still in the space. Scale any vector by any number and the result is still in the space.
This is the property of *closure*, and it is what makes a set a vector space rather than just a loose collection of arrows.

#theorem(title: "Unique Additive Identity")[
  A vector space has a unique additive identity
]
#proof[
  Let's say that $0$ and $0'$ are *both* additive identities. It must follow that:
  $
    0' = 0' + 0 quad "additive identity" \
    = 0 + 0' quad "commutativity" \
    = 0 quad "additive identity"
  $
]

We can also prove the inverse element is unique:
#theorem(title: "Unique Inverse")[
  Every element in a vector space has a unique additive inverse.
]
#proof[
  Let's say $V$ is a vector space, $v, w, w' in V$ and $w, w'$ are *both* the inverse of $v$. We could argue that:
  $
    w = w + 0 quad "additive identity" \
    = w + (v + w') quad "definition of inverse"\
    = (w + v) + w' quad "associativity"\
    = 0 + w' quad "definition of inverse"\
    = w' quad "additive identity" 
  $
]
