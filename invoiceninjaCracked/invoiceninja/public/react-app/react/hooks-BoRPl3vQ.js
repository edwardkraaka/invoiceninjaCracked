import{at as m,t as u,d9 as c,h as f}from"./index-CU6OOK94.js";import{r as l}from"./react-CDYlDoz2.js";import{a as e,c as i}from"./jotai-B6yoDLmd.js";import{u as T}from"./react-i18next-C77dzrxK.js";/**
 * Invoice Ninja (https://invoiceninja.com).
 *
 * @link https://github.com/invoiceninja/invoiceninja source repository
 *
 * @copyright Copyright (c) 2022. Invoice Ninja LLC (https://invoiceninja.com)
 *
 * @license https://www.elastic.co/licensing/elastic-license
 */const p=e(void 0),g=e(void 0),d=e(!1);e(!1);/**
 * Invoice Ninja (https://invoiceninja.com).
 *
 * @link https://github.com/invoiceninja/invoiceninja source repository
 *
 * @copyright Copyright (c) 2022. Invoice Ninja LLC (https://invoiceninja.com)
 *
 * @license https://www.elastic.co/licensing/elastic-license
 */function D(t){const a=i(p),o=i(d),{data:s}=m({id:t,enabled:!!t});l.useEffect(()=>{s&&(a(s),o(!0))},[s])}function S(){const{t}=T(),a=u({formatOnlyTime:!0});return o=>{const s=[];return c(o).map(([r,n])=>{s.push([f(r,"YYYY-MM-DD"),a(r),n===0?t("now"):a(n)])}),s}}export{g as a,D as b,p as c,d as i,S as u};
