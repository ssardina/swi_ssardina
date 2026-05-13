:- module(utils_ssardina,
    [
        downcase_term/2,
        % MATH TOOLS
        round/3
    ]).



%! downcase_term(+Term:term, -LowerTerm:term) is det
%
% Recursively downcase all atoms in Term, including those nested within lists and dicts.
% Useful for normalizing identifiers to lowercase atoms in Prolog.
downcase_term(Term, LowerTerm) :- atom(Term), !,
    downcase_atom(Term, LowerTerm).
downcase_term(Term, Term) :- atomic(Term), !.
downcase_term(Term, LowerTerm) :-
	is_list(Term),
	!,
	maplist(downcase_term, Term, LowerTerm).
downcase_term(Term, LowerTerm) :-
    compound(Term),
	Term =.. [Functor|Args],
	maplist(downcase_term, Args, LowerArgs),
	LowerTerm =.. [Functor|LowerArgs].
downcase_term(Term, _) :-
    format(atom(Msg), 'Cannot downcase term: ~w', [Term]),
    throw(error(Msg)).



/* ****************************************************************************
 MATH UTILITIES
 *************************************************************************** */

%! round(+X:float, -R:float, +N:int) is det
%
% R is X rounded to N decimal places.
round(X, R, N) :-
    E is 10^N,
	R is round(X * E) / E.




