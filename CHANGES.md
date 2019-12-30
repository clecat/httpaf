Unreleased
--------------

- httpaf-lwt-unix: add support for HTTPS in the Lwt runtime, either via OpenSSL
  or `ocaml-tls` ([#2](https://github.com/anmonteiro/httpaf/pull/2))
- httpaf, httpaf-lwt, httpaf-lwt-unix, httpaf-mirage: Add a Mirage adapter
  ([#3](https://github.com/anmonteiro/httpaf/pull/3))
- Add an `esy.json` file ([#6](https://github.com/anmonteiro/httpaf/pull/6))
- httpaf: Catch parsing errors and hand them to `error_handler` in
  `Server_connection` ([#4](https://github.com/anmonteiro/httpaf/pull/4))
- httpaf, httpaf-lwt, httpaf-lwt-unix, httpaf-async, httpaf-mirage: add support
  for persistent connections and pipelining in the client implementations
  ([#5](https://github.com/anmonteiro/httpaf/pull/5))
- httpaf, httpaf-lwt, httpaf-lwt-unix, httpaf-async, httpaf-mirage: add support
  for switching protocols, e.g. to a WebSocket connection, via a new function
  `Reqd.respond_with_upgrade`
  ([#8](https://github.com/anmonteiro/httpaf/pull/8))
- httpaf-lwt, httpaf-lwt-unix, httpaf-mirage: deduplicate interface code via a
  common `Httpaf_lwt_intf` interface
  ([#13](https://github.com/anmonteiro/httpaf/pull/13))
- httpaf-mirage: depend on `mirage-conduit` instead of `conduit-mirage`,
  effectively placing a lower bound of OCaml 4.07 on httpaf-mirage
  ([#16](https://github.com/anmonteiro/httpaf/pull/16))
- httpaf-lwt-unix: replace the `dune` file (previously written in OCaml) with a
  `(select)` form to avoid depending on `ocamlfind`
  ([#18](https://github.com/anmonteiro/httpaf/pull/18))
- httpaf: Shutdown the writer after closing a non chunk-encoded request body on
  the client ([#23](https://github.com/anmonteiro/httpaf/pull/23))
- httpaf-mirage: Adapt to Mirage 3.7 interfaces. `httpaf_mirage` now requires
  `conduit-mirage` >= 2.0.2 and `mirage-flow` >= 2.0.0
  ([#24](https://github.com/anmonteiro/httpaf/pull/24))
- httpaf, httpaf-lwt, httpaf-lwt-unix, httpaf-async, httpaf-mirage: after
  switching protocols, close the connection / file descriptors when the upgrade
  handler's returned promise resolves
  ([#26](https://github.com/anmonteiro/httpaf/pull/26))
- httpaf-lwt, httpaf-lwt-unix: split HTTPS functions in 2: one that sets up a
  default secure connection and performs the TLS handshake / accept, and one
  that is more "raw", i.e. leaves that responsibility to the caller. Also
  exposes the `socket` type to make it easier to abstract over HTTP / HTTPS
  ([#28](https://github.com/anmonteiro/httpaf/pull/28))
- httpaf-lwt, httpaf-lwt-unix, httpaf-mirage: Improve the `Httpaf_lwt.IO`
  interface, don't require a `report_exn` function, only a `state` function
  that returns the socket state
  ([#30](https://github.com/anmonteiro/httpaf/pull/30))
- httpaf, httpaf-lwt, httpaf-async: Add support for upgrading connections on
  the client. ([#31](https://github.com/anmonteiro/httpaf/pull/31))
- httpaf: Fix the order of parsed request / response headers to match what it's
  advertised in the interface file. They are now served to the respective
  handlers in the original transmission order
  ([#32](https://github.com/anmonteiro/httpaf/pull/32))
- httpaf: Fix persistent connections getting stuck (reader never waking up)
  when using `~flush_headers_immediately:true` in combination with an empty
  response body ([#34](https://github.com/anmonteiro/httpaf/pull/34)). This is
  a fix for an issue opened in the upstream repo:
  [inhabitedtype/httpaf#162](https://github.com/inhabitedtype/httpaf/issues/162)
- httpaf-async: Add HTTPS support for the Async bindings
  ([#35](https://github.com/anmonteiro/httpaf/pull/35)).

httpaf (upstream) 0.6.5
--------------

- Initial fork point
  [7de2d4ea](https://github.com/anmonteiro/httpaf/commit/7de2d4ea3bd09984d398854460a2d4c8a8e42127)