<script setup lang="ts">
import { computed, ref, provide } from 'vue'
import OverviewView from './components/OverviewView.vue'
import ServersView from './components/ServersView.vue'
import ChannelsView from './components/ChannelsView.vue'
import OperationsView from './components/OperationsView.vue'
import MessagesView from './components/MessagesView.vue'

const props = defineProps<{ asyncapi: Record<string, any> }>()
provide('asyncapi', props.asyncapi)

const filter = ref('')
const view = ref('overview')
const views = [
  { id: 'overview', label: 'Overview' },
  { id: 'servers', label: 'Servers' },
  { id: 'channels', label: 'Channels' },
  { id: 'operations', label: 'Operations' },
  { id: 'messages', label: 'Messages' },
]

const info = computed(() => (props.asyncapi.info as any) || {})
</script>

<template>
  <div class="docs">
    <header class="docs-header">
      <h1>{{ info.title || 'AsyncAPI document' }}</h1>
      <p v-if="props.asyncapi.asyncapi" class="version">
        AsyncAPI {{ props.asyncapi.asyncapi }}
      </p>
      <input
        v-model="filter"
        class="filter"
        type="search"
        placeholder="Filter…"
        aria-label="Filter sections"
      />
      <nav aria-label="Sections">
        <button
          v-for="v in views"
          :key="v.id"
          class="nav-btn"
          :class="{ active: view === v.id }"
          @click="view = v.id"
        >
          {{ v.label }}
        </button>
      </nav>
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
