!function(t,e){"object"==typeof exports&&"object"==typeof module?module.exports=e():"function"==typeof define&&define.amd?define([],e):"object"==typeof exports?exports.CheckboxMultiselect=e():t.CheckboxMultiselect=e()}(window,(function(){return(()=>{var t={1989:(t,e,r)=>{var n=r(1789),i=r(401),o=r(7667),s=r(1327),a=r(1866);function c(t){var e=-1,r=null==t?0:t.length;for(this.clear();++e<r;){var n=t[e];this.set(n[0],n[1])}}c.prototype.clear=n,c.prototype.delete=i,c.prototype.get=o,c.prototype.has=s,c.prototype.set=a,t.exports=c},8407:(t,e,r)=>{var n=r(7040),i=r(4125),o=r(2117),s=r(7518),a=r(4705);function c(t){var e=-1,r=null==t?0:t.length;for(this.clear();++e<r;){var n=t[e];this.set(n[0],n[1])}}c.prototype.clear=n,c.prototype.delete=i,c.prototype.get=o,c.prototype.has=s,c.prototype.set=a,t.exports=c},7071:(t,e,r)=>{var n=r(852)(r(5639),"Map");t.exports=n},3369:(t,e,r)=>{var n=r(4785),i=r(1285),o=r(6e3),s=r(9916),a=r(5265);function c(t){var e=-1,r=null==t?0:t.length;for(this.clear();++e<r;){var n=t[e];this.set(n[0],n[1])}}c.prototype.clear=n,c.prototype.delete=i,c.prototype.get=o,c.prototype.has=s,c.prototype.set=a,t.exports=c},6384:(t,e,r)=>{var n=r(8407),i=r(7465),o=r(3779),s=r(7599),a=r(4758),c=r(4309);function u(t){var e=this.__data__=new n(t);this.size=e.size}u.prototype.clear=i,u.prototype.delete=o,u.prototype.get=s,u.prototype.has=a,u.prototype.set=c,t.exports=u},2705:(t,e,r)=>{var n=r(5639).Symbol;t.exports=n},1149:(t,e,r)=>{var n=r(5639).Uint8Array;t.exports=n},6874:t=>{t.exports=function(t,e,r){switch(r.length){case 0:return t.call(e);case 1:return t.call(e,r[0]);case 2:return t.call(e,r[0],r[1]);case 3:return t.call(e,r[0],r[1],r[2])}return t.apply(e,r)}},4636:(t,e,r)=>{var n=r(2545),i=r(5694),o=r(1469),s=r(4144),a=r(5776),c=r(6719),u=Object.prototype.hasOwnProperty;t.exports=function(t,e){var r=o(t),l=!r&&i(t),h=!r&&!l&&s(t),p=!r&&!l&&!h&&c(t),d=r||l||h||p,f=d?n(t.length,String):[],v=f.length;for(var b in t)!e&&!u.call(t,b)||d&&("length"==b||h&&("offset"==b||"parent"==b)||p&&("buffer"==b||"byteLength"==b||"byteOffset"==b)||a(b,v))||f.push(b);return f}},6556:(t,e,r)=>{var n=r(9465),i=r(7813);t.exports=function(t,e,r){(void 0!==r&&!i(t[e],r)||void 0===r&&!(e in t))&&n(t,e,r)}},4865:(t,e,r)=>{var n=r(9465),i=r(7813),o=Object.prototype.hasOwnProperty;t.exports=function(t,e,r){var s=t[e];o.call(t,e)&&i(s,r)&&(void 0!==r||e in t)||n(t,e,r)}},8470:(t,e,r)=>{var n=r(7813);t.exports=function(t,e){for(var r=t.length;r--;)if(n(t[r][0],e))return r;return-1}},9465:(t,e,r)=>{var n=r(8777);t.exports=function(t,e,r){"__proto__"==e&&n?n(t,e,{configurable:!0,enumerable:!0,value:r,writable:!0}):t[e]=r}},3118:(t,e,r)=>{var n=r(3218),i=Object.create,o=function(){function t(){}return function(e){if(!n(e))return{};if(i)return i(e);t.prototype=e;var r=new t;return t.prototype=void 0,r}}();t.exports=o},8483:(t,e,r)=>{var n=r(5063)();t.exports=n},4239:(t,e,r)=>{var n=r(2705),i=r(9607),o=r(2333),s=n?n.toStringTag:void 0;t.exports=function(t){return null==t?void 0===t?"[object Undefined]":"[object Null]":s&&s in Object(t)?i(t):o(t)}},9454:(t,e,r)=>{var n=r(4239),i=r(7005);t.exports=function(t){return i(t)&&"[object Arguments]"==n(t)}},8458:(t,e,r)=>{var n=r(3560),i=r(5346),o=r(3218),s=r(346),a=/^\[object .+?Constructor\]$/,c=Function.prototype,u=Object.prototype,l=c.toString,h=u.hasOwnProperty,p=RegExp("^"+l.call(h).replace(/[\\^$.*+?()[\]{}|]/g,"\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g,"$1.*?")+"$");t.exports=function(t){return!(!o(t)||i(t))&&(n(t)?p:a).test(s(t))}},8749:(t,e,r)=>{var n=r(4239),i=r(1780),o=r(7005),s={};s["[object Float32Array]"]=s["[object Float64Array]"]=s["[object Int8Array]"]=s["[object Int16Array]"]=s["[object Int32Array]"]=s["[object Uint8Array]"]=s["[object Uint8ClampedArray]"]=s["[object Uint16Array]"]=s["[object Uint32Array]"]=!0,s["[object Arguments]"]=s["[object Array]"]=s["[object ArrayBuffer]"]=s["[object Boolean]"]=s["[object DataView]"]=s["[object Date]"]=s["[object Error]"]=s["[object Function]"]=s["[object Map]"]=s["[object Number]"]=s["[object Object]"]=s["[object RegExp]"]=s["[object Set]"]=s["[object String]"]=s["[object WeakMap]"]=!1,t.exports=function(t){return o(t)&&i(t.length)&&!!s[n(t)]}},313:(t,e,r)=>{var n=r(3218),i=r(5726),o=r(3498),s=Object.prototype.hasOwnProperty;t.exports=function(t){if(!n(t))return o(t);var e=i(t),r=[];for(var a in t)("constructor"!=a||!e&&s.call(t,a))&&r.push(a);return r}},2980:(t,e,r)=>{var n=r(6384),i=r(6556),o=r(8483),s=r(9783),a=r(3218),c=r(1704),u=r(6390);t.exports=function t(e,r,l,h,p){e!==r&&o(r,(function(o,c){if(p||(p=new n),a(o))s(e,r,c,l,t,h,p);else{var d=h?h(u(e,c),o,c+"",e,r,p):void 0;void 0===d&&(d=o),i(e,c,d)}}),c)}},9783:(t,e,r)=>{var n=r(6556),i=r(4626),o=r(7133),s=r(278),a=r(8517),c=r(5694),u=r(1469),l=r(9246),h=r(4144),p=r(3560),d=r(3218),f=r(8630),v=r(6719),b=r(6390),g=r(9881);t.exports=function(t,e,r,y,x,_,m){var w=b(t,r),A=b(e,r),O=m.get(A);if(O)n(t,r,O);else{var j=_?_(w,A,r+"",t,e,m):void 0,T=void 0===j;if(T){var k=u(A),S=!k&&h(A),E=!k&&!S&&v(A);j=A,k||S||E?u(w)?j=w:l(w)?j=s(w):S?(T=!1,j=i(A,!0)):E?(T=!1,j=o(A,!0)):j=[]:f(A)||c(A)?(j=w,c(w)?j=g(w):d(w)&&!p(w)||(j=a(A))):T=!1}T&&(m.set(A,j),x(j,A,y,_,m),m.delete(A)),n(t,r,j)}}},5976:(t,e,r)=>{var n=r(6557),i=r(5357),o=r(61);t.exports=function(t,e){return o(i(t,e,n),t+"")}},6560:(t,e,r)=>{var n=r(5703),i=r(8777),o=r(6557),s=i?function(t,e){return i(t,"toString",{configurable:!0,enumerable:!1,value:n(e),writable:!0})}:o;t.exports=s},2545:t=>{t.exports=function(t,e){for(var r=-1,n=Array(t);++r<t;)n[r]=e(r);return n}},1717:t=>{t.exports=function(t){return function(e){return t(e)}}},4318:(t,e,r)=>{var n=r(1149);t.exports=function(t){var e=new t.constructor(t.byteLength);return new n(e).set(new n(t)),e}},4626:(t,e,r)=>{t=r.nmd(t);var n=r(5639),i=e&&!e.nodeType&&e,o=i&&t&&!t.nodeType&&t,s=o&&o.exports===i?n.Buffer:void 0,a=s?s.allocUnsafe:void 0;t.exports=function(t,e){if(e)return t.slice();var r=t.length,n=a?a(r):new t.constructor(r);return t.copy(n),n}},7133:(t,e,r)=>{var n=r(4318);t.exports=function(t,e){var r=e?n(t.buffer):t.buffer;return new t.constructor(r,t.byteOffset,t.length)}},278:t=>{t.exports=function(t,e){var r=-1,n=t.length;for(e||(e=Array(n));++r<n;)e[r]=t[r];return e}},8363:(t,e,r)=>{var n=r(4865),i=r(9465);t.exports=function(t,e,r,o){var s=!r;r||(r={});for(var a=-1,c=e.length;++a<c;){var u=e[a],l=o?o(r[u],t[u],u,r,t):void 0;void 0===l&&(l=t[u]),s?i(r,u,l):n(r,u,l)}return r}},4429:(t,e,r)=>{var n=r(5639)["__core-js_shared__"];t.exports=n},1463:(t,e,r)=>{var n=r(5976),i=r(6612);t.exports=function(t){return n((function(e,r){var n=-1,o=r.length,s=o>1?r[o-1]:void 0,a=o>2?r[2]:void 0;for(s=t.length>3&&"function"==typeof s?(o--,s):void 0,a&&i(r[0],r[1],a)&&(s=o<3?void 0:s,o=1),e=Object(e);++n<o;){var c=r[n];c&&t(e,c,n,s)}return e}))}},5063:t=>{t.exports=function(t){return function(e,r,n){for(var i=-1,o=Object(e),s=n(e),a=s.length;a--;){var c=s[t?a:++i];if(!1===r(o[c],c,o))break}return e}}},8777:(t,e,r)=>{var n=r(852),i=function(){try{var t=n(Object,"defineProperty");return t({},"",{}),t}catch(t){}}();t.exports=i},1957:(t,e,r)=>{var n="object"==typeof r.g&&r.g&&r.g.Object===Object&&r.g;t.exports=n},5050:(t,e,r)=>{var n=r(7019);t.exports=function(t,e){var r=t.__data__;return n(e)?r["string"==typeof e?"string":"hash"]:r.map}},852:(t,e,r)=>{var n=r(8458),i=r(7801);t.exports=function(t,e){var r=i(t,e);return n(r)?r:void 0}},5924:(t,e,r)=>{var n=r(5569)(Object.getPrototypeOf,Object);t.exports=n},9607:(t,e,r)=>{var n=r(2705),i=Object.prototype,o=i.hasOwnProperty,s=i.toString,a=n?n.toStringTag:void 0;t.exports=function(t){var e=o.call(t,a),r=t[a];try{t[a]=void 0;var n=!0}catch(t){}var i=s.call(t);return n&&(e?t[a]=r:delete t[a]),i}},7801:t=>{t.exports=function(t,e){return null==t?void 0:t[e]}},1789:(t,e,r)=>{var n=r(4536);t.exports=function(){this.__data__=n?n(null):{},this.size=0}},401:t=>{t.exports=function(t){var e=this.has(t)&&delete this.__data__[t];return this.size-=e?1:0,e}},7667:(t,e,r)=>{var n=r(4536),i=Object.prototype.hasOwnProperty;t.exports=function(t){var e=this.__data__;if(n){var r=e[t];return"__lodash_hash_undefined__"===r?void 0:r}return i.call(e,t)?e[t]:void 0}},1327:(t,e,r)=>{var n=r(4536),i=Object.prototype.hasOwnProperty;t.exports=function(t){var e=this.__data__;return n?void 0!==e[t]:i.call(e,t)}},1866:(t,e,r)=>{var n=r(4536);t.exports=function(t,e){var r=this.__data__;return this.size+=this.has(t)?0:1,r[t]=n&&void 0===e?"__lodash_hash_undefined__":e,this}},8517:(t,e,r)=>{var n=r(3118),i=r(5924),o=r(5726);t.exports=function(t){return"function"!=typeof t.constructor||o(t)?{}:n(i(t))}},5776:t=>{var e=/^(?:0|[1-9]\d*)$/;t.exports=function(t,r){var n=typeof t;return!!(r=null==r?9007199254740991:r)&&("number"==n||"symbol"!=n&&e.test(t))&&t>-1&&t%1==0&&t<r}},6612:(t,e,r)=>{var n=r(7813),i=r(8612),o=r(5776),s=r(3218);t.exports=function(t,e,r){if(!s(r))return!1;var a=typeof e;return!!("number"==a?i(r)&&o(e,r.length):"string"==a&&e in r)&&n(r[e],t)}},7019:t=>{t.exports=function(t){var e=typeof t;return"string"==e||"number"==e||"symbol"==e||"boolean"==e?"__proto__"!==t:null===t}},5346:(t,e,r)=>{var n,i=r(4429),o=(n=/[^.]+$/.exec(i&&i.keys&&i.keys.IE_PROTO||""))?"Symbol(src)_1."+n:"";t.exports=function(t){return!!o&&o in t}},5726:t=>{var e=Object.prototype;t.exports=function(t){var r=t&&t.constructor;return t===("function"==typeof r&&r.prototype||e)}},7040:t=>{t.exports=function(){this.__data__=[],this.size=0}},4125:(t,e,r)=>{var n=r(8470),i=Array.prototype.splice;t.exports=function(t){var e=this.__data__,r=n(e,t);return!(r<0||(r==e.length-1?e.pop():i.call(e,r,1),--this.size,0))}},2117:(t,e,r)=>{var n=r(8470);t.exports=function(t){var e=this.__data__,r=n(e,t);return r<0?void 0:e[r][1]}},7518:(t,e,r)=>{var n=r(8470);t.exports=function(t){return n(this.__data__,t)>-1}},4705:(t,e,r)=>{var n=r(8470);t.exports=function(t,e){var r=this.__data__,i=n(r,t);return i<0?(++this.size,r.push([t,e])):r[i][1]=e,this}},4785:(t,e,r)=>{var n=r(1989),i=r(8407),o=r(7071);t.exports=function(){this.size=0,this.__data__={hash:new n,map:new(o||i),string:new n}}},1285:(t,e,r)=>{var n=r(5050);t.exports=function(t){var e=n(this,t).delete(t);return this.size-=e?1:0,e}},6e3:(t,e,r)=>{var n=r(5050);t.exports=function(t){return n(this,t).get(t)}},9916:(t,e,r)=>{var n=r(5050);t.exports=function(t){return n(this,t).has(t)}},5265:(t,e,r)=>{var n=r(5050);t.exports=function(t,e){var r=n(this,t),i=r.size;return r.set(t,e),this.size+=r.size==i?0:1,this}},4536:(t,e,r)=>{var n=r(852)(Object,"create");t.exports=n},3498:t=>{t.exports=function(t){var e=[];if(null!=t)for(var r in Object(t))e.push(r);return e}},1167:(t,e,r)=>{t=r.nmd(t);var n=r(1957),i=e&&!e.nodeType&&e,o=i&&t&&!t.nodeType&&t,s=o&&o.exports===i&&n.process,a=function(){try{return o&&o.require&&o.require("util").types||s&&s.binding&&s.binding("util")}catch(t){}}();t.exports=a},2333:t=>{var e=Object.prototype.toString;t.exports=function(t){return e.call(t)}},5569:t=>{t.exports=function(t,e){return function(r){return t(e(r))}}},5357:(t,e,r)=>{var n=r(6874),i=Math.max;t.exports=function(t,e,r){return e=i(void 0===e?t.length-1:e,0),function(){for(var o=arguments,s=-1,a=i(o.length-e,0),c=Array(a);++s<a;)c[s]=o[e+s];s=-1;for(var u=Array(e+1);++s<e;)u[s]=o[s];return u[e]=r(c),n(t,this,u)}}},5639:(t,e,r)=>{var n=r(1957),i="object"==typeof self&&self&&self.Object===Object&&self,o=n||i||Function("return this")();t.exports=o},6390:t=>{t.exports=function(t,e){if(("constructor"!==e||"function"!=typeof t[e])&&"__proto__"!=e)return t[e]}},61:(t,e,r)=>{var n=r(6560),i=r(1275)(n);t.exports=i},1275:t=>{var e=Date.now;t.exports=function(t){var r=0,n=0;return function(){var i=e(),o=16-(i-n);if(n=i,o>0){if(++r>=800)return arguments[0]}else r=0;return t.apply(void 0,arguments)}}},7465:(t,e,r)=>{var n=r(8407);t.exports=function(){this.__data__=new n,this.size=0}},3779:t=>{t.exports=function(t){var e=this.__data__,r=e.delete(t);return this.size=e.size,r}},7599:t=>{t.exports=function(t){return this.__data__.get(t)}},4758:t=>{t.exports=function(t){return this.__data__.has(t)}},4309:(t,e,r)=>{var n=r(8407),i=r(7071),o=r(3369);t.exports=function(t,e){var r=this.__data__;if(r instanceof n){var s=r.__data__;if(!i||s.length<199)return s.push([t,e]),this.size=++r.size,this;r=this.__data__=new o(s)}return r.set(t,e),this.size=r.size,this}},346:t=>{var e=Function.prototype.toString;t.exports=function(t){if(null!=t){try{return e.call(t)}catch(t){}try{return t+""}catch(t){}}return""}},5703:t=>{t.exports=function(t){return function(){return t}}},7813:t=>{t.exports=function(t,e){return t===e||t!=t&&e!=e}},6557:t=>{t.exports=function(t){return t}},5694:(t,e,r)=>{var n=r(9454),i=r(7005),o=Object.prototype,s=o.hasOwnProperty,a=o.propertyIsEnumerable,c=n(function(){return arguments}())?n:function(t){return i(t)&&s.call(t,"callee")&&!a.call(t,"callee")};t.exports=c},1469:t=>{var e=Array.isArray;t.exports=e},8612:(t,e,r)=>{var n=r(3560),i=r(1780);t.exports=function(t){return null!=t&&i(t.length)&&!n(t)}},9246:(t,e,r)=>{var n=r(8612),i=r(7005);t.exports=function(t){return i(t)&&n(t)}},4144:(t,e,r)=>{t=r.nmd(t);var n=r(5639),i=r(5062),o=e&&!e.nodeType&&e,s=o&&t&&!t.nodeType&&t,a=s&&s.exports===o?n.Buffer:void 0,c=(a?a.isBuffer:void 0)||i;t.exports=c},3560:(t,e,r)=>{var n=r(4239),i=r(3218);t.exports=function(t){if(!i(t))return!1;var e=n(t);return"[object Function]"==e||"[object GeneratorFunction]"==e||"[object AsyncFunction]"==e||"[object Proxy]"==e}},1780:t=>{t.exports=function(t){return"number"==typeof t&&t>-1&&t%1==0&&t<=9007199254740991}},3218:t=>{t.exports=function(t){var e=typeof t;return null!=t&&("object"==e||"function"==e)}},7005:t=>{t.exports=function(t){return null!=t&&"object"==typeof t}},8630:(t,e,r)=>{var n=r(4239),i=r(5924),o=r(7005),s=Function.prototype,a=Object.prototype,c=s.toString,u=a.hasOwnProperty,l=c.call(Object);t.exports=function(t){if(!o(t)||"[object Object]"!=n(t))return!1;var e=i(t);if(null===e)return!0;var r=u.call(e,"constructor")&&e.constructor;return"function"==typeof r&&r instanceof r&&c.call(r)==l}},6719:(t,e,r)=>{var n=r(8749),i=r(1717),o=r(1167),s=o&&o.isTypedArray,a=s?i(s):n;t.exports=a},1704:(t,e,r)=>{var n=r(4636),i=r(313),o=r(8612);t.exports=function(t){return o(t)?n(t,!0):i(t)}},2492:(t,e,r)=>{var n=r(2980),i=r(1463)((function(t,e,r){n(t,e,r)}));t.exports=i},5062:t=>{t.exports=function(){return!1}},9881:(t,e,r)=>{var n=r(8363),i=r(1704);t.exports=function(t){return n(t,i(t))}}},e={};function r(n){var i=e[n];if(void 0!==i)return i.exports;var o=e[n]={id:n,loaded:!1,exports:{}};return t[n](o,o.exports,r),o.loaded=!0,o.exports}r.n=t=>{var e=t&&t.__esModule?()=>t.default:()=>t;return r.d(e,{a:e}),e},r.d=(t,e)=>{for(var n in e)r.o(e,n)&&!r.o(t,n)&&Object.defineProperty(t,n,{enumerable:!0,get:e[n]})},r.g=function(){if("object"==typeof globalThis)return globalThis;try{return this||new Function("return this")()}catch(t){if("object"==typeof window)return window}}(),r.o=(t,e)=>Object.prototype.hasOwnProperty.call(t,e),r.nmd=t=>(t.paths=[],t.children||(t.children=[]),t);var n={};return(()=>{"use strict";r.d(n,{default:()=>l});var t=r(2492),e=r.n(t);function i(t,e){for(var r=0;r<e.length;r++){var n=e[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(t,n.key,n)}}function o(t){return o="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},o(t)}var s={placeholder:"",includeBlank:!1,singleSelectionShowDirectly:!1,selectAllText:"Select all",messages:{all:"All selected",singular:"{count} selected",plural:"{count} selected"},search:{enabled:!1,minLength:1,noResultsMessage:"No options match {s}"}};function a(t){for(var e="",r="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",n=0;n<t;n++)e+=r.charAt(Math.floor(Math.random()*r.length));return e}var c=function(){function t(r,n){if(function(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}(this,t),!r||"SELECT"!=r.nodeName)throw new Error("`el` parameter must be a select element.");if(void 0!==n&&(!(i=n)||"object"!==o(i)||Array.isArray(i)))throw new Error("`options` parameter must be an object.");var i;this.select=r,this.options=e()({},s,n),this.checkCompatibility()}var r,n;return r=t,n=[{key:"checkCompatibility",value:function(){if(this.options.includeBlank&&this.options.search.enabled)throw new Error("Cannot have both search and includeBlank enabled at the same time.");if(this.options.search.enabled){if(!Number.isFinite(this.options.search.minLength))throw new Error("`search.minLength` option must be a number");if(this.options.search.minLength<1)throw new Error("`search.minLength` must be greater than 0.")}if("string"!=typeof this.options.messages.singular)throw new Error("The value of the option `messages.singular` must be a string.");if("string"!=typeof this.options.messages.plural)throw new Error("The value of the option `messages.plural` must be a string.")}},{key:"enable",value:function(){this.select.style.display="none",this.buildUI(),this.bindEvents(),this.backportSelections(),this.updateSelectionTarget(),this.filterText="",this.select.__checkboxMultiselectInstance=this,this.ready=!0}},{key:"buildUI",value:function(){var t=this,e=a(10);this.wrapper=document.createElement("div"),this.wrapper.classList.add("dropdown-checkboxes"),this.hint=document.createElement("div"),this.hint.classList.add("dropdown-checkboxes__hints"),this.hint.setAttribute("aria-live","polite"),this.wrapper.append(this.hint),this.list=document.createElement("ul"),this.list.id=e,this.list.setAttribute("role","listbox"),this.list.setAttribute("aria-hidden","true"),this.list.setAttribute("aria-multiselectable","true"),this.list.classList.add("dropdown-checkboxes__list"),this.selectionTarget=document.createElement("div"),this.selectionTarget.id=a(10),this.selectionTarget.setAttribute("role","combobox"),this.selectionTarget.setAttribute("aria-expanded","false"),this.selectionTarget.setAttribute("aria-haspopup","listbox"),this.selectionTarget.setAttribute("aria-controls",e),this.selectionTarget.tabIndex=0,this.selectionTarget.classList.add("dropdown-checkboxes__selection"),this.select.disabled&&this.selectionTarget.setAttribute("aria-disabled","true");var r=document.querySelector("label[for='"+this.select.id+"']");r&&(r.id||(r.id=a(10)),this.selectionTarget.setAttribute("aria-labelledby",r.id),r.setAttribute("for",this.selectionTarget.id)),this.wrapper.appendChild(this.selectionTarget),this.children=[],this._allChildren=[],this.options.search.enabled&&(this.searchWrapper=document.createElement("li"),this.searchWrapper.classList.add("dropdown-checkboxes__search-wrapper"),this.searchInput=document.createElement("input"),this.searchInput.id=a(10),this.searchInput.type="search",this.searchInput.setAttribute("aria-label","Search"),this.searchWrapper.appendChild(this.searchInput),this.list.appendChild(this.searchWrapper)),this.getSelectOptions().forEach((function(e){if(e.value||!1!==t.options.includeBlank){var r=document.createElement("li");r.classList.add("dropdown-checkboxes__option"),r.setAttribute("role","option"),r.tabIndex=0,r.id=a(10),r.dataset.value=e.value,r.innerText=e.innerText||t.options.selectAllText||t.options.placeholder,e.disabled&&r.setAttribute("aria-disabled","true"),t.children.push(r),t._allChildren.push(r),t.list.appendChild(r)}})),this.options.search.enabled&&(this.noMatchesTarget=document.createElement("li"),this.noMatchesTarget.setAttribute("aria-hidden","true"),this.list.appendChild(this.noMatchesTarget)),this.children.length>0&&this.list.setAttribute("aria-activedescendant",this.children[0].id),this.wrapper.appendChild(this.list),this.select.parentNode.insertBefore(this.wrapper,this.select.nextSibling)}},{key:"renderChildren",value:function(){var t=this;this._allChildren.forEach((function(e){t.children.includes(e)?e.setAttribute("aria-hidden","false"):e.setAttribute("aria-hidden","true")}))}},{key:"bindEvents",value:function(){var t,e,r=this;this.select.addEventListener("change",this.backportSelections.bind(this)),this.selectionTarget.addEventListener("click",this.toggleOpen.bind(this)),this.children.forEach((function(t){t.addEventListener("click",(function(t){t.preventDefault(),r.toggleSelection(t.target)}))})),this.searchInput&&this.searchInput.addEventListener("keyup",(t=function(t){var e=r.searchInput.value;r.filter(e)},250,e=null,function(r){for(var n=arguments.length,i=new Array(n>1?n-1:0),o=1;o<n;o++)i[o-1]=arguments[o];clearTimeout(e),e=window.setTimeout((function(){return t.apply(r,i)}),250)})),document.addEventListener("keydown",(function(t){if(r.isOpen()&&!r.isDisabled())switch(t.which){case 40:case 9:t.preventDefault(),r.focusNextOption();break;case 38:t.preventDefault(),r.focusPreviousOption();break;case 27:r.close(),r.selectionTarget.focus();break;case 13:case 32:r.getIndexOfActiveElement()>-1&&(t.preventDefault(),r.toggleSelection(r.children[r.getIndexOfActiveElement()]));break;case 36:t.preventDefault(),r.focusOnOptionAt(0);break;case 35:t.preventDefault(),r.focusOnOptionAt(r.children.length-1)}})),this.selectionTarget.addEventListener("keydown",(function(t){switch(t.which){case 32:case 40:case 13:t.preventDefault(),t.stopPropagation(),r.open()}})),document.addEventListener("click",(function(t){var e=t.target;if(r.isOpen()&&!r.isDisabled()){do{if(e==r.wrapper)return;e=e.parentNode}while(e);r.close()}}))}},{key:"isDisabled",value:function(){return"true"===this.selectionTarget.getAttribute("aria-disabled")}},{key:"filter",value:function(t){var e=this.filterText!=t;if(this.filterText=t,e){var r,n,i;if(t.trim().length<this.options.search.minLength)return this.resetChildren(),this.updateHint("Showing all ".concat(this.getValidChildrenCount()," options")),null===(r=this.noMatchesTarget)||void 0===r||r.setAttribute("aria-hidden","true"),void this.renderChildren();this.children=this._allChildren.filter((function(e){return e.innerText.toLowerCase().indexOf(t.toLowerCase())>=0})),0===this.children.length?(this.updateHint(this.options.search.noResultsMessage.replace("{s}",t)),this.noMatchesTarget.innerText=this.options.search.noResultsMessage.replace("{s}",t),null===(n=this.noMatchesTarget)||void 0===n||n.setAttribute("aria-hidden","false")):(this.updateHint("Showing ".concat(this.children.length," options matching ").concat(t)),null===(i=this.noMatchesTarget)||void 0===i||i.setAttribute("aria-hidden","true")),this.renderChildren()}}},{key:"getValidChildrenCount",value:function(){return this._allChildren.filter((function(t){return t.dataset.value})).length}},{key:"value",value:function(){return this._allChildren.filter((function(t){return t.dataset.value&&"true"==t.getAttribute("aria-selected")})).map((function(t){return t.dataset.value}))}},{key:"getSelectedLabels",value:function(){return this._allChildren.filter((function(t){return t.dataset.value&&"true"==t.getAttribute("aria-selected")})).map((function(t){return t.innerText}))}},{key:"backportSelections",value:function(){var t=this;this.getSelectOptions().forEach((function(e,r){t._allChildren.forEach((function(t){t.dataset.value==e.value&&(e.selected?t.setAttribute("aria-selected","true"):t.removeAttribute("aria-selected"))}))})),this.updateSelectionTarget()}},{key:"updateHint",value:function(t){this.hint.innerText=t}},{key:"updateSelectionTarget",value:function(){var t=this._allChildren.filter((function(t){return!!t.dataset.value})),e=t.filter((function(t){return"true"==t.getAttribute("aria-selected")})).length;0===e?this.selectionTarget.innerText=this.options.placeholder:e===t.length?this.selectionTarget.innerText=this.options.messages.all:1===e?this.options.singleSelectionShowDirectly?this.selectionTarget.innerText=this.getSelectedLabels()[0]:this.selectionTarget.innerText=this.options.messages.singular.replace("{count}",e.toString()):this.selectionTarget.innerText=this.options.messages.plural.replace("{count}",e.toString())}},{key:"getIndexOfActiveElement",value:function(){return this.children.indexOf(document.activeElement)}},{key:"focusOnOptionAt",value:function(t){this.children[t].focus(),this.list.setAttribute("aria-activedescendant",this.children[t].id)}},{key:"focusOnSearchInput",value:function(){this.searchInput.focus(),this.updateHint("You are focused on the search, type to filter options, or use the up and down arrows to navigate through the options")}},{key:"focusNextOption",value:function(){var t=this.getIndexOfActiveElement(),e=0;this.options.search.enabled&&t>=this.children.length-1?this.focusOnSearchInput():(t>-1&&(e=t>=this.children.length-1?0:t+1),this.focusOnOptionAt(e))}},{key:"focusPreviousOption",value:function(){var t=this.getIndexOfActiveElement(),e=0;this.options.search.enabled&&0===t?this.focusOnSearchInput():t>-1?(e=0===t?this.children.length-1:t-1,this.focusOnOptionAt(e)):this.focusOnOptionAt(this.children.length-1)}},{key:"toggleOpen",value:function(t){t&&t.preventDefault(),this.isOpen()?this.close():this.open()}},{key:"isSearchFocused",value:function(){return document.activeElement==this.searchInput}},{key:"isOpen",value:function(){return this.wrapper.classList.contains("dropdown-checkboxes--open")}},{key:"close",value:function(){var t;this.wrapper.classList.remove("dropdown-checkboxes--open"),this.list.setAttribute("aria-hidden","true"),this.selectionTarget.setAttribute("aria-expanded","false"),null===(t=this.noMatchesTarget)||void 0===t||t.setAttribute("aria-hidden","true"),this.updateHint("Collapsed"),this.resetChildren(),this.renderChildren(),this.clearSearchInput()}},{key:"open",value:function(){var t=this;this.isDisabled()||(this.wrapper.classList.add("dropdown-checkboxes--open"),this.list.setAttribute("aria-hidden","false"),this.selectionTarget.setAttribute("aria-expanded","true"),setTimeout((function(){t.options.search.enabled?t.focusOnSearchInput():(t.getSelectOptions(),t.focusOn(t.children[0]))}),120))}},{key:"focusOn",value:function(t){t.focus(),this.list.setAttribute("aria-activedescendant",t.id)}},{key:"getSelectOptions",value:function(){return Array.prototype.slice.call(this.select.options)}},{key:"toggleSelection",value:function(t){if("true"!==t.getAttribute("aria-disabled")&&!this.isDisabled()){var e=t.dataset.value;this.list.setAttribute("aria-activedescendant",t.id),"true"==t.getAttribute("aria-selected")?t.removeAttribute("aria-selected"):t.setAttribute("aria-selected","true"),this.options.includeBlank?e?this.adjustSelectAll():this.toggleSelectAll("true"==t.getAttribute("aria-selected")):this.getSelectOptions().forEach((function(r){r.value==e&&(r.selected="true"==t.getAttribute("aria-selected"))})),this.updateSelectionTarget()}}},{key:"toggleSelectAll",value:function(t){this.children.forEach((function(e){e.dataset.value&&e.setAttribute("aria-selected",t?"true":"false")})),this.getSelectOptions().forEach((function(e){e.value&&(e.selected=!!t)}))}},{key:"adjustSelectAll",value:function(){var t=this.children.filter((function(t){return t.dataset.value&&"true"==t.getAttribute("aria-selected")})).length;this.getSelectOptions()[0].selected=0==t,0==t?this.children[0].setAttribute("aria-selected","true"):this.children[0].removeAttribute("aria-selected")}},{key:"getOptionsCollection",value:function(){return this.select.options}},{key:"clearSearchInput",value:function(){this.searchInput&&(this.searchInput.value="")}},{key:"resetChildren",value:function(){this.children=this._allChildren}}],n&&i(r.prototype,n),Object.defineProperty(r,"prototype",{writable:!1}),t}();const u=c,l=function(t,e){var r=new u(t,e);return{value:function(){return r.value()},open:function(){return r.open()},close:function(){return r.close()},enable:function(){return r.enable()},__dangerouslyGetInternal:function(){return r}}}})(),n.default})()}));
