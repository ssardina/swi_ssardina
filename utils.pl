:- module(utils,
    [ get_datetime_str/1,
    get_datetime_str/2,
    round/3
    ]).

timezone(N, N) :- number(N), !.
timezone('Australia/Melbourne', -3600).

get_datetime_str(S) :- get_datetime_str(S, local).
get_datetime_str(S, TZ) :-
    get_time(T),
    timezone(TZ, Offset),
    stamp_date_time(T, DT, Offset),
    format_time(string(S), '%Y-%m-%d %H:%M:%S', DT).




/* ************************************************************
 MATH UTILITIES


 ****************************************************************** */
round(X, R, N) :-
    E is 10^N,
	R is round(X*E) / E.

