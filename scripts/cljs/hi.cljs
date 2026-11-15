(def hi (. js/document getElementById "hi"))
(defn move []
  (let [vx (/ (- (* (Math/random) (- (.-innerWidth js/window) (.-width hi))) (.-left (.getBoundingClientRect hi))) 50)
        vy (/ (- (* (Math/random) (- (.-innerHeight js/window) (.-height hi))) (.-top (.getBoundingClientRect hi))) 50)
        counter (atom 0)
        interval (atom nil)]
    (reset! interval (.setInterval js/window
                       (fn []
                         (reset! counter (+ 1 @counter)) ; disgustingly unidomatic
                           (if (> @counter 20)
                             (.clearInterval js/window @interval)
                             (do
                               (set! (.. hi -style -left) (str (+ (. (.getBoundingClientRect hi) -left) vx) "px"))
                               (set! (.. hi -style -top) (str (+ (. (.getBoundingClientRect hi) -top) vy) "px"))))) 50))))
(.addEventListener hi "click" move)

; https://stackoverflow.com/questions/36401144/clearinterval-inside-callback-in-clojurescript
; https://stackoverflow.com/questions/11702319/how-to-move-an-image-with-javascript
; https://www.bitsbyluke.com/2018/10/20/clojurescript-interop-with-javascript.html
