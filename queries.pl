:- use_module(library('http/http_client')).
:- use_module(library('http/http_open')).
:- use_module(library('http/json')).
% For xml functions
:- use_module(library('xpath')).
:- use_module(library('sgml')).
 
%Get the xml output for a game using an approximation of the gametitle
getgame(GameName,Out) :-
   split_string(GameName, " ", "", Words),
   atomic_list_concat(Words, '%20', UrlGameName),
   format(atom(HREF),'http://thegamesdb.net/api/GetGame.php?name=~s',[UrlGameName]),
   http_open(HREF, Xml, []),
   %copy_stream_data(Xml, user_output),
   load_xml(stream(Xml),Out,[]),
   close(Xml).

%Get the xml output for a game using the exact the gametitle 
getexactgame(GameName,Out) :-
   split_string(GameName, " ", "", Words),
   atomic_list_concat(Words, '%20', UrlGameName),
   format(atom(HREF),'http://thegamesdb.net/api/GetGame.php?exactname=~s',[UrlGameName]),
   http_open(HREF, Xml, []),
   %copy_stream_data(Xml, user_output),
   load_xml(stream(Xml),Out,[]),
   close(Xml).
 
%get a list of X games.
getgamelist(GameName,Out) :-
   format(atom(HREF),'http://thegamesdb.net/api/GetGamesList.php?name=~s',[GameName]),
   http_open(HREF, Xml, []),
   %copy_stream_data(Xml, user_output),
   load_xml(stream(Xml),Out,[]),
   close(Xml).

%get a list of all platforms.
getplatformlist(Out):-
   http_open('http://thegamesdb.net/api/GetPlatformsList.php', Xml, []),
   %copy_stream_data(Xml, user_output),
   load_xml(stream(Xml),Out,[]),
   close(Xml).

%Get X platform. 
getplatform(ID,Out):-
   format(atom(HREF),'http://thegamesdb.net/api/GetPlatform.php?id=~s',[ID]),
   http_open(HREF, Xml, []),
   %copy_stream_data(Xml, user_output),
   load_xml(stream(Xml),Out,[]),
   close(Xml).

%Get list of all games for X platform.   
getplatformgamelist(ID,Out):-
   format(atom(HREF),'http://thegamesdb.net/api/GetPlatformGames.php?platform=~s',[ID]),
   http_open(HREF, Xml, []),
   %copy_stream_data(Xml, user_output),
   load_xml(stream(Xml),Out,[]),
   close(Xml).  
   
%you can only get the platform information of a game here, not the otherway around.   
getplatformofgame(Game,Platform) :-
	getexactgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Platform',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Platform',[],[Console]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Console,LConsole),
	downcase_atom(Title,LTitle),
	downcase_atom(Game,LGame),
	
	LConsole = Platform,
	LTitle = LGame.

%get developer for X game.
getdeveloperofgame(Game,Developer) :-	
	getexactgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Developer',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Developer',[],[Maker]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Maker,LMaker),
	downcase_atom(Title,LTitle),
	
	LMaker = Developer,
	LTitle = Game.

%get description for X game.	
getdescriptionofgame(Game, Description) :-
	getexactgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Overview',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Overview',[],[Description]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Title,LTitle),
	downcase_atom(Game,LGame),
	
	LTitle = LGame.

%get amount of players for X game.	
getplayers(Game, Players) :-
	getexactgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Players',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Players',[],[Amount]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Amount,LAmount),
	downcase_atom(Title,LTitle),
	
	LAmount = Players,
	LTitle = Game.

%get publisher for X game.	
getpublisher(Game, Publisher) :-
	getexactgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Publisher',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Publisher',[],[Marketer]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Marketer,LMarketer),
	downcase_atom(Title,LTitle),
	
	LMarketer = Publisher,
	LTitle = Game.

%Get release date of X game.	
getreleasedate(Game, Releasedate) :-
	getexactgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'ReleaseDate',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('ReleaseDate',[],[Date]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Date,LDate),
	downcase_atom(Title,LTitle),
	
	LDate = Releasedate,
	LTitle = Game.

%Get rating of X game.	
getratingofgame(Game, Rating) :-
	getexactgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Rating',X),
	xpath(P,//'GameTitle',Y),
	
	X = element('Rating',[],[Rate]),
	Y = element('GameTitle',[],[Title]),
	
	downcase_atom(Rate,LRate),
	downcase_atom(Title,LTitle),
	
	LRate = Rating,
	LTitle = Game.

%Get id for X platform.	
getplatformid(Console,ID):-
	getplatformlist(O),
		
	xpath(O,//'Platforms',P),
	xpath(P,//'Platform',X),
	xpath(X,//'name',Y),
	xpath(X,//'id',Z),
	
	Y = element('name',[],[ConsoleName]),
	atom_length(Console,Length),
	downcase_atom(Console,LConsole),
	downcase_atom(ConsoleName,LConsoleName),
	sub_string(LConsoleName, _, Length, _, LConsole),
	Z = element('id',[],[ID]).

%Get the rating for a X game using the exact name.
getratingofexactgameandname(Game,GameTitleandRating) :-
	getexactgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Rating',X),
	xpath(P,//'GameTitle',Y),
	
	
	X = element('Rating',[],[Rating]),
	Y = element('GameTitle',[],[Title]),
	
	atom_number(Rating, IntRating),
	
	GameTitleandRating = [IntRating,Title].

%Get rating for a platform 	
getratingplatformgame(Platform,GameTitleandRating):-
	getplatformid(Platform,ID),
	getplatformgamelist(ID,Out),
	xpath(Out,//'Game' ,P),
	xpath(P,//'GameTitle' ,element('GameTitle',[],[GameTitle])),
	getratingofexactgameandname(GameTitle,GameTitleandRating).

%Get highest rated X platform game	
gethighestratingplatform(Platform,GameTitle,Rating)	:-
	findall(G,getratingplatformgame(Platform,G),All),
	sort(0,@>=,All,[[Rating,GameTitle]|_]).	

%Get the rating of a game and the name	
getratingofgameandname(Game,GameTitleandRating) :-
	getgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Rating',X),
	xpath(P,//'GameTitle',Y),
	
	
	X = element('Rating',[],[Rating]),
	Y = element('GameTitle',[],[Title]),
	
	atom_number(Rating, IntRating),
	
	GameTitleandRating = [IntRating,Title].
	
%Get the highest rated X game.	
gethighestrating(Game,GameTitle,Rating)	:-
	findall(G,getratingofgameandname(Game,G),All),
	sort(0,@>=,All,[[Rating,GameTitle]|_]).

%Get description of a console	
getdescriptionofconsole(Console,Description) :-
	getplatformlist(O),
		
	xpath(O,//'Platforms',P),
	xpath(P,//'Platform',X),
	xpath(X,//'name',Y),
	xpath(X,//'id',Z),
	
	Y = element('name',[],[ConsoleName]),
	atom_length(Console,Length),
	downcase_atom(Console,LConsole),
	downcase_atom(ConsoleName,LConsoleName),
	sub_string(LConsoleName, _, Length, _, LConsole),
	Z = element('id',[],[ID]),
	 
	getplatform(ID,O2),
	xpath(O2,//'Platform',Platform),
	xpath(Platform,//'overview',Overview),
	
	Overview = element('overview',[],[Description]).

	
	
	
%Show a video of X game.	
showvideoofgame(Game) :-	
	getexactgame(Game,O),
	xpath(O,//'Game',P),
	xpath(P,//'Youtube',X),
	
	
	X = element('Youtube',[],[Url]),
	
	process_create(path(vlc), [Url, 'vlc://quit','--fullscreen','--no-video-title-show'], []).

%Show picture of X game.
getpictureofgame(Game, Url) :-
         getexactgame(Game,O),
         xpath(O,//'Game',P),
         xpath(O,//'baseImgUrl',element('baseImgUrl',[],[Baseurl])),
         xpath(P,//'Images'/screenshot/original ,element(original,_,[Extendurl])),
		 atom_concat(Baseurl,Extendurl,Url).

%Get picture of game.		 
getpictureofgame(Game, Url) :-
         getexactgame(Game,O),
         xpath(O,//'Game',P),
         xpath(O,//'baseImgUrl',element('baseImgUrl',[],[Baseurl])),
         xpath(P,//'Images'/boxart,element(boxart,_,[Extendurl])),
		 atom_concat(Baseurl,Extendurl,Url).

%Get picture of game.		 
getpictureofgame(Game, Url) :-
         getexactgame(Game,O),
         xpath(O,//'Game',P),
         xpath(O,//'baseImgUrl',element('baseImgUrl',[],[Baseurl])),
         xpath(P,//'Images'/banner,element(banner ,_,[Extendurl])),
		 atom_concat(Baseurl,Extendurl,Url).

%Get picture of X game.		 
getpictureofgame(Game, Url) :-
         getexactgame(Game,O),
         xpath(O,//'Game',P),
         xpath(O,//'baseImgUrl',element('baseImgUrl',[],[Baseurl])),
         xpath(P,//'Images'/fanart/orginal,element(orginal,_,[Extendurl])),
		 atom_concat(Baseurl,Extendurl,Url).

		 
		 
%show all pictures of game.		 
showpicturesofgame(Game) :-
	findall(G,getpictureofgame(Game,G),All),
	append(All,['vlc://quit','--fullscreen','--no-video-title-show'],Arg),
	process_create(path(vlc), Arg, []).
		

