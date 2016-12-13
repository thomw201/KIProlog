% chatbot.pl

:- use_module(library('http/http_client')).
:- use_module(library('http/json')).

:- consult([alice]).

:- dynamic timezone_of/2.

%==================================== TESTBLOCK

category([
    pattern([time,star([C]),'?']),
    template([think(timezone_of(T,C)),country,C,time,T,'.'])
]).

%==================================== TESTBLOCK

category([
    pattern([what,time,is,it,'?']),
    template([think(current_time(H,M)),'It',is,currently,H,':',M,'UTC','1','.'])
]).

category([
    pattern([star(_),the,star(_),time,'?']),
    template([srai([what,time,is,it,'?'])])
]).

category([
    pattern([add,a,city]),
    template(['Would',you,like,to,add,a,city,'?'])
]).

category([
    pattern([yes]),
    that(['Would',you,like,to,add,a,city,'?']),
    template(['Enter',the,city,and,then,the,timezone,in,'UTC','.'])
]).

category([
    pattern([city,star([A]),timezone,star([B])]),
    that(['Enter',the,city,and,then,the,timezone,in,'UTC','.']),
    template([think(add_timezone(B,A)),'Added',city,A,with,timezone,B,'.'])
]).

category([
    pattern([no]),
    that(['Would',you,like,to,add,a,city,'?']),
    template(['Not',adding,a,city,'.'])
]).

category([
    pattern([what,time,is,it,in,star([C]),'?']),
    template([think(get_relative_time(C,T,M)),think(timezone_of(TZ,C)),'The',time,in,C,is,T,':',M,'UTC',TZ,'.'])
]).

category([
    pattern([what,is,the,time,difference,between,star([A]),and,star([B]),'?']),
    template([think(timezone_of(TZ,A)),think(timezone_of(TZ2,B)),think(TZ3 is TZ - TZ2),think(TZ4 is abs(TZ3)),'The',difference,between,B,and,A,is,TZ4,hours,'.'])
]).

category([
    pattern([list,all,cities]),
    template([think(foreach(timezone_of(A,B),(write(A),write(B))))])
]).

category([
    pattern(['How',long,until,midnight,in,star([C]),'?']),
    template([think(get_relative_time(C,T,M)),think(TZ is 23 - T),think(MZ is (59 - M)+1),'It',will,be,midnight,in,TZ,hours,and,MZ,minutes,'.'])
]).

category([
    pattern([what,time,is,it,in,star([A]),if,it,is,midnight,in,star([B]),'?']),
    template([think(timezone_of(TB,B)),think(timezone_of(TA,A)),think(T is 24 - (abs(TA - TB))),'It',is,T,':','00',in,A,if,it,is,midnight,in,B,'.'])
]).

% Countries and cities are within a UTC timezone.
timezone_of(-5,newyork).
timezone_of(9,tokyo).
timezone_of(1,localtime).
timezone_of(8,hongkong).
timezone_of(3,bagdad).

time_of_day(morning,5,12).
time_of_day(afternoon,12,17).
time_of_day(evening,17,21).
time_of_day(night,21,5).


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

%current_time(_,_).
current_time(H,M) :-
    get_time(TS),
    stamp_date_time(TS,Date9,'local'),
    arg(4,Date9,H),
    arg(5,Date9,M).


if_overmidnight(T,NT) :-
    (T > 23 -> NT is T - 24; NT is T).

add_timezone(A,B) :-
    asserta(timezone_of(A,B)).

get_relative_time(C,T,M) :-
    current_time(H,M),
    timezone_of(A,localtime),
    timezone_of(B,C),
    T is H - A + B.
    
