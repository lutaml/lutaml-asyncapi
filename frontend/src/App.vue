<script setup lang="ts">
import { computed, ref, provide, onMounted } from 'vue'
import OverviewView from './components/OverviewView.vue'
import ServersView from './components/ServersView.vue'
import ChannelsView from './components/ChannelsView.vue'
import OperationsView from './components/OperationsView.vue'
import MessagesView from './components/MessagesView.vue'
import { t, initLocaleFromUrl, localeLabel, nextLocale, setLocale } from './i18n'

const props = defineProps<{ asyncapi: Record<string, any> }>()
provide('asyncapi', props.asyncapi)

const filter = ref('')
const view = ref('overview')
const views = [
  { id: 'overview', label: 'nav.overview' },
  { id: 'servers', label: 'nav.servers' },
  { id: 'channels', label: 'nav.channels' },
  { id: 'operations', label: 'nav.operations' },
  { id: 'messages', label: 'nav.messages' },
]

onMounted(() => initLocaleFromUrl())

function switchLocale() {
  setLocale(nextLocale())
}

const info = computed(() => (props.asyncapi.info as any) || {})
</script>

<template>
  <div class="docs">
    <header class="docs-header">
      <h1>{{ info.title || t('app.titleFallback') }}</h1>
      <p v-if="props.asyncapi.asyncapi" class="version">
        AsyncAPI {{ props.asyncapi.asyncapi }}
      </p>
      <input
        v-model="filter"
        class="filter"
        type="search"
        :placeholder="t('app.filterPlaceholder')"
        :aria-label="t('app.filterAria')"
      />
      <nav :aria-label="t('nav.sections')">
        <button
          v-for="v in views"
          :key="v.id"
          class="nav-btn"
          :class="{ active: view === v.id }"
          @click="view = v.id"
        >
          {{ t(v.label) }}
        </button>
      </nav>
      <button
        class="nav-btn locale-btn"
        :title="t('app.switchLocale')"
        @click="switchLocale"
      >
        {{ localeLabel(nextLocale()) }}
      </button>
    </header>
    <main>
      <OverviewView v-if="view === 'overview'" :filter="filter" />
      <ServersView v-else-if="view === 'servers'" :filter="filter" />
      <ChannelsView v-else-if="view === 'channels'" :filter="filter" />
      <OperationsView v-else-if="view === 'operations'" :filter="filter" />
      <MessagesView v-else :filter="filter" />
    </main>
  </div>
</template>
