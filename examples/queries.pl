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
	
showvideoofgame(Game) :-	
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Youtube',X),
	
	X = element('Youtube',[],[Url]),
	
	process_create(path(vlc), [Url, 'vlc://quit'], []).
	

	

itsame :-
		process_create(path(vlc), ['Person.wav', 'vlc://quit', '--qt-start-minimized'], []).

