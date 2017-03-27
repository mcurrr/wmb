%%%-------------------------------------------------------------------
%%% @author $author
%%% @copyright (C) $year, $company
%%% @doc
%%%
%%% @end
%%% Created : $fulldate
%%%-------------------------------------------------------------------
-module(wmb_librarian).

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3
]).

-define(SERVER, ?MODULE).

-include("ets_names.hrl").
-record(state, {path = undefined}).

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
start_link(Path) ->
    gen_server:start_link(?MODULE, [Path], []).

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
init([Path]) ->
    self() ! scan_library,
    {ok, #state{path = Path}}.

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
handle_info(scan_library, #state{path = Path} = State) ->
    {ok, RootDirList} = file:list_dir(Path),
    io:format("Path now: ~p~n: ", [Path]),
    check_dir_or_file(Path, RootDirList),
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
-spec check_dir_or_file(string(), list()) ->
    {ok, done}.
check_dir_or_file(_Path, []) ->
    {ok, done};
check_dir_or_file(Path, [File|T]) ->
    FullPath = lists:concat([Path, '/', File]),
    case filelib:is_dir(FullPath) of
        true ->
            {ok, _} = supervisor:start_child(wmb_librarian_sup, [FullPath]),
            io:format("is dir: ~p~n", [[File, FullPath]]);
        false ->
            check_file(FullPath)
            %Result = spawn(wmb_digger, parse_file, [fullpath, FullPath]),
            %Result = wmb_digger:parse_file(fullpath, FullPath),
            %io:format("Result: ~p~n", [[Result, FullPath]])
    end,
check_dir_or_file(Path, T).

-spec check_file(string()) ->
    {ok, flac} | {ok, cover} | {error, not_interesting}.
check_file(File) ->
    case re:run(File, ".*.(flac)$", [caseless, unicode]) of
        {match, _} ->
            Result = wmb_digger:parse_file(fullpath, File),
            io:format("File for Check: ~p~n", [[File, Result]]);
        nomatch ->
            io:format("File Not Matched: ~p~n", [File])
    end.
