<script setup lang="ts">
import { inject, computed } from 'vue'
import { t } from '../i18n'

const asyncapi = inject<Record<string, any>>('asyncapi') || {}
const props = defineProps<{ filter: string }>()

const entries = computed(() => {
  const servers = (asyncapi.servers as any) || {}
  const q = props.filter.toLowerCase()
  return Object.entries(servers)
    .filter(([name, s]) => !q || `${name} ${JSON.stringify(s)}`.toLowerCase().includes(q))
    .map(([name, s]: [string, any]) => ({
      name,
      url: s.url,
      protocol: s.protocol,
      protocolVersion: s.protocolVersion,
      description: s.description,
    }))
})
</script>

<template>
  <section :aria-label="t('servers.heading')">
    <h2>{{ t('servers.heading') }}</h2>
    <div v-for="s in entries" :key="s.name" class="server">
      <h3>{{ s.name }}</h3>
      <p><code>{{ s.url }}</code> — {{ s.protocol }}<span v-if="s.protocolVersion"> {{ s.protocolVersion }}</span></p>
      <p v-if="s.description">{{ s.description }}</p>
    </div>
    <p v-if="!entries.length">{{ t('servers.noMatch') }}</p>
  </section>
</template>
