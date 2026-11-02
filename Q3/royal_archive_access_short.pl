:- use_module(library(lists)).
clause_set([
    [neg(archivist(X1)), neg(verifies(X1,R1)), pos(trusted(X1))],
    [neg(trusted(X2)), neg(has_access(X2,R2)), neg(sealed(R2)), pos(permitted_inspect(X2,R2))],
    [neg(stored_in_archive(R3)), pos(sealed(R3))],
    [neg(inspects(X4,R4)), neg(finds_hidden_mark(X4,R4)), pos(verifies(X4,R4))],
    [pos(stored_in_archive(scroll_y))],
    [pos(has_access(mira,scroll_y))],
    [pos(inspects(mira,scroll_y))],
    [pos(finds_hidden_mark(mira,scroll_y))],
    [pos(archivist(mira))],
    [neg(trusted(mira))]
]).
complement(pos(A), neg(A)).
complement(neg(A), pos(A)).
resolve(C1, C2, Resolvent) :-
    member(L1, C1), complement(L1, L2), member(L2, C2),
    subtract(C1, [L1], R1), subtract(C2, [L2], R2),
    append(R1, R2, Combined), list_to_set(Combined, Resolvent).
step_resolution :-
    writeln('\nRESOLUTION REFUTATION'),
    writeln('C1: ¬archivist(X) ∨ ¬verifies(X,R) ∨ trusted(X)'),
    writeln('C4: ¬inspects(X,R) ∨ ¬finds_hidden_mark(X,R) ∨ verifies(X,R)'),
    writeln('C5-C9: stored_in_archive(scroll_y), has_access(mira,scroll_y),'),
    writeln('       inspects(mira,scroll_y), finds_hidden_mark(mira,scroll_y), archivist(mira)'),
    writeln('C10: ¬trusted(mira)\n'),
    C4 = [neg(inspects(X,R)),neg(finds_hidden_mark(X,R)),pos(verifies(X,R))],
    C7 = [pos(inspects(mira,scroll_y))],
    resolve(C4,C7,R1), format('R1: ~w~n',[R1]),
    C8 = [pos(finds_hidden_mark(mira,scroll_y))],
    resolve(R1,C8,R2), format('R2: ~w~n',[R2]),
    C1 = [neg(archivist(Y)),neg(verifies(Y,_)),pos(trusted(Y))],
    resolve(C1,R2,R3), format('R3: ~w~n',[R3]),
    C9 = [pos(archivist(mira))],
    resolve(R3,C9,R4), format('R4: ~w~n',[R4]),
    C10 = [neg(trusted(mira))],
    resolve(R4,C10,[]),
    writeln('R5: [] - contradiction found. trusted(mira) is proven.').
verify_resolution :-
    C4 = [neg(inspects(X,R)),neg(finds_hidden_mark(X,R)),pos(verifies(X,R))],
    C7 = [pos(inspects(mira,scroll_y))],
    resolve(C4,C7,R1),
    resolve(R1,[pos(finds_hidden_mark(mira,scroll_y))],R2),
    C1 = [neg(archivist(Y)),neg(verifies(Y,_)),pos(trusted(Y))],
    resolve(C1,R2,R3),
    resolve(R3,[pos(archivist(mira))],R4),
    resolve(R4,[neg(trusted(mira))],[]),
    writeln('Resolution verification: PASS').
fact(stored_in_archive(scroll_y)).
fact(has_access(mira,scroll_y)).
fact(inspects(mira,scroll_y)).
fact(finds_hidden_mark(mira,scroll_y)).
fact(archivist(mira)).
verifies(X,R) :- fact(inspects(X,R)), fact(finds_hidden_mark(X,R)).
trusted(X) :- fact(archivist(X)), verifies(X,_).
sealed(R) :- fact(stored_in_archive(R)).
permitted_inspect(X,R) :- trusted(X), fact(has_access(X,R)), sealed(R).
knowledge_base_query :-
    (trusted(mira) -> writeln('trusted(mira): TRUE') ; writeln('trusted(mira): FALSE')),
    (permitted_inspect(mira,scroll_y) ->
        writeln('permitted_inspect(mira,scroll_y): TRUE')
    ; writeln('permitted_inspect(mira,scroll_y): FALSE')).
run_all :-
    step_resolution,
    verify_resolution,
    knowledge_base_query,
    writeln('\nConclusion: Mira is trusted.').
:- initialization(run_all, main).