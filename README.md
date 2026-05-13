# SWI-Prolog Pack Utilities

This repository contains a collection of shared utilities for Prolog projects.

## Setup

Assuming SWI-Prolog is instaled, you can install this pack via CLI as follows:

```shell
$ swipl -q -g "pack_install('https://github.com/ssardina/swi_ssardina.git',[package(swi_ssardina),interactive(false),git(true),upgrade(true)])" -t halt
```

> [!NOTE]
> This will upgrade the pack if it is already installed. If you want to avoid that, set `upgrade(false)`.

From inside SWIPL itself:

```prolog
?- pack_install('https://github.com/ssardina/swi_ssardina.git', [package(swi_ssardina), git(true), upgrade(true)]).
```

This will install in folder `$HOME/.local/share/swi-prolog/pack/swi_ssardina`.

Confirm it is installed:

```prolog
?- pack_list_installed.
% Contacting server at https://www.swi-prolog.org/pack/query ... ok
i auc@1.0                          - Library for computing Areas Under the Receiving Operating Charactersitics and Precision Recall curves
i bddem@4.3.1                      - A library for manipulating Binary Decision Diagrams
i cplint@4.5.0                     - A suite of programs for reasoning with probabilistic logic programs
i matrix@2.0                       - Operations with matrices
l swi_ssardina@1.0.0               - Shared utilities for my Prolog projects
true.
```

To remove the package:

```prolog
?- pack_remove(swi_ssardina).
```

## Usage

Once the pack is installed, use the utilities in your Prolog code, simply load the library:

```prolog
?- use_module(library(utils_ssardina)).
true.

?- get_date_time(D).
D = date(2026, 5, 13, 14, 46, 54.307682514190674, -36000, 'AEST', false).

?- get_time(T), stamp_date_time_tz(T, DT, 'Australia/Melbourne').
T = 1778647645.071011,
DT = date(2026, 5, 13, 14, 47, 25.071011066, -36000, -, -) ;
```

To turn on debug in a module, enable it in the module scope:

```shell
?- use_module(library(system_ssardina)).

?- system_ssardina:debug(debug).
```
