import DefaultTheme from 'vitepress/theme'
import Endpoint from './components/Endpoint.vue'
import './style.css'
import type { Theme } from 'vitepress'

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component('Endpoint', Endpoint)
  },
} satisfies Theme
