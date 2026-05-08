<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import HeaderBar from '@/components/HeaderBar.vue'
import { useThemeStore } from '@/stores/theme'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const theme = useThemeStore()
const auth = useAuthStore()

const hideHeader = computed(() => ['Login', 'Register'].includes(route.name as string))

onMounted(() => {
  auth.fetchCurrentUser()
})
</script>

<template>
  <div class="min-h-screen">
    <HeaderBar v-if="!hideHeader" />
    <main :class="hideHeader ? '' : 'pt-16'">
      <router-view />
    </main>
  </div>
</template>
