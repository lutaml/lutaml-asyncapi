<script setup lang="ts">
import { inject, computed } from 'vue'
import { t } from '../i18n'

const asyncapi = inject<Record<string, any>>('asyncapi') || {}
const props = defineProps<{ filter: string }>()

const entries = computed(() => {
  const ops = (asyncapi.operations as any) || {}
  const q = props.filter.toLowerCase()
  return Object.entries(ops)
    .filter(([id, op]) => !q || `${id} ${JSON.stringify(op)}`.toLowerCase().includes(q))
    .map(([id, op]: [string, any]) => ({
      id,
      action: op.action,
      summary: op.summary || '',
      description: op.description || '',
    }))
})
</script>

<template>
  <section :aria-label="t('operations.heading')">
    <h2>{{ t('operations.heading') }}</h2>
    <div v-for="op in entries" :key="op.id" class="op">
      <h3><span class="method" :class="op.action">{{ op.action }}</span> {{ op.id }}</h3>
      <p v-if="op.summary">{{ op.summary }}</p>
      <p v-if="op.description">{{ op.description }}</p>
    </div>
    <p v-if="!entries.length">{{ t('operations.noMatch') }}</p>
  </section>
</template>
