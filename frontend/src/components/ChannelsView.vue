<script setup lang="ts">
import { inject, computed } from 'vue'

const asyncapi = inject<Record<string, any>>('asyncapi') || {}
const props = defineProps<{ filter: string }>()

const entries = computed(() => {
  const channels = (asyncapi.channels as any) || {}
  const q = props.filter.toLowerCase()
  return Object.entries(channels)
    .filter(([id, c]) => !q || `${id} ${JSON.stringify(c)}`.toLowerCase().includes(q))
    .map(([id, c]: [string, any]) => ({
      id,
      address: c.address || id,
      summary: c.summary || '',
      description: c.description || '',
    }))
})
</script>

<template>
  <section aria-label="Channels">
    <h2>Channels</h2>
    <div v-for="c in entries" :key="c.id" class="channel">
      <h3>{{ c.id }}</h3>
      <p v-if="c.address">Address: <code>{{ c.address }}</code></p>
      <p v-if="c.summary">{{ c.summary }}</p>
      <p v-if="c.description">{{ c.description }}</p>
    </div>
    <p v-if="!entries.length">No channels match the filter.</p>
  </section>
</template>
