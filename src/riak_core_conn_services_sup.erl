%% -------------------------------------------------------------------
%%
%% riak_core_conn_services_sup: supervise connection mananger services
%%
%% Copyright (c) 2013 Basho Technologies, Inc.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

%% @doc Supervise connection manager services

-module(riak_core_conn_services_sup).


%% API

-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

%% @private
init([]) ->
    {ok, 
     {{simple_one_for_one, 10, 10},
      [
       %% Services Manager (accepts inbound connections)
       {riak_core_service_mgr, {riak_core_service_mgr, start_link, []},
        permanent, 5000, worker, [riak_core_service_mgr]},
       %% Connection Manager (outbound connections)
       {riak_core_connection_mgr, {riak_core_connection_mgr, start_link, []},
        permanent, 5000, worker, [riak_core_connection_mgr]},
       %% TCP Monitor
       {riak_core_tcp_mon, {riak_core_tcp_mon, start_link, []},
        permanent, 5000, worker, [riak_core_tcp_mon]}
      ]}}.
