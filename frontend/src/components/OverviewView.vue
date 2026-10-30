<script setup lang="ts">
import { inject, computed } from 'vue'
import { t } from '../i18n'

const asyncapi = inject<Record<string, any>>('asyncapi') || {}
const props = defineProps<{ filter: string }>()

const info = computed(() => (asyncapi.info as any) || {})
const id = computed(() => (asyncapi.id as string) || '')
</script>

<template>
  <section :aria-label="t('overview.heading')">
    <h2>{{ t('overview.heading') }}</h2>
    <p v-if="id"><code>{{ id }}</code></p>
    <p v-if="info.description">{{ info.description }}</p>
    <p v-if="info.termsOfService">
      <a :href="info.termsOfService">{{ t('overview.termsOfService') }}</a>
    </p>
  </section>
</template>
