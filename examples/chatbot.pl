% chatbot.pl

:- use_module(library('http/http_client')).
:- use_module(library('http/json')).

:- consult([alice]).

category([
	pattern([can,you,star(A),'?']),
	template(['I', 'don''t', really, know, if,'I','can', A,
		but,'I''m', very, good, at, swimming])
]).

category([
	pattern([Do,you,eat,pudding,'?']),
	template(['No', but , you, do, '!'])
]).

category([
	pattern([who,is,alan,turing,'?']),
	template(['Alan Mathison Turing',was,a,'British',mathematician,',',logician,',',cryptanalyst,',',philosopher,',',computer,scientist,',',mathematical,biologist,',',and,marathon,and,ultra,distance,runner,'.'])
]).

category([
	pattern([do,you,know,who,star(A),is,'?']),
	template([srai([who,is,A,'?'])])
]).

category([
	pattern([yes]),
	that([do, you, like, movies,'?']),
	template(['What', is, your, favourite, movie, '?'])
]).

category([
	pattern([star(_),always,star(_)]),
	template(['Can',you,think,of,a,specific,example,'?'])
]).

category([
	pattern([how,much,is,star([A]),plus,star([B]),'?']),
	template([think((C is A + B)),A,plus,B,is,C])
]).

category([
	pattern([star(_),temperature,star(_),in,star([City]),'?']),
	template([think(temperature(City,Temp)),
	    'The',temperature,in,City,is,Temp,degrees,celcius,'.'])
]).

category([
	pattern([is,star([Person]),female,'?']),
	template([think(female(Person)),'Yes, ',she,is,'!'])
]).

category([
	pattern([is,star([Person]),female,'?']),
	template([think(not(female(Person))),'No, ',Person,is,not,female])
]).

category([
	pattern([who,is,the,father,of,star([Person]),'?']),
	template([think(father_of(Father,Person)),Father,is,the,father,of,Person])
]).

category([
	pattern([star(_),sound,star(_)]),
	template(['Okay!',
		think(process_create(path(play), ['emergency.mp3'], [stderr(null)]))])
]). 

category([
	pattern([are,you,afraid,of,syntax(np,NP),'?']),
	template(['Why',would,'I',be,afraid,of,NP,'?!'])
]).

category([
	pattern([star(_)]),
	template([random([
		[so,what,is,your,horoscope,'?'],
		[do,you,like,movies,'?'],
		[do,you,like,dancing,'?']])
	])
]).

% Family tree
female(helen).
female(ruth).
female(petunia).
female(lili).

male(paul).
male(albert).
male(vernon).
male(james).
male(dudley).
male(harry).

parent_of(paul,petunia).
parent_of(helen,petunia).
parent_of(paul,lili).
parent_of(helen,lili).
parent_of(albert,james).
parent_of(ruth,james).
parent_of(petunia,dudley).
parent_of(vernon,dudley).
parent_of(lili,harry).
parent_of(james,harry).

% Fathers are male parent and mothers are female parents.
father_of(X,Y) :- male(X),
                  parent_of(X,Y).
mother_of(X,Y) :- female(X),
                  parent_of(X,Y).

% http://openweathermap.org/
temperature(City,Temp) :-
	format(atom(HREF),'http://api.openweathermap.org/data/2.5/weather?q=~s',[City]),
	http_get(HREF,Json,[]),
	atom_json_term(Json,json(R),[]),
	member(main=json(W),R), 
	member(temp=T,W), 
	Temp is round(T - 273.15).

np --> art, noun.

art --> [the];[a];[an].

noun --> [cat];[dog];[mouse];[rat];[table].

