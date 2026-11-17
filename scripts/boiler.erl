-module(boiler).
-export([main/0]).
-import(filename, [dirname/1, join/2]).
-import(file, [read_file/1, write_file/2, open/2, write/2, close/1]).

main() ->
    Root = dirname(dirname(code:which(?MODULE))),
    {ok, Bin} = read_file(join(Root, "injections.json")), Cool = json:decode(Bin),
    filelib:fold_files(Root, ".*\.html", true,
        fun(File, _) ->
            {ok, Contents} = read_file(File),
            write_file(File, <<"">>),
            {ok, Device} = open(File, [append, binary]),
            write(Device, <<"<!doctype html>\n<html lang=en>\n<head>\n<meta charset=utf-8>\n<title>cool</title>\n">>),
            case maps:is_key(list_to_binary(File), Cool) of
                true -> lists:foreach(fun(Str) ->
                    case {re:run(Str, "js$"), re:run(Str, "css$")} of
                        {{match, _}, _} -> write(Device, <<"script type=\"module\" src=\"", Str/binary, "\"></script>\n">>);
                        {_, {match, _}} -> write(Device, <<"link rel=\"stylesheet\" href=\"", Str/binary, "\">\n">>);
                        _ -> throw("67")
                    end end, maps:get(list_to_binary(File), Cool));
                false -> 67 end,
            write(Device, <<"</head>\n<body>\n", Contents/binary, "\n</body>\n</html>">>),
            close(Device)
        end, []),
    erlang:halt(0).
