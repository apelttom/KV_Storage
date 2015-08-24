-module(rest).
-include("/usr/lib/yaws/include/yaws_api.hrl").
-export(out/1,serve/2).

out(Arg) ->
	URI = yaws_api:request_url(Arg),
	Method = Method = (Arg#arg.req)#http_request.method,
	server(Method, Arg).
	
readFile(FileName) ->
	{ok, Device} = file:open(FileName, [read]),
	try get_all_lines(Device)
      after file:close(Device)
    end.
    
get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.

serve('GET', Arg) ->
	io:format("GET Request ~n"),
	ConfirmationPage = readFile("index.html"),
	[{status, 200},
	 {html, ConfirmationPage}].
