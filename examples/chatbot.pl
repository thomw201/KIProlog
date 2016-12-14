% chatbot.pl

:- use_module(library('http/http_client')).
:- use_module(library('http/json')).

:- consult([queries]).

:- consult([alice]).

%give description of game
category([
	pattern([star(_),tell,me,about,star(Game),'?']),
	template([Description,think((atomic_list_concat(Game,' ',NewGame),getdescriptionofgame(NewGame, Description)))])
]).

%play the game theme sound
category([
	pattern([star(_),play,the,theme,of,star(Game),'?']),
	template(['Playing', Game, 's , , theme,think((atomic_list_concat(Game,' ',NewGame),playgamesound(NewGame)))])
]).

%give developer of game
category([
	pattern([star(_),developer,of,star(Game),'?']),
	template([Game, was, developed, by, Developer,think((atomic_list_concat(Game,' ',NewGame),getdeveloper(NewGame, Developer)))])
]).

%give playable by x players
category([
	pattern([star(_),how, many,players, star(Game),'?']),
	template([Game,can,be,played,with, Players, think((atomic_list_concat(Game,' ',NewGame),getplayers(NewGame, Players))), players.])
]).

%give publisher of game
category([
	pattern([star(_),publisher,of,star(Game),'?']),
	template([Game, was, published, by, Publisher, think((atomic_list_concat(Game,' ',NewGame),getpublisher(NewGame, Publisher)))])
	%template(['it Worked!',Game])
]).

%give favourite game on the named platform
category([
	pattern([star(_), favourite, game, of,star(Platform),'?']),
	template(['My', favourite, game, on, the, Platform , is , Favgame, think((atomic_list_concat(Game,' ',NewGame),getfavgame(NewGame, Favgame)))]) %highest rated game on platform
]).

%give release date of game
category([
	pattern([star(_), release, date, of,star(Game),'?']),
	template([Game, was released, in, Releasedate,think((atomic_list_concat(Game,' ',NewGame),getreleasedate(NewGame, Releasedate)))])
]).

%get game's rating
category([
	pattern([star(_), rating, of,star(Game),'?']),
	template(['The', rating, of, Game, is, Rating,think((atomic_list_concat(Game,' ',NewGame),getratingofgame(NewGame, Rating)))])
]).

%get favourite x game (example: fav mario game)
category([
	pattern([what, is, your, favourite, star(Game), game,'?']),
	template(['My', favourite, Game, game, is, Favouritegame, '!',think((atomic_list_concat(Game,' ',NewGame),getfavouritegame(NewGame, Favouritegame)))]) %highest rated game with mario in the name
]).

%show picture of game
category([
	pattern([star(_), show, a, picture, of, star(Game),'?']),
	template(['Here', is, a, picture, of, Game, think((atomic_list_concat(Game,' ',NewGame),getpictureofgame(NewGame)))])
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



