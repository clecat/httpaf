(*----------------------------------------------------------------------------
    Copyright (c) 2018 Inhabited Type LLC.
    Copyright (c) 2018 Anton Bachin
    Copyright (c) 2019 António Nuno Monteiro

    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

    3. Neither the name of the author nor the names of his contributors
       may be used to endorse or promote products derived from this software
       without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTORS ``AS IS'' AND ANY EXPRESS
    OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR
    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
    STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
  ----------------------------------------------------------------------------*)

open Dream_httpaf

(* The function that results from [create_connection_handler] should be passed
   to [Lwt_io.establish_server_with_client_socket]. For an example, see
   [examples/lwt_echo_server.ml]. *)
module Server : sig
  include Dream_httpaf_lwt.Server
    with type socket = Lwt_unix.file_descr
     and type addr := Unix.sockaddr

  module TLS : sig
    include Dream_httpaf_lwt.Server
      with type socket = Dream_gluten_lwt_unix.Server.TLS.socket
       and type addr := Unix.sockaddr

    val create_connection_handler_with_default
      :  certfile       : string
      -> keyfile        : string
      -> ?config         : Config.t
      -> request_handler : (Unix.sockaddr -> Dream_httpaf.Reqd.t Dream_gluten.reqd -> unit)
      -> error_handler   : (Unix.sockaddr -> Server_connection.error_handler)
      -> Unix.sockaddr
      -> Lwt_unix.file_descr
      -> unit Lwt.t
  end

  module SSL : sig
    include Dream_httpaf_lwt.Server
      with type socket = Dream_gluten_lwt_unix.Server.SSL.socket
       and type addr := Unix.sockaddr

    val create_connection_handler_with_default
      :  certfile       : string
      -> keyfile        : string
      -> ?config         : Config.t
      -> request_handler : (Unix.sockaddr -> Dream_httpaf.Reqd.t Dream_gluten.reqd -> unit)
      -> error_handler   : (Unix.sockaddr -> Server_connection.error_handler)
      -> Unix.sockaddr
      -> Lwt_unix.file_descr
      -> unit Lwt.t
  end
end

(* For an example, see [examples/lwt_get.ml]. *)
module Client : sig
  include Dream_httpaf_lwt.Client
    with type socket = Lwt_unix.file_descr
     and type runtime = Dream_gluten_lwt_unix.Client.t

  module TLS : sig
    include Dream_httpaf_lwt.Client
      with type socket = Dream_gluten_lwt_unix.Client.TLS.socket
       and type runtime = Dream_gluten_lwt_unix.Client.TLS.t

    val create_connection_with_default
      :  ?config : Config.t
      -> Lwt_unix.file_descr
      -> t Lwt.t
  end

  module SSL : sig
    include Dream_httpaf_lwt.Client
      with type socket = Dream_gluten_lwt_unix.Client.SSL.socket
       and type runtime = Dream_gluten_lwt_unix.Client.SSL.t

    val create_connection_with_default
      :  ?config : Config.t
      -> Lwt_unix.file_descr
      -> t Lwt.t
  end
end
