% chatbot.pl

:- use_module(library('http/http_client')).
:- use_module(library('http/json')).

:- consult([queries]).

:- consult([alice]).


category([
	pattern([star(_),tell,me,about,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getdescriptionofgame(NewGame)))])
]).

category([
	pattern([star(_),play,the,theme,of,star(Game),'?']),
	template(['Playing', Game, 's , , theme,think((atomic_list_concat(Game,' ',NewGame),playgamesound(NewGame)))])
]).

category([
	pattern([star(_),developer,of,star(Game),'?']),
	template(['The', developer, of, Game, is, theme,think((atomic_list_concat(Game,' ',NewGame),getdeveloper(NewGame)))])
	%template(['it Worked!',Game])
]).

category([
	pattern([star(_),how, many,players, star(Game),'?']),
	template([Game,can,be,played,with, theme,think((atomic_list_concat(Game,' ',NewGame),getplayers(NewGame))), players.])
]).

category([
	pattern([star(_),publisher,of,star(Game),'?']),
	template([Game, was, published, by, theme,think((atomic_list_concat(Game,' ',NewGame),getpublisher(NewGame)))])
	%template(['it Worked!',Game])
]).

category([
	pattern([star(_), favourite, game, of,star(Platform),'?']),
	template(['My', Game, 's , , theme,think((atomic_list_concat(Game,' ',NewGame),getfavgame(NewGame)))]) %misschien game met hoogste rating?
]).

category([
	pattern([star(_), release, date, of,star(Game),'?']),
	template([Game, was released, in, theme,think((atomic_list_concat(Game,' ',NewGame),getreleasedate(NewGame)))])
]).

category([
	pattern([star(_), rating, of,star(Game),'?']),
	template(['The', rating, of, Game, is, theme,think((atomic_list_concat(Game,' ',NewGame),getratingofgame(NewGame)))])
]).

category([
	pattern([what, is, your, favourite, star(Game), game,'?']),
	template(['The', rating, of, Game, is, theme,think((atomic_list_concat(Game,' ',NewGame),getfavouritegame(NewGame)))])
]).

category([
	pattern([star(_), show, a, picture, of, star(Game),'?']),
	template(['Here', is, a, picture, of, Game, theme,think((atomic_list_concat(Game,' ',NewGame),getpictureofgame(NewGame)))])
]).

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



