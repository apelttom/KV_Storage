-module(core).
-export([start/0, body/1]).

% Author: Tom Apeltauer

start() ->
	register(?MODULE, spawn(?MODULE, body, [dict:new()])).
	
body(Dictionary) ->
	receive
		{From, store, Data} ->
			NewDictionary = store(Data, Dictionary),
			body(NewDictionary);
			%~ TODO: resolve the state and return something to the caller
		{From, find, Key} ->
			From ! find(Key, Dictionary),
			body(Dictionary);
		power_off -> ok;
		_ ->
			erlang:error("ERROR: ---UEXPECTED INPUT ON CORE MODULE---")
	end.

store([], Dictionary) -> Dictionary;

store([{Key, Value} | Rest], Dictionary) ->
	store(Rest, dict:store(Key, Value, Dictionary)).

find(Key, Dictionary) ->
	dict:find(Key, Dictionary).
