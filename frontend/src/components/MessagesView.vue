<script setup lang="ts">
import { inject, computed } from 'vue'

const asyncapi = inject<Record<string, any>>('asyncapi') || {}
const props = defineProps<{ filter: string }>()

const entries = computed(() => {
  const messages = ((asyncapi.components as any)?.messages as any) || {}
  const q = props.filter.toLowerCase()
  return Object.entries(messages)
    .filter(([id, m]) => !q || `${id} ${JSON.stringify(m)}`.toLowerCase().includes(q))
    .map(([id, m]: [string, any]) => ({
      id,
      title: m.title || id,
      summary: m.summary || '',
      description: m.description || '',
      contentType: m.contentType || '',
      payloadType: m.payload?.type || '',
    }))
})
</script>

<template>
  <section aria-label="Messages">
    <h2>Messages</h2>
    <div v-for="m in entries" :key="m.id" class="message">
      <h3>{{ m.id }}</h3>
      <p v-if="m.contentType">Content type: <code>{{ m.contentType }}</code></p>
      <p v-if="m.summary">{{ m.summary }}</p>
      <p v-if="m.description">{{ m.description }}</p>
    </div>
    <p v-if="!entries.length">No messages match the filter.</p>
  </section>
</template>
