<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { articleApi } from '@/api/articles'
import { useAuthStore } from '@/stores/auth'
import request from '@/api/request'
import type { Article, User } from '@/types'
import ArticleCard from '@/components/ArticleCard.vue'

const route = useRoute()
const auth = useAuthStore()
const profileUser = ref<User | null>(null)
const articles = ref<Article[]>([])
const loading = ref(true)
const isOwner = ref(false)

onMounted(async () => {
  loading.value = true
  try {
    const userId = Number(route.params.id)

    // Fetch profile user info if not current user
    if (auth.user?.id === userId) {
      profileUser.value = auth.user
      isOwner.value = true
    } else {
      const res = await request.get<{ data: User }>(`/users/${userId}`)
      profileUser.value = res.data.data
    }

    const res = await articleApi.listByUser(userId)
    articles.value = res.data.data.records
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <div class="card p-8 mb-6 text-center">
      <div class="w-20 h-20 rounded-full bg-primary-500 flex items-center justify-center text-white text-2xl font-bold mx-auto mb-4">
        {{ profileUser?.nickname?.[0] || profileUser?.username?.[0] || 'U' }}
      </div>
      <h1 class="text-2xl font-bold mb-1 text-gray-900 dark:text-gray-100">
        {{ profileUser?.nickname || profileUser?.username }}
      </h1>
      <p v-if="profileUser?.bio" class="text-gray-500 dark:text-gray-400 text-sm">{{ profileUser.bio }}</p>
    </div>

    <h2 class="text-lg font-bold mb-4 text-gray-900 dark:text-gray-100">文章列表</h2>
    <div v-if="loading" class="text-center py-12 text-gray-500 dark:text-gray-400">加载中...</div>
    <div v-else-if="articles.length === 0" class="text-center py-12 text-gray-500 dark:text-gray-400">暂无文章</div>
    <div v-else class="space-y-4">
      <ArticleCard v-for="article in articles" :key="article.id" :article="article" />
    </div>
  </div>
</template>
