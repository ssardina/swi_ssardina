:- module(system_ssardina,
    [
        run_python/3
    ]).

:- use_module(library(http/http_open)).
:- use_module(library(socket)).
:- use_module(library(debug)).


%! run_python(+Script, +Args, -Status) is det.
%
% Executes a Python script with the given arguments and captures its output and error streams.
% Script: Path to the Python script to execute.
% Args: List of arguments to pass to the Python script.
% Status: The exit status of the Python process.
%
%  e.g., run_python('script.py', ['arg1', 'arg2'], Status).
run_python(Script, Args, Status) :-
	(exists_file(Script)
    ->  true
    ;
	    throw(error(existence_error(file, Script), _))
    ),
	process_create(path(python),
		[Script|Args],
		[stdout(pipe(Out)), stderr(pipe(Err)), process(PID)]),
	read_string(Out, _, StdOut),
	read_string(Err, _, StdErr),
	% always read before finishing process (output too large for OS buffers)
	close(Out),
	close(Err),
	process_wait(PID, Status),
	debug(debug, "Python ID and status: ~d - ~w~n", [PID, Status]),
	debug(debug, "Python output: ~s~n", [StdOut]),
	debug(debug, "Python error: ~s~n", [StdErr]).
