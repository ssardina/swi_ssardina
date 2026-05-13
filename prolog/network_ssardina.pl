:- module(network_ssardina,
    [
        public_ip/1
    ]).

:- use_module(library(http/http_open)).
:- use_module(library(socket)).


public_ip(IP) :-
    setup_call_cleanup(
        http_open('http://api.ipify.org', In, []),
        read_string(In, _, IP),
        close(In)
    ).

