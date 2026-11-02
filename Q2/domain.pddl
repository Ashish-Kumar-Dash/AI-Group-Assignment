(define (domain mars-rover)
  (:requirements :strips :typing)
  (:types location rock bay)

  (:predicates
    (rover-at ?l - location)
    (connected ?a - location ?b - location)
    (rock-at ?r - rock ?l - location)
    (drill-at ?l - location)
    (has-drill)
    (soft ?r - rock)
    (hard ?r - rock)
    (bay-empty ?b - bay)
    (holding ?b - bay ?r - rock))

  (:action move
    :parameters (?from - location ?to - location)
    :precondition (and (rover-at ?from) (connected ?from ?to))
    :effect (and (rover-at ?to) (not (rover-at ?from))))

  (:action pick-drill
    :parameters (?l - location)
    :precondition (and (rover-at ?l) (drill-at ?l))
    :effect (and (has-drill) (not (drill-at ?l))))

  (:action collect-soft
    :parameters (?r - rock ?l - location ?b - bay)
    :precondition (and (rover-at ?l) (rock-at ?r ?l) (soft ?r) (bay-empty ?b))
    :effect (and (holding ?b ?r) (not (rock-at ?r ?l)) (not (bay-empty ?b))))

  (:action collect-hard
    :parameters (?r - rock ?l - location ?b - bay)
    :precondition (and (rover-at ?l) (rock-at ?r ?l) (hard ?r) (has-drill) (bay-empty ?b))
    :effect (and (holding ?b ?r) (not (rock-at ?r ?l)) (not (bay-empty ?b))))

  (:action deposit
    :parameters (?r - rock ?l - location ?b - bay)
    :precondition (and (rover-at ?l) (holding ?b ?r))
    :effect (and (rock-at ?r ?l) (bay-empty ?b) (not (holding ?b ?r))))
)