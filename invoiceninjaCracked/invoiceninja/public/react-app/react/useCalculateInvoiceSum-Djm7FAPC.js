import{bs as r,aS as u,i,aU as t,aV as a}from"./index-C1TxVNmX.js";/**
 * Invoice Ninja (https://invoiceninja.com).
 *
 * @link https://github.com/invoiceninja/invoiceninja source repository
 *
 * @copyright Copyright (c) 2022. Invoice Ninja LLC (https://invoiceninja.com)
 *
 * @license https://www.elastic.co/licensing/elastic-license
 */function v(){const s=r(),o=u(),n=i();return async e=>{const c=await s.find(e);return o(c.currency_id||n.settings.currency_id)}}/**
 * Invoice Ninja (https://invoiceninja.com).
 *
 * @link https://github.com/invoiceninja/invoiceninja source repository
 *
 * @copyright Copyright (c) 2022. Invoice Ninja LLC (https://invoiceninja.com)
 *
 * @license https://www.elastic.co/licensing/elastic-license
 */function m(s){const o=v();return async n=>{const e=await o(n.vendor_id),c=n.uses_inclusive_taxes?new t(n,e).build():new a(n,e).build();return s(c),c.invoice}}export{m as u};
