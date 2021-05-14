(ql:quickload :websocket-driver-client)
(ql:quickload :jonathan)
(ql:quickload :jsown)

(defparameter *client* (wsd:make-client "wss://stream.binance.com:9443/ws/adausdt@aggTrade"))
(wsd:start-connection *client*)

(wsd:on :message *client*
        (lambda (message)
          (let* ((data (jonathan:parse message :as :jsown))
                 (price (jsown:val data "p"))
                 (quantity (jsown:val data "q"))
                 (market-maker (jsown:val data "m")))
            (format t "~a ~a market-maker? ~a ~%" price quantity market-maker))))

(wsd:close-connection *client*)

              
