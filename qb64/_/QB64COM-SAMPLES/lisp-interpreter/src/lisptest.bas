(+ 2 2)
(apply + '(1 2 3))
(+ 1 -3 2 5)
(define generator (lambda (x) (lambda (y) (if y (generator y) x))))
(define pocket (generator 8))
(pocket nil)
(define pocktwo (pocket 10))
(pocktwo '())
(define fact (lambda (x) (if (= x 0) 1 (* x (fact (+ x -1))))))
(fact 5)
(fact 7)
(DEFINE MAP (LAMBDA (F X) (IF X (CONS (F (CAR X)) (MAP F (CDR X))))))
(MAP (LAMBDA (X) (* X 2)) '(1 2 3 4 5 6 7 ))