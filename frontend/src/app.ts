import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

declare global {
  interface Window {
    ASYNCAPI_DATA?: Record<string, unknown>
  }
}

const data = window.ASYNCAPI_DATA || {}
createApp(App, { asyncapi: data }).mount('#app')
