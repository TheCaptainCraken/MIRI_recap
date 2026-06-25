#import "utils.typ": *


#cover(
  title: [MIRI _Advanced Computing_ Preparation],
  subtitle: [From Linear Algebra, to Calculus, to Probability and Concurrency. Everything you need to succeed in your first semester.],
  term: [Preparation Material],
  author: [Pietro Agnoli],
  institution: [Universitat Poltècnica de Catalunya],
  kind: [Notes],
)

#show: book

#toc()

#notation(
  ([$vec(1, 2, 3)$], [A vector.]),
  ([$mat(1, 2; 3, 4)$], [A $2 times 2$ matrix.]),
  ([$(1, 2)$], [A list of two scalars also, known as a tuple.]),
  ([${1, 2, 3}$], [A set of three scalars.]),
)

#part[Linear Algebra]

#include "chapters/000_intro_algebra.typ"
#include "chapters/001_vector_spaces.typ"


#references("references.bib")
