/* ****************************************************************************
    DATE/TIME UTILITIES

 Extensions to teh built-in date/time utilities, to allow for timezone handling and formatting.
    https://www.swi-prolog.org/pldoc/man?section=timedate
    *************************************************************************** */
:- module(datetime_ssardina,
    [
        get_date_time/1,
        get_date_time_tz/2,
        iso_timestamp_string_atom/2,
        get_iso_timestamp/1,
        get_iso_timestamp/2,
        stamp_date_time/2,
        stamp_date_time_tz/3,
        weekday_number/2
    ]).

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


%! iso_timestamp(+DTISOStr:str, -DTISOAtom:atom)
%
% Convert a timestamp string (e.g. "1995-01-23 09:00:00") into an
%   ISO 8601 format atom (e.g. '1995-01-23T09:00:00') for Prolog facts.
%
%  It accepts both ISO format (with 'T') and space-separated format, but always returns an ISO atom.
%
%  SWIPL Doc on time: https://www.swi-prolog.org/pldoc/man?section=timedate
%
%   2 ?- iso_timestamp_string_atom("1995-01-23T16:30:00", X).
%   X = '1995-01-23T16:30:00'.
%
%   3 ?- iso_timestamp_string_atom("1995-01-23 16:30:00", X).
%   X = '1995-01-23T16:30:00'.
iso_timestamp_string_atom(DTISOStr, DTISOAtom) :-
    parse_time(DTISOStr, _),            % with T separator already: "1995-01-23T16:30:00"
    atomic_list_concat([_Date, _Time], 'T', DTISOStr), !,
    atom_string(DTISOAtom, DTISOStr).
iso_timestamp_string_atom(DTISOStr, DTISOStrISO) :-
    atom_string(DTISOStr, DTISOStrStr), % handles "1995-01-23 16:30:00"
    split_string(DTISOStrStr, " ", "", [DatePart, TimePart]),
    atomic_list_concat([DatePart, TimePart], 'T', DTISOStrISO).


%! get_iso_timestamp(-Stamp) is det.
%  get_iso_timestamp(-Stamp, +TimeZone) is det.
%
% Retrieves the current timestamp as an ISO 8601 formatted string in the timezone.
% If no timezone is specified, it defaults to the local timezone.
% If TimeZone is none or none(TZ), it returns the ISO timestamp without timezone information.
%
%  uses format_time/3 - https://www.swi-prolog.org/pldoc/man?predicate=format_time/3
get_iso_timestamp(Stamp) :-
    get_iso_timestamp(Stamp, local).
get_iso_timestamp(ISO, none) :- !,
    get_iso_timestamp(ISO, none(local)).
get_iso_timestamp(ISO, none(TZ)) :- !,
    get_time(Stamp),
    stamp_date_time_tz(Stamp, DateTime, TZ),
    format_time(atom(ISO), '%FT%T', DateTime).
get_iso_timestamp(ISO, TZ) :-
    get_time(Stamp),
    stamp_date_time_tz(Stamp, DateTime, TZ),
    format_time(atom(ISO), '%FT%T%:z', DateTime).



%! weekday_number(+StartISO, -DayNo)
%
% Given a timestamp string, determine the day of the week as a number (1=Monday, ..., 7=Sunday).
weekday_number(StartISO, DayNo) :-
	parse_time(StartISO, StartStamp),
	stamp_date_time(StartStamp, Date, local),
	date_time_value(date, Date, Day),
	day_of_the_week(Day, DayNo).
