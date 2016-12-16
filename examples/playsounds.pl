itsame :-
		process_create(path(vlc), ['Sounds/Person.wav', 'vlc://quit', '--qt-start-minimized'], []).
		
bestgame :-
		process_create(path(vlc), ['Sounds/Melee!!!.wav', 'vlc://quit', '--qt-start-minimized'], []).
		
foundit :-
		process_create(path(vlc), ['Sounds/Foundit.wav', 'vlc://quit', '--qt-start-minimized'], []).
		
heylisten :-
		process_create(path(vlc), ['Sounds/hey_listen.mp3', 'vlc://quit', '--qt-start-minimized'], []).
		
startup :-
		process_create(path(vlc), ['Sounds/Startup.mp3', 'vlc://quit', '--qt-start-minimized'], []).