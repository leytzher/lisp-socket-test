;; 
(ql:quickload '(:cl-json
                :drakma
                :cl-dotenv))

(setf drakma:*header-stream* *standard-output*)

(.env:load-env ".env")
(defparameter *keys* (.env:read-env ".env"))

;; this data is sent in the post request
(defparameter *data* (list
                               (cons "grant_type" "password")
                               (cons "username" (gethash "username" *keys*))
                               (cons "password" (gethash "password" *keys*))))

(defparameter *headers* (list (cons "user-agent" (gethash "appname" *keys*))))

(defparameter *auth* (list (gethash "appcode" *keys*) (gethash "appkey" *keys*)))

(defun retrieve-keys ()
  (let* ((cookie-jar (make-instance 'drakma:cookie-jar))
         (extra-headers *headers*)
         (url "https://www.reddit.com/api/v1/access_token")
         (stream (drakma:http-request url
                                      :additional-headers extra-headers
                                      :accept "application/json"
                                      :content-type "application/x-www-form-urlencoded"
                                      :method :post
                                      :external-format-out :utf-8
                                      :external-format-in :utf-8
                                      :redirect 100
                                      :cookie-jar cookie-jar
                                      :content (json:encode-json-to-string *data*)
                                      :basic-authorization *auth*
                                      :want-stream t)))
    (json:decode-json stream)))


(retrieve-keys)
