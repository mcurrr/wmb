%% Feel free to use, reuse and abuse the code in this file.

%% @doc API handler
-module(api_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("ets_names.hrl").

init(_Type, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {Path, Req1} = cowboy_req:path(Req),
    [_, _, APIType, APIid] = binary:split(Path, [<<"/">>], [global]),
    io:format("Path Elements: ~p~n", [[APIType, APIid]]),
    FilesUrlRoot = <<"/files/">>,

    case APIType of
        <<"albums">> ->
            {ok, Album} = data_merger:get_album_by_albumid({album_id, binary_to_integer(APIid)}),
            io:format("Response from /api/albums/id: ~p~n", [Album]),
            Res = jsx:encode(Album);
        <<"random">> ->
            {ok, RandomTrackList} = data_merger:get_random_tracks(binary_to_integer(APIid)),
            io:format("Response from /api/random/id: ~p~n", [RandomTrackList]),
            Res = jsx:encode(RandomTrackList);
        <<"tracks">> ->
            {ok, Track2Web} = data_merger:get_track_by_trackid({track_id, binary_to_integer(APIid)}),
            io:format("Response from /api/tracks/id: ~p~n", [Track2Web]),
            Res = jsx:encode(Track2Web);
        _ ->
            Res = <<"API Request Not Found">>
    end,

    {ok, Req2} = cowboy_req:reply(
               200,
               [{<<"content-type">>, <<"application/json">>}],
                   Res,
               Req),
    {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.
