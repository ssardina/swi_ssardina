:- module(utils_ssardina,
    [
        % DATE-TIME TOOLS
        iso_timestamp/2,
        get_date_time/1,
        get_date_time_tz/2,
        stamp_date_time/2,
        stamp_date_time_tz/3,
        % MATH TOOLS
        round/3
    ]).


/* ****************************************************************************
    DATE/TIME UTILITIES

 Extensions to teh built-in date/time utilities, to allow for timezone handling and formatting.
    https://www.swi-prolog.org/pldoc/man?section=timedate
    *************************************************************************** */
:- use_module(facts/timezones).  % Facts about timezones


%! get_date_time(-DateTime) is det.
%
% Retrieves the current date and time as a date-time structure in the local timezone.
get_date_time(DT) :-
	get_time(T),
	stamp_date_time(T, DT).


%! get_date_time_tz(-DateTime, +Timezone) is det.
%
% Retrieves the current date and time as a date-time structure.
% If a timezone is specified, it adjusts the date-time accordingly.
get_date_time_tz(DT, TZ) :-
    get_time(T),
    stamp_date_time_tz(T, DT, TZ).


%! stamp_date_time(+Stamp, -DateTime) is det.
%
% Generalization of stamp-date_time/3 to default local timezone
%   https://www.swi-prolog.org/pldoc/doc_for?object=stamp_date_time/3
stamp_date_time(T, DT) :-
	stamp_date_time_tz(T, DT, local).


%! stamp_date_time_tz(+Stamp, -DateTime, +Timezone) is det.
%
% Converts a timestamp to a date-time structure, taking into account the specified
% timezone as IANA identifiers (e.g., "America/New_York").
%
% If the timezone is not recognized, it falls back to using the default Offset timezone
stamp_date_time_tz(T, DT, TZ) :-
    timezone(TZ, Offset), !,
    stamp_date_time(T, DT, Offset).
stamp_date_time_tz(T, DT, TZ) :-
	stamp_date_time(T, DT, TZ).



%! iso_timestamp(+Startl:str, -StartAtom:atom)
%
% Convert a timestamp string (e.g. "1995-01-23 09:00:00") into an
%   ISO 8601 format atom (e.g. "1995-01-23T09:00:00") for Prolog facts.
%
%  SWIPL Doc on time: https://www.swi-prolog.org/pldoc/man?section=timedate
%
% A TimeStamp is a floating point number expressing the time in seconds since the Epoch at 1970-01-01.
iso_timestamp(Start, StartAtom) :-      % it is already ISO!
    parse_time(Start, _), % will also parse without the T, so we check!
    atomic_list_concat([_Date, _Time], 'T', Start), !,
    atom_string(StartAtom, Start).
iso_timestamp(Start, StartISO) :-   % handles "1995-01-23 16:30:00"
    atom_string(Start, StartStr),
    split_string(StartStr, " ", "", [DatePart, TimePart]),
    atomic_list_concat([DatePart, TimePart], 'T', StartISO).




get_datetime_str(S) :- get_datetime_str(S, local).
get_datetime_str(S, TZ) :-
    get_time(T),
    timezone(TZ, Offset),
    stamp_date_time(T, DT, Offset),
    format_time(string(S), '%Y-%m-%d %H:%M:%S', DT).


/* ****************************************************************************
 MATH UTILITIES
 *************************************************************************** */
round(X, R, N) :-
    E is 10^N,
	R is round(X*E) / E.

