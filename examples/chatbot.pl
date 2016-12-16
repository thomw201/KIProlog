% chatbot.pl

:- use_module(library('http/http_client')).
:- use_module(library('http/json')).

:- consult([queries]).
:- consult([playsounds]).
:- consult([alice]).

start :-
	startup,
    write('Hello, I am a gamebot.'), nl,
    write('Ask me any game-related question!'), nl,
loop.

%give information according to the given console name
category([
    pattern([star(_),tell,me,about,the,star(A),'?']),
    template([think((atomic_list_concat(A,' ',ConsoleName),getdescriptionofconsole(ConsoleName, Description))), Description])
]).

%cant give description of console
category([
	pattern([star(_),tell,me,about,the,star(A),'?']),
	template([think((atomic_list_concat(A,' ',ConsoleName),not(getdescriptionofconsole(ConsoleName, _)))),'Sorry,','I', do,not,know,that,platform, '.', 'Did',you,spell,it,correctly,'?'])
]).


%give description of game
category([
	pattern([star(_),tell,me,about,star(Game),star(_)]),
	template([think((atomic_list_concat(Game,' ',NewGame),getdescriptionofgame(NewGame, Description))),Description])
]).

%cant give description of game
category([
	pattern([star(_),tell,me,about,star(Game),star(_)]),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getdescriptionofgame(NewGame, _)))),'Sorry,','I', do,not,know,that,game, '.', 'Did',you,spell,it,correctly,'?'])
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

%cannot information according to the given game name
category([
	pattern([star(A)]),
    that(['Which',game,do,you,want,to,know,more,about,'?']),
	template([think((atomic_list_concat(A,' ',NewGame),not(getdescriptionofgame(NewGame, _)))),'Sorry,', 'I', have,never,heard,of,A,'.'])
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

%cannot give console info
category([
	pattern([star(A)]),
    that(['Which',console,do,you,want,to,know,more,about,'?']),
	template([think((atomic_list_concat(A,' ',NewGame),not(getdescriptionofgame(NewGame, _)))),'Sorry,', 'I', do,not,know,what,the,A,is,'.'])
]).




%give developer of game
category([
	pattern([star(_),developer,of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getdeveloperofgame(NewGame, Developer))),Game, was, developed, by, Developer])
]).

%give developer of game
category([
	pattern([star(_),developer,of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getdeveloperofgame(NewGame, _)))),'Sorry,','I', do, not, know, who, the, developer, of, NewGame, is,'.'])
]).

%give playable by x players
category([
	pattern([star(_),how, many,players,can,you,play, star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getplayers(NewGame, Players))),NewGame,can,be,played,with, Players, players, '.'])
]).

%can't give playable players
category([
	pattern([star(_),how, many,players,can,you,play, star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getplayers(NewGame, _)))),'Sorry,','I', do, not, know, any, game,named,NewGame,'.'])
]).

%give publisher of game
category([
	pattern([star(_),publisher,of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getpublisher(NewGame, Publisher))),Game, was, published, by, Publisher])
]).

%can't give publisher
category([
	pattern([star(_),publisher,of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getpublisher(NewGame, _)))),'Sorry,','I', do, not, know, any, game,named,NewGame,'.'])
]).

%give favourite game on the named platform
category([
	pattern([star(_), favourite, game, on,the,star(Platform),'?']),
	template([think((atomic_list_concat(Platform,' ',NewPlatform),getfavplatformgame(NewPlatform, Favgame))),'My', favourite, game, on, the, Platform , is , Favgame]) %highest rated game on platform
]).

%can't fav game of console
category([
	pattern([star(_), favourite, game, on,the,star(Platform),'?']),
	template([think((atomic_list_concat(Platform,' ',NewPlatform),not(getfavplatformgame(NewPlatform, _)))),'Sorry,','I', do, not, know,what,the, Platform,is,'.', 'Did',you,spell,it,correctly,'?'])
]).

%give release date of game
category([
	pattern([star(_), release, date, of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getreleasedate(NewGame, Releasedate))),Game, was, released, on, Releasedate,'.'])
]).

%can't give release date
category([
	pattern([star(_), release, date, of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getreleasedate(NewGame, _)))),'Sorry,','I', do, not, know, any, game,named,NewGame,'.'])
]).

%give release date of game 
category([
	pattern([star(_),was,star(Game), released,'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getreleasedate(NewGame, Releasedate))),Game, was, released, on, Releasedate,'.'])
]).

%can't give release date
category([
	pattern([star(_),was,star(Game), released,'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getreleasedate(NewGame, _)))),'Sorry,','I', do,not,know,that,game, '.', 'Did',you,spell,it,correctly,'?'])
]).

%get game's rating
category([
	pattern([star(_), rating, of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getratingofgame(NewGame, Rating))),Game,has,a,rating,of, Rating])
]).

%can't give game rating
category([
	pattern([star(_), rating, of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getratingofgame(NewGame, _)))),'Sorry,','I', cannot,give,you,the,rating,because,'I',do,not,know,any,game,named,Game,'.'])
]).

% give highest rated x game
category([
	pattern([star(_), highest, rated, star(Game), game,'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),gethighestrating(NewGame,GameTitle,Rating))), 'The', highest, rated, Game,game, is, GameTitle,with,a,rating,of,Rating,'!'])
]).

%can't give highest rated x game
category([
	pattern([star(_), highest, rated, star(Game), game,'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(gethighestrating(NewGame,_,_)))),'Sorry,','I', cannot,give,you,the,rating,because,'I',do,not,know,any,'game(s)',named,Game,'.'])
]).

%show picture of game
category([
	pattern([star(_), picture, of, star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),showpicturesofgame(NewGame))),'Here', are, some, pictures, of, Game, '.'])
]).

%can't give picture
category([
	pattern([star(_), picture, of, star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(showpicturesofgame(NewGame)))),'Sorry,','I', cannot,give,you,any,pictures,because,'I',do,not,know,any,'game(s)',named,Game,'.'])
]).

%show a video of game
category([
	pattern([star(_),video, of,star(Game),'?']),
	template(['Here', is, a, video, of, Game,think((atomic_list_concat(Game,' ',NewGame),showvideoofgame(NewGame)))])
]).

%can't show video
category([
	pattern([star(_),video, of,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(showvideoofgame(NewGame)))),'Sorry,','I', do,not,know,any,Game,game, '.', 'Did',you,spell,it,correctly,'?'])
]).

category([
	pattern(['Who',are, you,'?']),
	template([think(itsame)])
]).

%give platform of game
category([
	pattern([star(_),what,platform,is,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getplatformofgame(NewGame,Platform))),Game, has, been, released, on, Platform])
]).

%cant give platform
category([
	pattern([star(_),what,platform,is,star(Game),'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getplatformofgame(NewGame,_)))),'Sorry,','I', do,not,know,that,game, '.', 'Did',you,spell,it,correctly,'?'])
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

%user said the name of the game/video he wants to see
category([
    pattern([star(A)]),
    that(['What',game,video,do,you,want,me,to,play,for,you,'?']),
    template(['Here', is, a, video, of, A,think((atomic_list_concat(A,' ',NewGame),showvideoofgame(NewGame)))])
]).

%cant give the video
category([
	pattern([star(A)]),
	that(['What',game,video,do,you,want,me,to,play,for,you,'?']),
	template([think((atomic_list_concat(A,' ',NewGame),not(showvideoofgame(NewGame)))),'Sorry,','I', cannot,show,a,video,because,'I',do,not,know,that,game, '.', 'Did',you,spell,it,correctly,'?'])
]).

%user wants to know the developer of a game
category([
    pattern([yes]),
    that(['Would',you,like,to,know,the,developer,of,any,game,'?']),
    template(['Okay,',tell,me,the,title,of,the,game,'!'])
]).

%user wants to know the developer of a game
category([
    pattern([star(A)]),
    that(['Okay,',tell,me,the,title,of,the,game,'!']),
    template([think((atomic_list_concat(A,' ',NewGame),getdeveloperofgame(NewGame, Developer))),A, was, developed, by, Developer,'.'])
]).

%cant give the developer
category([
	pattern([star(A)]),
	that(['Okay,',tell,me,the,title,of,the,game,'!']),
	template([think((atomic_list_concat(A,' ',NewGame),not(getdeveloperofgame(NewGame, _)))),'Sorry,','I', cannot,give,you,a,developer,because,'I',do,not,know,any,game,named,A,'.'])
]).

%user wants to know the rating of a game
category([
    pattern([yes]),
    that(['Would',you,like,to,know,the,rating,of,a,game,'?']),
    template(['Okay,',what,is,the,title,of,the,game,'?'])
]).

%user wants to know the rating of a game
category([
    pattern([star(Game)]),
    that(['Okay,',what,is,the,title,of,the,game,'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),getratingofgame(NewGame, Rating))),'The', rating, of, Game, is, Rating])
]).

%cant give the rating
category([
    pattern([star(Game)]),
    that(['Okay,',what,is,the,title,of,the,game,'?']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getratingofgame(NewGame, _)))),'Sorry,','I', cannot,give,you,the,rating,because,'I',do,not,know,any,game,named,Game,'.'])
]).

%user wants to know the publisher of a game
category([
    pattern([yes]),
    that(['Would',you,like,to,know,the,publisher,of,a,game,'?']),
    template(['So,',tell,me,the,title,of,the,game,'!'])
]).

%user wants to know the publisher of a game
category([
    pattern([star(Game)]),
    that(['So,',tell,me,the,title,of,the,game,'!']),
	template([think((atomic_list_concat(Game,' ',NewGame),getpublisher(NewGame, Publisher))),Game, was, published, by, Publisher])
]).

%cant give the publisher
category([
    pattern([star(Game)]),
    that(['So,',tell,me,the,title,of,the,game,'!']),
	template([think((atomic_list_concat(Game,' ',NewGame),not(getratingofgame(NewGame, _)))),'Sorry,','I', cannot,give,you,the,publisher,because,'I',do,not,know,any,game,named,Game,'.'])
]).

category([
	pattern([quit]),
	template(['Goodbye!', think(break)])
]).

%user said no. Offer more help about any question!
category([
    pattern([no, star(_)]),
    %template(['Okay!',if,you,have,any,game,related,'questions,',just,ask,'!'])
		template([random([
		['Okay!','If',you,have,any,game,related,'questions,',just,ask,'!'],
		['Please',ask,me,any,game,related,question,'!'],
		[':(',ask,me,something,about,'ANY',game,'!'],
		['Anything',else,'?'],
		['Ok','!',feel,free,to,ask,me,more,game,questions,'.']])
	])
]).

%user thanked you for something, be nice!
category([
    pattern([thanks,star(_)]),
		template([random([
		['Happy',to,help,'!'],
		['My',pleasure,'!'],
		['No',problem,'!'],
		['Anytime','!'],
		['Can','I',help,you,with,anything,else,'?']])
	])
]).

%user thanked you for something, be nice!
category([
    pattern([thank,you,star(_)]),
		template([random([
		['Happy',to,help,'!'],
		['My',pleasure,'!'],
		['No',problem,'!'],
		['Anytime','!'],
		['Can','I',help,you,with,anything,else,'?']])
	])
]).

category([
	pattern([star(_)]),
	template([random([
		['Do',you,want,information,about,a,game,'?'],
		['Do',you,want,information,about,a,console,'?'],
		['What',is,your,favourite,video,game,'?'],
		['Do',you,want,to,see,a,video,'?'],
		['Would',you,like,to,know,the,developer,of,any,game,'?'],
		['Would',you,like,to,know,the,rating,of,a,game,'?'],
		['Would',you,like,to,know,the,publisher,of,a,game,'?'],
		['Do',you,want,to,know,the,release,date,of,a,game,'?'],
		['Do',you,like,'Mario','?']])
	])
]).



