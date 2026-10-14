<script setup lang="ts">
import { computed } from 'vue'
import { withBase } from 'vitepress'
import { hosts, type HostKey } from '../../data/hosts'

const props = withDefaults(
  defineProps<{
    method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE'
    path: string
    host?: HostKey | 'custom'
    origin?: string
    auth?: 'ticket' | 'basic' | 'basic-or-ticket' | 'sso' | 'none'
    appId?: string
    appHref?: string
  }>(),
  {
    host: 'public',
    auth: 'ticket',
  }
)

const origin = computed(() => {
  if (props.origin) return props.origin
  if (props.host === 'custom') return ''
  return hosts[props.host]
})

const fullUrl = computed(() => `${origin.value}${props.path}`)

const authLabel = computed(() => {
  switch (props.auth) {
    case 'basic':
      return { text: 'Basic (email:password)', href: withBase('/guide/authentication') + '#password-login' }
    case 'basic-or-ticket':
      return { text: 'Basic or ticket', href: withBase('/guide/authentication') }
    case 'sso':
      return { text: 'SSO session', href: withBase('/endpoints/sso') }
    case 'none':
      return { text: 'None', href: '' }
    default:
      return { text: 'Ticket', href: withBase('/guide/authentication') + '#ticket' }
  }
})

const hostLabels: Record<string, string> = {
  public: 'public-ubiservices',
  connect: 'connect',
  ecom: 'ecom (USS)',
  scs: 'ecom (SCS)',
  ess: 'ecom (ESS)',
  avatars: 'avatars CDN',
  cms: 'CMS',
  bugreporter: 'bug reporter',
}

const appLink = computed(() => (props.appHref ? withBase(props.appHref.split('#')[0]) + (props.appHref.includes('#') ? `#${props.appHref.split('#')[1]}` : '') : ''))
const envLink = computed(() => {
  const hash = ['ecom', 'scs', 'ess'].includes(props.host)
    ? '#ecommerce'
    : props.host === 'bugreporter'
      ? '#other-origins'
      : ''
  return withBase('/guide/environments') + hash
})
const hostLabel = computed(() => {
  if (props.host === 'custom') return props.origin || 'custom'
  return hostLabels[props.host] ?? props.host
})
</script>

<template>
  <div class="ep">
    <div class="ep-row">
      <span class="ep-method" :data-method="method">{{ method }}</span>
      <code class="ep-url">{{ fullUrl }}</code>
    </div>
    <dl class="ep-meta">
      <div>
        <dt>Auth</dt>
        <dd>
          <a v-if="authLabel.href" :href="authLabel.href">{{ authLabel.text }}</a>
          <span v-else>{{ authLabel.text }}</span>
        </dd>
      </div>
      <div v-if="appId">
        <dt>App ID</dt>
        <dd>
          <a v-if="appLink" :href="appLink">{{ appId }}</a>
          <span v-else>{{ appId }}</span>
        </dd>
      </div>
      <div>
        <dt>Host</dt>
        <dd>
          <a :href="envLink">{{ hostLabel }}</a>
        </dd>
      </div>
    </dl>
  </div>
</template>

<style scoped>
.ep {
  margin: 1.25rem 0;
  padding: 0.9rem 1rem;
  border: 1px solid var(--vp-c-divider);
  border-radius: 10px;
  background: var(--vp-c-bg-soft);
}

.ep-row {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.ep-method {
  font: 700 0.72rem/1.2 var(--vp-font-family-mono);
  letter-spacing: 0.06em;
  padding: 0.28rem 0.5rem;
  border-radius: 6px;
  color: #fff;
  flex-shrink: 0;
}

.ep-method[data-method='GET'] { background: #3a8a4a; }
.ep-method[data-method='POST'] { background: #2b6cb0; }
.ep-method[data-method='PUT'] { background: #c05621; }
.ep-method[data-method='PATCH'] { background: #6b46c1; }
.ep-method[data-method='DELETE'] { background: #c53030; }

.ep-url {
  font-size: 0.86rem;
  white-space: pre-wrap;
  word-break: break-all;
  background: transparent;
  padding: 0.15rem 0;
}

.ep-meta {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 0.65rem 1rem;
  margin: 0.85rem 0 0;
}

.ep-meta div { margin: 0; }

.ep-meta dt {
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--vp-c-text-2);
  font-weight: 600;
}

.ep-meta dd {
  margin: 0.15rem 0 0;
  font-size: 0.9rem;
}
</style>
