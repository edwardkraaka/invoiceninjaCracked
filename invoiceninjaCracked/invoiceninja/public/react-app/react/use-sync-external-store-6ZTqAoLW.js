import{b as L}from"./react-CDYlDoz2.js";var _={exports:{}},q={};/**
 * @license React
 * use-sync-external-store-shim.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var g;function z(){if(g)return q;g=1;var u=L();function S(e,r){return e===r&&(e!==0||1/e===1/r)||e!==e&&r!==r}var d=typeof Object.is=="function"?Object.is:S,h=u.useState,p=u.useEffect,m=u.useLayoutEffect,x=u.useDebugValue;function y(e,r){var n=r(),i=h({inst:{value:n,getSnapshot:r}}),t=i[0].inst,s=i[1];return m(function(){t.value=n,t.getSnapshot=r,l(t)&&s({inst:t})},[e,n,r]),p(function(){return l(t)&&s({inst:t}),e(function(){l(t)&&s({inst:t})})},[e]),x(n),n}function l(e){var r=e.getSnapshot;e=e.value;try{var n=r();return!d(e,n)}catch{return!0}}function o(e,r){return r()}var c=typeof window>"u"||typeof window.document>"u"||typeof window.document.createElement>"u"?o:y;return q.useSyncExternalStore=u.useSyncExternalStore!==void 0?u.useSyncExternalStore:c,q}var k;function M(){return k||(k=1,_.exports=z()),_.exports}var F=M(),w={exports:{}},R={};/**
 * @license React
 * use-sync-external-store-shim/with-selector.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var D;function A(){if(D)return R;D=1;var u=L(),S=M();function d(o,c){return o===c&&(o!==0||1/o===1/c)||o!==o&&c!==c}var h=typeof Object.is=="function"?Object.is:d,p=S.useSyncExternalStore,m=u.useRef,x=u.useEffect,y=u.useMemo,l=u.useDebugValue;return R.useSyncExternalStoreWithSelector=function(o,c,e,r,n){var i=m(null);if(i.current===null){var t={hasValue:!1,value:null};i.current=t}else t=i.current;i=y(function(){function V(a){if(!W){if(W=!0,E=a,a=r(a),n!==void 0&&t.hasValue){var f=t.value;if(n(f,a))return v=f}return v=a}if(f=v,h(E,a))return f;var O=r(a);return n!==void 0&&n(f,O)?f:(E=a,v=O)}var W=!1,E,v,j=e===void 0?null:e;return[function(){return V(c())},j===null?void 0:function(){return V(j())}]},[c,e,r,n]);var s=p(o,i[0],i[1]);return x(function(){t.hasValue=!0,t.value=s},[s]),l(s),s},R}var U;function B(){return U||(U=1,w.exports=A()),w.exports}var G=B();export{F as s,G as w};
