(ql:quickload :websocket-driver-client)
(ql:quickload :jonathan)
(ql:quickload :jsown)

;;(defparameter *client* (wsd:make-client "wss://stream.binance.com:9443/ws/adausdt@aggTrade"))
;;(wsd:start-connection *client*)
;;(wsd:on :message *client*
;;        (lambda (message)
;;          (let* ((data (jonathan:parse message :as :jsown))
;;                 (price (jsown:val data "p"))
;;                 (quantity (jsown:val data "q"))
;;                 (market-maker (jsown:val data "m"))
;;            (format t "~a ~a market-maker? ~a ~%" price quantity market-maker))

;; Get candlestick info
(defparameter *client* (wsd:make-client "wss://stream.binance.com:9443/ws/adausdt@kline_1h"))
(wsd:start-connection *client*)

;;; print open, close, high and low prices
(wsd:on :message *client*
        (lambda (message)
          (let* ((data (jonathan:parse message :as :jsown))
                 (kline (jsown:val data "k"))
                 (op (jsown:val kline "o"))
                 (cl (jsown:val kline "c"))
                 (hi (jsown:val kline "h"))
                 (lo (jsown:val kline "l"))
                 (ti (jsown:val kline "t"))
                 (tf (jsown:val kline "T")))
            (format t "Open Time: ~a  Closing Time: ~a Open: ~a Close: ~a High:~a Low:~a ~%" ti tf op cl hi lo))))



(wsd:close-connection *client*)

              
