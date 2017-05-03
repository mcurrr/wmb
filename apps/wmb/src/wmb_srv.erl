%%%-------------------------------------------------------------------
%%% @author $author
%%% @copyright (C) $year, $company
%%% @doc
%%%
%%% @end
%%% Created : $fulldate
%%%-------------------------------------------------------------------
-module(wmb_srv).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

%% Internal Functions
-include("ets_names.hrl").

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    self() ! read_all,
    ets:new(?ETS_ABC, [public, bag, named_table]),
    ets:new(?ETS_ALBUMS, [public, set, named_table]),
    ets:new(?ETS_ARTISTS, [public, ordered_set, named_table]),
    ets:new(?ETS_COVERS, [public, ordered_set, named_table]),
    ets:new(?ETS_COUNTERS, [public, set, named_table]),
    [ets:insert(?ETS_COUNTERS, {CounterKey, 0}) || CounterKey <- [album_id_counter, artist_id_counter, letter_id_counter, path_id_counter, track_id_counter]],
    ets:new(?ETS_GENRES, [public, ordered_set, named_table]),
    ets:new(?ETS_PATHS,  [public, ordered_set, named_table]),
    ets:new(?ETS_TRACKS, [public, ordered_set, named_table]),
    ets:new(?ETS_ERRORS, [public, bag, named_table]),
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(read_all, State) ->
%%%%    {ok, FilesRoot} = application:get_env(wmb, files_root),
%%%%    {ok, FilesPattern} = application:get_env(wmb, files_pattern),
%%%%    FlacFiles = filelib:wildcard(FilesPattern, FilesRoot),
%%%%    LengthFiles = length(FlacFiles),
%%%%    io:format("All Files: ~p~n: ", [[FlacFiles, LengthFiles]]),
%%%%    case LengthFiles > 1000 of
%%%%        true ->
%%%%            [wmb_digger:parse_file(FlacFile) || FlacFile <- FlacFiles];
%%%%        false ->
%%%%            false
%%%%            %[spawn(wmb_digger, parse_file, [FlacFile]) || FlacFile <- FlacFiles]
%%%%    end,
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
        {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

