<script setup lang="ts">
import { inject, computed } from 'vue'

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
  <section aria-label="Operations">
    <h2>Operations</h2>
    <div v-for="op in entries" :key="op.id" class="op">
      <h3><span class="method" :class="op.action">{{ op.action }}</span> {{ op.id }}</h3>
      <p v-if="op.summary">{{ op.summary }}</p>
      <p v-if="op.description">{{ op.description }}</p>
    </div>
    <p v-if="!entries.length">No operations match the filter.</p>
  </section>
</template>
