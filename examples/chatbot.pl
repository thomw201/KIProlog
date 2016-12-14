% chatbot.pl

:- use_module(library('http/http_client')).
:- use_module(library('http/json')).

:- consult([queries]).

:- consult([alice]).


category([
	pattern([can,you,show,a,video, of,star(Game),'?']),
	template(['Here', is, a, video, of, Game,think((atomic_list_concat(Game,' ',NewGame),showvideoofgame(NewGame)))])
]).


category([
	pattern(['Who',are, you,'?']),
	template([think(itsame)])
	%template(['it Worked!',Game])
]).


category([
	pattern([for,what,platform,is,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getplatformofgame(NewGame,Platform))),Game, has, been, released, on, Platform])
	%template(['it Worked!',Game])
]).



category([
	pattern([quit]),
	template(['Goodbye!', think(break)])
]).

category([
	pattern([star(_)]),
	template([random([
		[so,what,is,your,horoscope,'?'],
		[do,you,like,movies,'?'],
		[do,you,like,dancing,'?']])
	])
]).



