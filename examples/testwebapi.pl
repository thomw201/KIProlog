:- use_module(library('http/http_client')).
:- use_module(library('http/http_open')).
:- use_module(library('http/json')).
% For xml functions
:- use_module(library('xpath')).
:- use_module(library('sgml')).

username('aswin_f@hotmail.com').
password('EXObqXHVjyB_7I9awF3zyWQSvRmfuERW_3kqDuS2oSOiG5YToO-uQg').

% http://openweathermap.org/
temperature(City,Temp) :-
 format(atom(HREF),'http://api.openweathermap.org/data/2.5/weather?q=~s',[City]),
 http_get(HREF,Json,[]),
 atom_json_term(Json,json(R),[]),
 member(main=json(W),R),
 member(temp=T,W),
 Temp is round(T - 273.15).
 
testerino(City, Out) :-
 username(U), password(P),
 format(atom(HREF),'http://webservices.ns.nl/ns-api-avt?station=~s',[City]),
 http_open(HREF,Xml,[authorization(basic(U,P))]),
 copy_stream_data(Xml, user_output),
 close(Xml).

% http://www.ns.nl/api/api
% http://webservices.ns.nl/ns-api-avt?station=${Naam of afkorting Station}
trains_from(City, Out) :-
 username(U), password(P),
 format(atom(HREF),'http://webservices.ns.nl/ns-api-avt?station=~s',[City]),
 http_open(HREF,Xml,[authorization(basic(U,P))]),
 copy_stream_data(Xml, user_output),
 load_xml(stream(Xml), Out, []),
 close(Xml).

next_train_from_to(From,To,Time) :-
 trains_from(From,O), 
 xpath(O,//'VertrekkendeTrein',P), 
 xpath(P,//'EindBestemming',Q), 
 Q = element('EindBestemming',[],[City]),
 downcase_atom(City,LCase),
 LCase = To,
 xpath(P,//'VertrekTijd',element('VertrekTijd', [], [Time])).

% http://www.omdbapi.com/
director(Name, Result) :-
        format(atom(HREF), 'http://www.omdbapi.com?t=~s', [Name]),
        http_get(HREF,Json,[]),
        atom_json_term(Json, json(R),[]),
        member('Director'=Result,R).

% http://fixer.io/
exchange(From,To,Amount,Result) :-
        upcase_atom(From,UFrom), upcase_atom(To,UTo),
        format(atom(HREF), 'http://api.fixer.io/latest?base=~s&symbols=~s', [UFrom,UTo]),
        http_get(HREF,Json,[]),
        atom_json_term(Json,json(R),[]),
        member(rates=json([_W=Value]),R),
        Result is Value * Amount.

% http://ip-api.com/docs/
geoIP(Country,City,Region,Zip,Lat,Lon) :-
        http_get('http://ip-api.com/json',Json,[]),
        atom_json_term(Json,json(R),[]),
        member('city'=City,R),
        member('country'=Country,R),
        member('regionName'=Region,R),
        member('zip'=Zip,R),
        member('lat'=Lat,R),
        member('lon'=Lon,R).

geoIP(IP,Country,City,Region,Zip,Lat,Lon) :-
        format(atom(HREF),'http://ip-api.com/json/~s',[IP]),
        http_get(HREF,Json,[]),
        atom_json_term(Json,json(R),[]),
        member('city'=City,R),
        member('country'=Country,R),
        member('regionName'=Region,R),
        member('zip'=Zip,R),
        member('lat'=Lat,R),
        member('lon'=Lon,R).

