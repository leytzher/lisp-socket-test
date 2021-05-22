(ql:quickload '(:cl-json
                :drakma
                :cl-dotenv
                :jsown
                :access))

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

;;; Authenticate and start pulling data from Reddit
;;;
(defparameter *auth-headers*
  (list (cons "user-agent" (gethash "appname" *keys*))
        (cons "authorization" (concatenate 'string "bearer " *access-token*))))


(defun get-hot (subreddit)
  (let* ((url (concatenate 'string "https://oauth.reddit.com/r/" subreddit "/hot"))
        (stream (drakma:http-request url
                                     :additional-headers *auth-headers*
                                     :method :get
                                     :want-stream t)))
    (json:decode-json stream)))


(find :data (cdr *out*) :key 'car)


(defun get-data (data)
  (let* ((params
           (cdr (find :children  (cdr (find :data (cdr data) :key 'car)) :key 'car ))))
    (mapcar #'(lambda (x) (find :title
                           (cdr (find :data  (cdr x) :key 'car))
                           :key 'car)) params)))
