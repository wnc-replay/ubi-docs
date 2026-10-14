import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'Ubisoft API Docs',
  description: 'Unofficial reference for Ubisoft Connect / ubi-services endpoints',
  lang: 'en-US',
  base: '/ubi-docs/',
  lastUpdated: true,
  cleanUrls: true,
  ignoreDeadLinks: 'localhostLinks',
  themeConfig: {
    siteTitle: 'Ubisoft API',
    nav: [
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Endpoints', link: '/endpoints/' },
      { text: 'Identifiers', link: '/guide/identifiers' },
    ],
    search: { provider: 'local' },
    outline: { level: [2, 3] },
    sidebar: {
      '/guide/': [
        {
          text: 'Guide',
          items: [
            { text: 'Introduction', link: '/' },
            { text: 'Getting started', link: '/guide/getting-started' },
            { text: 'Environments', link: '/guide/environments' },
            { text: 'Authentication', link: '/guide/authentication' },
            { text: 'Ticket exchange', link: '/guide/ticket-exchange' },
            { text: 'Headers', link: '/guide/headers' },
            { text: 'Identifiers', link: '/guide/identifiers' },
            { text: 'Application & space catalogue', link: '/guide/application-space-catalogue' },
            { text: 'Common types', link: '/guide/common-types' },
            { text: 'Compressed payloads', link: '/guide/compressed-payloads' },
            { text: 'GraphQL', link: '/guide/graphql' },
            { text: 'Errors', link: '/guide/errors' },
          ],
        },
      ],
      '/endpoints/': [
        {
          text: 'Reference',
          items: [
            { text: 'All endpoints', link: '/endpoints/' },
            { text: 'Auth & session', link: '/endpoints/auth' },
            { text: 'Cross-channel SSO', link: '/endpoints/sso' },
            { text: 'User & profile', link: '/endpoints/user' },
            { text: 'Presence', link: '/endpoints/presence' },
            { text: 'Applications & spaces', link: '/endpoints/applications' },
            { text: 'Inventory & offers', link: '/endpoints/inventory' },
            { text: 'Stats & rank', link: '/endpoints/stats' },
            { text: 'Bans & privileges', link: '/endpoints/bans' },
            { text: 'Marketplace & GraphQL', link: '/endpoints/marketplace' },
            { text: 'Consent & privacy', link: '/endpoints/consent' },
            { text: 'Support', link: '/endpoints/support' },
            { text: 'Bug reporter', link: '/endpoints/bug-reporter' },
            { text: 'Account management', link: '/endpoints/account' },
            { text: 'CDN & CMS', link: '/endpoints/cdn' },
            { text: 'Misc', link: '/endpoints/misc' },
          ],
        },
      ],
    },
    socialLinks: [],
    footer: {
      message: 'Unofficial community documentation. Not affiliated with Ubisoft.',
      copyright: 'Compiled from observed client traffic. Last updated 2026-09-20.',
    },
  },
})
