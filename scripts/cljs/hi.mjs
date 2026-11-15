import * as squint_core from "./node_modules/squint-cljs/core.js";
var hi = document.getElementById("hi");
var move = function () {
const vx_1 = (((Math.random() * (window.innerWidth - hi.width)) - hi.getBoundingClientRect().left) / 50);
const vy_2 = (((Math.random() * (window.innerHeight - hi.height)) - hi.getBoundingClientRect().top) / 50);
const counter_3 = squint_core.atom(0);
const interval_4 = squint_core.atom(null);
return squint_core.reset_BANG_(interval_4, window.setInterval((function () {
squint_core.reset_BANG_(counter_3, (1 + squint_core.deref(counter_3)));
if ((squint_core.deref(counter_3) > 20)) {
return window.clearInterval(squint_core.deref(interval_4))} else {
hi.style.left = `${(hi.getBoundingClientRect().left + vx_1)}px`;
return hi.style.top = `${(hi.getBoundingClientRect().top + vy_2)}px`;
};

}), 50));

};
hi.addEventListener("click", move);
