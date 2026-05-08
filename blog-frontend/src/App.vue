<script setup lang="ts">
import { onMounted } from 'vue'
import HeaderBar from '@/components/HeaderBar.vue'
import { useThemeStore } from '@/stores/theme'
import { useAuthStore } from '@/stores/auth'

const theme = useThemeStore()
const auth = useAuthStore()

onMounted(() => {
  auth.fetchCurrentUser()
})
</script>

<template>
  <div class="min-h-screen">
    <HeaderBar />
    <main class="pt-16">
      <router-view />
    </main>
  </div>
</template>
