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

include Httpaf_lwt_intf

module Server (Server_runtime: Dream_gluten_lwt.Server) = struct
  type socket = Server_runtime.socket

  let create_connection_handler
    ?(config=Dream_httpaf.Config.default)
    ~request_handler
    ~error_handler =
    fun client_addr socket ->
      let create_connection =
        Dream_httpaf.Server_connection.create
          ~config
          ~error_handler:(error_handler client_addr)
      in
      Server_runtime.create_upgradable_connection_handler
        ~read_buffer_size:config.read_buffer_size
        ~protocol:(module Dream_httpaf.Server_connection)
        ~create_protocol:create_connection
        ~request_handler
        client_addr
        socket
end

module Client (Client_runtime: Dream_gluten_lwt.Client) = struct
  type socket = Client_runtime.socket

  type runtime = Client_runtime.t

  type t =
    { connection: Dream_httpaf.Client_connection.t
    ; runtime: runtime
    }

  let create_connection ?(config=Dream_httpaf.Config.default) socket =
    let open Lwt.Infix in
    let connection = Dream_httpaf.Client_connection.create ~config in
    Client_runtime.create
      ~read_buffer_size:config.read_buffer_size
      ~protocol:(module Dream_httpaf.Client_connection)
      connection
      socket
    >|= fun runtime ->
      { runtime; connection }

  let request t = Dream_httpaf.Client_connection.request t.connection

  let shutdown t = Client_runtime.shutdown t.runtime

  let is_closed t = Client_runtime.is_closed t.runtime

  let upgrade t protocol = Client_runtime.upgrade t.runtime protocol
end
