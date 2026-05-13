:- module(utils_ssardina,
    [
        stamp_date_time/2,
        stamp_date_time_tz/3,
        get_datetime_str/1,
        get_datetime_str/2,
        round/3
    ]).

:- use_module(facts/languages).  % Facts about languages


stamp_date_time(T, DT) :-
    stamp_date_time_tz(T, DT, local).


stamp_date_time_tz(T, DT, TZ) :-
    number(TZ), !,
    stamp_date_time(T, DT, TZ).
stamp_date_time_tz(T, DT, TZ) :-
    timezone(TZ, Offset),
    stamp_date_time(T, DT, Offset).

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

