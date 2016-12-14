:- use_module(library('http/http_client')).
:- use_module(library('http/http_open')).
:- use_module(library('http/json')).
% For xml functions
:- use_module(library('xpath')).
:- use_module(library('sgml')).
 
getgame(GameName,Out) :-
   format(atom(HREF),'http://thegamesdb.net/api/GetGame.php?name=~s',[GameName]),
   http_open(HREF, Xml, []),
   %copy_stream_data(Xml, user_output),
   load_xml(stream(Xml),Out,[]),
   close(Xml).
   
%you can only get the platform information of a game here, not the otherway around.   
getplatformofgame(Game,Platform) :-
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Platform',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Platform',[],[Console]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Console,LConsole),
	downcase_atom(Title,LTitle),
	
	LConsole = Platform,
	LTitle = Game.

	
getdeveloperofgame(Game,Developer) :-	
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Developer',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Developer',[],[Maker]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Maker,LMaker),
	downcase_atom(Title,LTitle),
	
	LMaker = Developer,
	LTitle = Game.
	
getdescriptionofgame(Game, Description) :-
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Overview',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Overview',[],[Description]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Title,LTitle),
	
	LTitle = Game.
	
getplayers(Game, Players) :-
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Players',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Players',[],[Amount]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Amount,LAmount),
	downcase_atom(Title,LTitle),
	
	LAmount = Players,
	LTitle = Game.
	
getpublisher(Game, Publisher) :-
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Publisher',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Publisher',[],[Marketer]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Marketer,LMarketer),
	downcase_atom(Title,LTitle),
	
	LMarketer = Publisher,
	LTitle = Game.

getreleasedate(Game, Releasedate) :-
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'ReleaseDate',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('ReleaseDate',[],[Date]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Date,LDate),
	downcase_atom(Title,LTitle),
	
	LDate = Releasedate,
	LTitle = Game.
	
getratingofgame(Game, Rating) :-
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Rating',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Rating',[],[Rate]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Rate,LRate),
	downcase_atom(Title,LTitle),
	
	LRate = Rating,
	LTitle = Game.
	
showvideoofgame(Game) :-	
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Youtube',X),
	
	
	X = element('Youtube',[],[Url]),
	
	process_create(path(vlc), [Url, 'vlc://quit','--fullscreen'], []).
	
getpictureofgame(Game, F) :-
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(O,//'baseImgUrl',X),
	xpath(P,//'Images',Y),
	
	removehead(Y,F).
	
	%X = element('baseImgUrl',[],[Baseurl]),
	%Y = element('Images',[],[Henk]).
	%atomic_list_concat(List,' ',NewGame).
	%atom_concat(Baseurl,Extendurl,Url).
	
	%process_create(path(vlc), [Url, 'vlc://quit', '--fullscreen'], []).
	

	

itsame :-
		process_create(path(vlc), ['Person.wav', 'vlc://quit', '--qt-start-minimized'], []).

removehead([_|Tail], Tail).
