% chatbot.pl

:- use_module(library('http/http_client')).
:- use_module(library('http/json')).

:- consult([queries]).

:- consult([alice]).

%give description of game
category([
	pattern([star(_),tell,me,about,star(Game),star(_)]),
	template([think((atomic_list_concat(Game,' ',NewGame),getdescriptionofgame(NewGame, Description))),Description])
]).


%ask if user wants more info
category([
    pattern([star(_),information,star(_)]),
    template(['Do',you,want,information,about,a,game,'?'])
]).

%user said yes, ask the game name
category([
    pattern([yes]),
    that(['Do',you,want,information,about,a,game,'?']),
    template(['Which',game,do,you,want,to,know,more,about,'?'])
]).

%give information according to the given game name
category([
    pattern([star(A)]),
    that(['Which',game,do,you,want,to,know,more,about,'?']),
    template([think((atomic_list_concat(A,' ',NewGame),getdescriptionofgame(NewGame, Description))),Description])
	%template(['it Worked!', A])
]).

%user said no, ask if he wants other information
category([
    pattern([no]),
    that(['Do',you,want,information,about,a,game,'?']),
    template(['Do',you,want,information,about,a,console,'?'])
]).

%user wants more console info, ask which console
category([
    pattern([yes]),
    that(['Do',you,want,information,about,a,console,'?']),
    template(['Which',console,do,you,want,to,know,more,about,'?'])
]).

%give information according to the given console name
category([
    pattern([star(A)]),
    that(['Which',console,do,you,want,to,know,more,about,'?']),
    template([think((atomic_list_concat(A,' ',ConsoleName),getdescriptionofconsole(ConsoleName, Description))), Description])
]).

%user said no
category([
    pattern([no]),
    that(['Which',console,do,you,want,to,know,more,about,'?']),
    template(['Ask',me,anytime,'!'])
]).

%give developer of game
category([
	pattern([star(_),developer,of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getdeveloperofgame(NewGame, Developer))),Game, was, developed, by, Developer])
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
	template([think((atomic_list_concat(Game,' ',NewGame),getreleasedate(NewGame, Releasedate))),Game, was, released, on, Releasedate,'.'])
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

%user told me his favourite video game
category([
    pattern([star(A)]),
    that(['What',is,your,favourite,video,game,'?']),
    template(['I',agree,'!',A,is,awesome,'!'])
]).

%user awnsers yes to a video
category([
    pattern([yes]),
    that(['Do',you,want,to,see,a,video,'?']),
    template(['What',game,video,do,you,want,me,to,play,for,you,'?'])
]).


category([
    pattern([star(A)]),
    that(['What',game,video,do,you,want,me,to,play,for,you,'?']),
    template(['Here', is, a, video, of, A,think((atomic_list_concat(A,' ',NewGame),showvideoofgame(NewGame)))])
]).

category([
	pattern([quit]),
	template(['Goodbye!', think(break)])
]).

category([
	pattern([star(_)]),
	template([random([
		['Do',you,want,information,about,a,game,'?'],
		['Do',you,want,information,about,a,console,'?'],
		['What',is,your,favourite,video,game,'?'],
		['Do',you,want,to,see,a,video,'?'],
		['Do',you,like,mario,'?']])
	])
]).



