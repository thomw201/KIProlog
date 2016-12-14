% chatbot.pl

:- use_module(library('http/http_client')).
:- use_module(library('http/json')).

:- consult([queries]).

:- consult([alice]).

%give description of game
category([
	pattern([star(_),tell,me,about,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getdescriptionofgame(NewGame, Description))),Description])
]).

%give developer of game
category([
	pattern([star(_),developer,of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getdeveloper(NewGame, Developer))),Game, was, developed, by, Developer])
]).

%give playable by x players
category([
	pattern([star(_),how, many,players, star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getplayers(NewGame, Players))),NewGame,can,be,played,with, Players, players, '.'])
]).

%give publisher of game
category([
	pattern([star(_),publisher,of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getpublisher(NewGame, Publisher))),Game, was, published, by, Publisher])
]).

%give favourite game on the named platform
category([
	pattern([star(_), favourite, game, of,star(Platform),'?']),
	template([think((atomic_list_concat(Platform,' ',NewPlatform),getfavgame(NewPlatform, Favgame))),'My', favourite, game, on, the, Platform , is , Favgame]) %highest rated game on platform
]).

%give release date of game
category([
	pattern([star(_), release, date, of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getreleasedate(NewGame, Releasedate))),Game, was, released, in, Releasedate,'.'])
]).

%get game's rating
category([
	pattern([star(_), rating, of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getratingofgame(NewGame, Rating))),'The', rating, of, Game, is, Rating])
]).

%get favourite x game (example: fav mario game)
category([
	pattern([what, is, your, favourite, star(Game), game,'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getfavouritegame(NewGame, Favouritegame))),'My', favourite, Game, game, is, Favouritegame, '!']) %highest rated game with mario in the name
]).

%show picture of game
category([
	pattern([star(_), show, a, picture, of, star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getpictureofgame(NewGame))),'Here', is, a, picture, of, Game])
]).

%show a video of game
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



