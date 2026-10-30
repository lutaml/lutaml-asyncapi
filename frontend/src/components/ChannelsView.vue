<script setup lang="ts">
import { inject, computed } from 'vue'
import { t } from '../i18n'

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
  <section :aria-label="t('channels.heading')">
    <h2>{{ t('channels.heading') }}</h2>
    <div v-for="c in entries" :key="c.id" class="channel">
      <h3>{{ c.id }}</h3>
      <p v-if="c.address">{{ t('channels.address') }} <code>{{ c.address }}</code></p>
      <p v-if="c.summary">{{ c.summary }}</p>
      <p v-if="c.description">{{ c.description }}</p>
    </div>
    <p v-if="!entries.length">{{ t('channels.noMatch') }}</p>
  </section>
</template>
