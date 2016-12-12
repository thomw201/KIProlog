% gamebot.pl

:- use_module(library('http/http_client')).
:- use_module(library('http/http_open')).
:- use_module(library('http/json')).

:- consult([gameinfo]).

category([
	pattern([what,is,your,favourite,video,game,'?']),
	template([my,favourite,video,game,is,any,of,the,mario,games,'!'])
]).

% http://wiki.thegamesdb.net/
game(Game,T) :-
	format(atom(HREF),'http://thegamesdb.net/api/GetGamesList.php?name=',[City]),
	http_get(HREF,Json,[]),
	atom_json_term(Json,json(R),[]),
	member(main=json(W),R), 
	member(temp=T,W).

% http://openweathermap.org/
temperature(City,Temp) :-
 format(atom(HREF),'http://api.openweathermap.org/data/2.5/weather?q=~s',[City]),
 http_get(HREF,Json,[]),
 atom_json_term(Json,json(R),[]),
 member(main=json(W),R),
 member(temp=T,W),
 Temp is round(T - 273.15).

 /****************************************************************************/
% gamebot routine

eliza :-
%	reconsult('eliza.rls'),
	retractall(mem(_)),nl,nl,
        write('Hello. I am gamebot. How can I help you?'),nl,write('> '),
	repeat,
	   read_atomics(Input),nl,
           process_input(Input,[],Input2),
           simplify(Input2,Input3),
           findkeywords(Input3,KeyWords),
           sortkeywords(KeyWords,KeyWords2),
           makecomment(KeyWords2,Input3,Comment),
           flatten(Comment,Comment2),
           writecomment(Comment2),nl,write('> '),
           quittime(Input3),
           !.


:- eliza,nl,nl.

