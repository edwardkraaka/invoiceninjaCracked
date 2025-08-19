import{j as a,r as x}from"./react-CDYlDoz2.js";import{i as I,C,ay as m,bg as f,bh as N,h as k,bi as j,al as P,n as w,ax as E,bj as g,aB as D,z as y,bs as H,bz as L,as as M,f as F,be as T,aT as $}from"./index-CU6OOK94.js";import"./react-redux-CbZyTMVK.js";import"./classnames-DrFJrL3Z.js";import{u as V}from"./react-i18next-C77dzrxK.js";import"./react-debounce-input-C5KK--y1.js";import{y as h}from"./lodash-Dje-t9z8.js";function A(o){var d,v,c,u;const[s]=V(),{purchaseOrder:e,handleChange:t,errors:n}=o,i=I();return a.jsxs(a.Fragment,{children:[a.jsxs(C,{className:"col-span-12 xl:col-span-4 h-max",children:[a.jsx(m,{leftSide:s("purchase_order_date"),children:a.jsx(f,{type:"date",value:e.date,onValueChange:l=>t("date",l),errorMessage:n==null?void 0:n.errors.date})}),a.jsx(m,{leftSide:s("due_date"),children:a.jsx(f,{type:"date",value:e.due_date,onValueChange:l=>t("due_date",l),errorMessage:n==null?void 0:n.errors.due_date})}),a.jsx(m,{leftSide:s("partial"),children:a.jsx(N,{value:e.partial||"",onValueChange:l=>t("partial",parseFloat(l)||0),changeOverride:!0,errorMessage:n==null?void 0:n.errors.partial})}),e&&e.partial>0&&a.jsx(m,{leftSide:s("partial_due_date"),children:a.jsx(f,{type:"date",value:k(e.partial_due_date.toString(),"YYYY-MM-DD"),onValueChange:l=>t("partial_due_date",l),errorMessage:n==null?void 0:n.errors.partial_due_date})}),e&&((d=i==null?void 0:i.custom_fields)==null?void 0:d.invoice1)&&a.jsx(j,{field:"invoice1",defaultValue:(e==null?void 0:e.custom_value1)||"",value:i.custom_fields.invoice1,onValueChange:l=>t("custom_value1",l.toString())}),e&&((v=i==null?void 0:i.custom_fields)==null?void 0:v.invoice2)&&a.jsx(j,{field:"invoice2",defaultValue:(e==null?void 0:e.custom_value2)||"",value:i.custom_fields.invoice2,onValueChange:l=>t("custom_value2",l.toString())})]}),a.jsxs(C,{className:"col-span-12 xl:col-span-4 h-max",children:[a.jsx(m,{leftSide:s("po_number"),children:a.jsx(f,{value:e.number,onValueChange:l=>t("number",l),errorMessage:n==null?void 0:n.errors.number})}),a.jsx(m,{leftSide:s("discount"),children:a.jsxs(P,{children:[a.jsx("div",{className:"w-full lg:w-1/2",children:a.jsx(N,{value:e.discount||"",onValueChange:l=>t("discount",parseFloat(l)||0),errorMessage:n==null?void 0:n.errors.discount})}),a.jsx("div",{className:"w-full lg:w-1/2",children:a.jsxs(w,{value:e.is_amount_discount.toString(),onValueChange:l=>t("is_amount_discount",JSON.parse(l)),errorMessage:n==null?void 0:n.errors.is_amount_discount,children:[a.jsx("option",{value:"false",children:s("percent")}),a.jsx("option",{value:"true",children:s("amount")})]})})]})}),e&&((c=i==null?void 0:i.custom_fields)==null?void 0:c.invoice3)&&a.jsx(j,{field:"invoice3",defaultValue:(e==null?void 0:e.custom_value3)||"",value:i.custom_fields.invoice3,onValueChange:l=>t("custom_value3",l.toString())}),e&&((u=i==null?void 0:i.custom_fields)==null?void 0:u.invoice4)&&a.jsx(j,{field:"invoice4",defaultValue:(e==null?void 0:e.custom_value4)||"",value:i.custom_fields.invoice4,onValueChange:l=>t("custom_value4",l.toString())})]})]})}function K(o){const[s]=V(),{purchaseOrder:e,handleChange:t,isDefaultTerms:n,isDefaultFooter:i,setIsDefaultFooter:d,setIsDefaultTerms:v}=o,c=[s("terms"),s("footer"),s("public_notes"),s("private_notes")];return a.jsx(C,{className:"col-span-12 xl:col-span-8 h-max px-6",children:a.jsxs(E,{tabs:c,withoutVerticalMargin:!0,children:[a.jsxs("div",{children:[a.jsx(g,{value:e.terms||"",onChange:u=>t("terms",u)}),a.jsx(m,{className:"mt-4",leftSide:a.jsx(D,{checked:n,onValueChange:u=>v(u)}),noExternalPadding:!0,noVerticalPadding:!0,children:a.jsx("span",{className:"font-medium",children:s("save_as_default_terms")})})]}),a.jsxs("div",{children:[a.jsx(g,{value:e.footer||"",onChange:u=>t("footer",u)}),a.jsx(m,{className:"mt-4",leftSide:a.jsx(D,{checked:i,onValueChange:u=>d(u)}),noExternalPadding:!0,noVerticalPadding:!0,children:a.jsx("span",{className:"font-medium",children:s("save_as_default_footer")})})]}),a.jsx("div",{className:"mb-4",children:a.jsx(g,{value:e.public_notes||"",onChange:u=>t("public_notes",u)})}),a.jsx("div",{className:"mb-4",children:a.jsx(g,{value:e.private_notes||"",onChange:u=>t("private_notes",u)})})]})})}function Q(o){var b;const{t:s}=V(),{resource:e,initiallyVisible:t}=o,n=y(),i=H(),[d,v]=x.useState(),[c,u]=x.useState("");x.useEffect(()=>{c&&i.find(c).then(r=>v(r))},[c]),x.useEffect(()=>{var r;e&&u(e.vendor_id||((r=e.vendor)==null?void 0:r.id)||"")},[e==null?void 0:e.vendor_id,(b=e==null?void 0:e.vendor)==null?void 0:b.id]);const l=r=>{var _;return!!((_=o.resource)==null?void 0:_.invitations.find(p=>p.vendor_contact_id===r))};return a.jsxs(a.Fragment,{children:[a.jsxs("div",{className:"flex flex-col justify-between space-y-2",children:[o.readonly?a.jsx("p",{className:"text-sm",children:d==null?void 0:d.name}):a.jsx(L,{inputLabel:s("vendor"),onChange:r=>o.onChange(r.id),value:c,readonly:o.readonly,onClearButtonClick:o.onClearButtonClick,initiallyVisible:t,errorMessage:o.errorMessage}),d&&a.jsxs("div",{className:"space-x-2",children:[n("edit_vendor")&&a.jsx(M,{to:F("/vendors/:id/edit",{id:d.id}),children:s("edit_vendor")}),n("edit_vendor")&&a.jsx("span",{className:"text-sm",children:"/"}),(n("view_vendor")||n("edit_vendor"))&&a.jsx(M,{to:F("/vendors/:id",{id:d.id}),children:s("view_vendor")})]})]}),c&&d&&d.contacts.map((r,S)=>a.jsxs("div",{children:[a.jsx(T,{id:r.id,value:r.id,label:r.first_name.length>=1?`${r.first_name} ${r.last_name}`:r.email||d.name,checked:l(r.id),onValueChange:(_,p)=>o.onContactCheckboxChange(_,p||!1)}),r.first_name&&a.jsx("span",{className:"text-sm",children:r.email})]},S))]})}/**
 * Invoice Ninja (https://invoiceninja.com).
 *
 * @link https://github.com/invoiceninja/invoiceninja source repository
 *
 * @copyright Copyright (c) 2022. Invoice Ninja LLC (https://invoiceninja.com)
 *
 * @license https://www.elastic.co/licensing/elastic-license
 */function U(o){return async s=>{const e=h.cloneDeep(s);e.line_items.push({...$(),quantity:1}),o(e)}}/**
 * Invoice Ninja (https://invoiceninja.com).
 *
 * @link https://github.com/invoiceninja/invoiceninja source repository
 *
 * @copyright Copyright (c) 2022. Invoice Ninja LLC (https://invoiceninja.com)
 *
 * @license https://www.elastic.co/licensing/elastic-license
 */function W(o){return async(s,e)=>{const t=h.cloneDeep(s);t.line_items.splice(e,1),o(t)}}/**
 * Invoice Ninja (https://invoiceninja.com).
 *
 * @link https://github.com/invoiceninja/invoiceninja source repository
 *
 * @copyright Copyright (c) 2022. Invoice Ninja LLC (https://invoiceninja.com)
 *
 * @license https://www.elastic.co/licensing/elastic-license
 */function X(o){return(s,e,t)=>{let n=[...s.invitations];const i=(n==null?void 0:n.find(d=>d.vendor_contact_id===e))||-1;if(i!==-1&&t===!1&&(n=n.filter(d=>d.vendor_contact_id!==e)),i===-1){const d={vendor_contact_id:"",client_contact_id:""};d.vendor_contact_id=e,n.push(d)}o("invitations",n)}}/**
 * Invoice Ninja (https://invoiceninja.com).
 *
 * @link https://github.com/invoiceninja/invoiceninja source repository
 *
 * @copyright Copyright (c) 2022. Invoice Ninja LLC (https://invoiceninja.com)
 *
 * @license https://www.elastic.co/licensing/elastic-license
 */function Z(o){return(s,e,t,n)=>{const i=h.cloneDeep(s);i.line_items[n][e]!==t&&(h.set(i,`line_items.${n}.${e}`,t),o(i))}}/**
 * Invoice Ninja (https://invoiceninja.com).
 *
 * @link https://github.com/invoiceninja/invoiceninja source repository
 *
 * @copyright Copyright (c) 2022. Invoice Ninja LLC (https://invoiceninja.com)
 *
 * @license https://www.elastic.co/licensing/elastic-license
 */function O(o){return(s,e,t)=>{const n=h.cloneDeep(s);h.set(n,`line_items.${e}`,t),o(n)}}export{A as D,K as F,Q as V,W as a,U as b,Z as c,O as d,X as u};
