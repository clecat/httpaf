module type Server_intf = sig
  type request_handler =
    Conduit_mirage.Flow.flow Httpaf.Server_connection.request_handler

  val create_connection_handler
    :  ?config : Httpaf.Server_connection.Config.t
    -> request_handler : request_handler
    -> error_handler : Httpaf.Server_connection.error_handler
    -> unit
    -> (Conduit_mirage.Flow.flow -> unit Lwt.t)
end

module Server : Server_intf

module Server_with_conduit : sig
  include Server_intf

  type t = Conduit_mirage.Flow.flow -> unit Lwt.t

  val connect:
    Conduit_mirage.t ->
    (Conduit_mirage.server -> t -> unit Lwt.t) Lwt.t
end

(* For an example, see [examples/lwt_get.ml]. *)
module Client : sig
  val request
    :  Conduit_mirage.Flow.flow
    -> Httpaf.Request.t
    -> error_handler : Httpaf.Client_connection.error_handler
    -> response_handler : Httpaf.Client_connection.response_handler
      -> [`write] Httpaf.Body.t
end