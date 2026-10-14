import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const dist = path.join(root, 'docs/.vitepress/dist');
const base = '/ubi-docs/';
const escape = s => s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('"', '&quot;');
function walk(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap(e => e.isDirectory()
    ? walk(path.join(dir, e.name)) : [path.join(dir, e.name)]);
}
const pages = walk(dist).filter(p => p.endsWith('.html') && !p.endsWith('404.html')).map(p => {
  const html = fs.readFileSync(p, 'utf8');
  const main = html.match(/<main\b[^>]*>([\s\S]*?)<\/main>/)?.[1];
  const route = path.relative(dist, p).replaceAll('\\', '/').replace(/\.html$/, '');
  const key = route.replaceAll('/', '-');
  const title = html.match(/<title>(.*?)<\/title>/)?.[1].split(' | ')[0] || route;
  return { route, key, title, main };
}).filter(p => p.main);
pages.sort((a, b) => (a.route === 'guide/application-space-catalogue' ? -1 : b.route === 'guide/application-space-catalogue' ? 1 : a.route.localeCompare(b.route)));
const byRoute = new Map(pages.map(p => [p.route, p]));
const downloads = new Map(['appids.txt', 'spaceids.txt', 'app-spaces.json'].map(name => [
  `${base}identifiers/${name}`,
  `data:${name.endsWith('.json') ? 'application/json' : 'text/plain'};base64,${fs.readFileSync(path.join(dist, 'identifiers', name)).toString('base64')}`
]));
const sections = pages.map(page => {
  let content = page.main.replace(/<script\b[^>]*>[\s\S]*?<\/script>/gi, '')
    .replace(/\bid="([^"]+)"/g, (_, id) => `id="${page.key}--${id}"`)
    .replace(/href="([^"]+)"/g, (_, href) => {
      if (/^(https?:|mailto:|data:)/.test(href)) return `href="${href}"`;
      const url = new URL(href, `https://offline.invalid${base}${page.route}`);
      if (downloads.has(url.pathname)) return `download="${path.basename(url.pathname)}" href="${downloads.get(url.pathname)}"`;
      const route = url.pathname.replace(base, '').replace(/\.html$/, '').replace(/\/$/, '/index');
      const target = byRoute.get(route) || (url.pathname === base ? byRoute.get('index') : undefined);
      return `href="#${target ? target.key + (url.hash ? '--' + url.hash.slice(1) : '') : 'contents'}"`;
    });
  return `<section id="${page.key}">${content}</section>`;
});
const html = `<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Ubisoft API Docs — Review copy</title>
<style>
*{box-sizing:border-box}body{margin:0;background:#f8fafc;color:#172033;font:16px/1.65 system-ui,sans-serif}header,main{max-width:1120px;margin:auto;padding:32px}header{background:#eaf0fa}h1,h2,h3{line-height:1.25;color:#10192b}h1{font-size:30px}h2{margin-top:36px}a{color:#2457c5}nav ul{columns:2}section{padding:28px 0;border-top:2px solid #dce3ef;overflow-wrap:anywhere}code{font-family:Consolas,monospace;background:#edf1f6;padding:2px 5px;border-radius:4px;font-size:.9em}pre{padding:18px;background:#eef2f7;overflow:auto;white-space:pre-wrap}pre code{padding:0}table{border-collapse:collapse;width:100%;display:block;overflow:auto}th,td{padding:9px 12px;border:1px solid #ccd5e3;text-align:left}th{background:#edf1f6}li{margin:8px 0}.header-anchor,.copy,.lang{display:none}.custom-block{padding:12px 20px;background:#edf1f6;border-left:4px solid #6282bb}.shiki span{color:#253858!important}@media(max-width:650px){header,main{padding:18px}nav ul{columns:1}}@media print{body{background:white}section{break-before:page}nav ul{columns:2}}
</style><header id="contents"><h1>Ubisoft API documentation</h1><p>Offline review copy. Open this HTML file directly in a browser. Use Ctrl+F to find an application, ID, or endpoint. The ID downloads are embedded in this file.</p><nav><ul>${pages.map(p => `<li><a href="#${p.key}">${p.title}</a></li>`).join('')}</ul></nav></header><main>${sections.join('\n')}</main></html>`;
const output = path.join(root, 'output/ubisoft-api-docs-review.html');
fs.mkdirSync(path.dirname(output), { recursive: true });
fs.writeFileSync(output, html);
if (/lookupStatus|httpStatus/.test(sections.find((_, i) => pages[i].route === 'guide/application-space-catalogue') || '')) throw new Error('Catalogue contains lookup statuses');
console.log(`Saved ${pages.length} documentation pages to ${output} (${fs.statSync(output).size} bytes).`);
