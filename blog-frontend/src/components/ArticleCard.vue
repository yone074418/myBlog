<script setup lang="ts">
import type { Article } from '@/types'

defineProps<{ article: Article }>()
</script>

<template>
  <article class="card p-5 hover:-translate-y-0.5 transition-all duration-300 cursor-pointer">
    <router-link :to="`/articles/${article.id}`" class="block">
      <!-- 置顶标签 -->
      <div v-if="article.isTop" class="flex items-center gap-1 mb-2">
        <span class="text-xs px-2 py-0.5 rounded-full bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 font-medium">
          置顶
        </span>
      </div>

      <div class="flex gap-4">
        <div class="flex-1 min-w-0">
          <!-- 标题 -->
          <h2 class="text-lg font-bold mb-2 line-clamp-2 hover:text-primary-500 transition-colors">
            {{ article.title }}
          </h2>

          <!-- 摘要 -->
          <p v-if="article.summary" class="text-sm text-gray-600 dark:text-gray-400 mb-3 line-clamp-2">
            {{ article.summary }}
          </p>

          <!-- 标签 -->
          <div v-if="article.tags && article.tags.length > 0" class="flex flex-wrap gap-1.5 mb-3">
            <span
              v-for="tag in article.tags"
              :key="tag.id"
              class="inline-block px-2 py-0.5 rounded text-xs font-medium"
              :style="{ backgroundColor: tag.color + '20', color: tag.color }"
            >{{ tag.name }}</span>
          </div>

          <!-- 元数据 -->
          <div class="flex items-center gap-4 text-xs text-gray-500">
            <span class="flex items-center gap-1">
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
              {{ article.authorName }}
            </span>
            <span>{{ new Date(article.publishTime).toLocaleDateString() }}</span>
            <span class="flex items-center gap-1">
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
              {{ article.viewCount }}
            </span>
            <span class="flex items-center gap-1">
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
              </svg>
              {{ article.likeCount }}
            </span>
            <span class="flex items-center gap-1">
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
              </svg>
              {{ article.commentCount }}
            </span>
          </div>
        </div>

        <!-- 封面图 -->
        <div v-if="article.coverImage" class="hidden sm:block w-32 h-24 flex-shrink-0 rounded-lg overflow-hidden">
          <img :src="article.coverImage" :alt="article.title" class="w-full h-full object-cover" />
        </div>
      </div>
    </router-link>
  </article>
</template>
