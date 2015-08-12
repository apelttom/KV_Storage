-module(buffer).
-export([start/0]).

body(Buffer) when length(Buffer) > 1024 ->
	core ! {self(), store, Buffer},
	body([]);

body(Buffer) ->
	receive
		{From, Key, Value} ->
			body([{Key, Value}] ++ Buffer);
		_->
			erlang:error("ERROR: ---UEXPECTED INPUT ON CORE MODULE---")
	end.
