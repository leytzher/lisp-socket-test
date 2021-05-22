(ql:quickload '(:cl-json
                :drakma
                :cl-dotenv
                :jsown))

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

;; variable to store access token
(defparameter *access-token* nil)


(defun get-token ()
  (let* ((stream (drakma:http-request  "https://www.reddit.com/api/v1/access_token"
                                     :additional-headers *headers*
                                     :method :post
                                     :parameters *data*
                                     :basic-authorization *auth*
                                     :want-stream t))
         (credentials (json:decode-json stream)))
    (setf *access-token*  (cdr (find :access--token credentials :key 'car)))))

(get-token)
