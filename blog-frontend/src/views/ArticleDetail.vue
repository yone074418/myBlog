<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { marked } from 'marked'
import { articleApi } from '@/api/articles'
import { commentApi } from '@/api/comments'
import { useAuthStore } from '@/stores/auth'
import type { Article, Comment } from '@/types'
import hljs from 'highlight.js'

const route = useRoute()
const auth = useAuthStore()
const article = ref<Article | null>(null)
const comments = ref<Comment[]>([])
const loading = ref(true)
const newComment = ref('')
const replyTo = ref<{ id: number; name: string } | null>(null)

// Configure marked with highlight.js
marked.setOptions({
  breaks: true,
  gfm: true,
  highlight(code: string, lang: string) {
    if (lang && hljs.getLanguage(lang)) {
      return hljs.highlight(code, { language: lang }).value
    }
    return hljs.highlightAuto(code).value
  },
} as any)

const renderedContent = computed(() => {
  if (!article.value?.content) return ''
  return marked.parse(article.value.content) as string
})

async function fetchArticle() {
  loading.value = true
  try {
    const res = await articleApi.getById(Number(route.params.id))
    article.value = res.data.data
  } finally {
    loading.value = false
  }
}

async function fetchComments() {
  try {
    const res = await commentApi.listByArticle(Number(route.params.id))
    comments.value = res.data.data
  } catch {}
}

function startReply(comment: Comment) {
  replyTo.value = { id: comment.id, name: comment.authorName }
  newComment.value = `@${comment.authorName} `
}

async function submitComment() {
  if (!newComment.value.trim()) return
  try {
    await commentApi.create(
      Number(route.params.id),
      newComment.value,
      replyTo.value?.id,
      undefined,
    )
    newComment.value = ''
    replyTo.value = null
    fetchComments()
  } catch {}
}

async function submitReply(parentId: number, content: string) {
  if (!content.trim()) return
  try {
    await commentApi.create(Number(route.params.id), content, parentId)
    fetchComments()
  } catch {}
}

onMounted(() => {
  fetchArticle()
  fetchComments()
})
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <div v-if="loading" class="text-center py-20 text-gray-500">加载中...</div>

    <template v-else-if="article">
      <!-- 文章头部 -->
      <div class="mb-8">
        <div class="flex items-center gap-2 text-sm text-gray-500 mb-3">
          <router-link :to="`/?categoryId=${article.categoryId}`" class="hover:text-primary-500">
            {{ article.categoryName }}
          </router-link>
          <span>·</span>
          <span>{{ new Date(article.publishTime).toLocaleDateString() }}</span>
        </div>

        <h1 class="text-3xl font-bold mb-4 text-gray-900 dark:text-gray-100">{{ article.title }}</h1>

        <div class="flex items-center gap-3 mb-4">
          <router-link :to="`/user/${article.userId}`" class="flex items-center gap-2 hover:text-primary-500">
            <div class="w-8 h-8 rounded-full bg-primary-500 flex items-center justify-center text-white text-xs font-bold">
              {{ article.authorName?.[0] }}
            </div>
            <span class="text-sm font-medium">{{ article.authorName }}</span>
          </router-link>
        </div>

        <!-- 标签 -->
        <div v-if="article.tags && article.tags.length > 0" class="flex flex-wrap gap-2 mb-6">
          <router-link
            v-for="tag in article.tags"
            :key="tag.id"
            :to="`/?tagId=${tag.id}`"
            class="px-3 py-1 rounded-full text-xs font-medium hover:opacity-80"
            :style="{ backgroundColor: tag.color + '20', color: tag.color }"
          >{{ tag.name }}</router-link>
        </div>

        <!-- 封面图 -->
        <div v-if="article.coverImage" class="mb-8 rounded-xl overflow-hidden">
          <img :src="article.coverImage" :alt="article.title" class="w-full max-h-96 object-cover" />
        </div>
      </div>

      <!-- 文章内容 -->
      <div class="card p-8 mb-8">
        <div class="prose dark:prose-invert max-w-none" v-html="renderedContent"></div>
      </div>

      <!-- 互动 -->
      <div class="flex items-center gap-6 mb-8 text-sm text-gray-500">
        <span class="flex items-center gap-1">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
          </svg>
          {{ article.viewCount }} 阅读
        </span>
        <span class="flex items-center gap-1">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
          </svg>
          {{ article.likeCount }} 点赞
        </span>
        <span class="flex items-center gap-1">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
          </svg>
          {{ article.commentCount }} 评论
        </span>
      </div>

      <!-- 评论区 -->
      <div class="card p-6">
        <h3 class="font-bold mb-4">评论 ({{ comments.length }})</h3>

        <!-- 评论输入 -->
        <div v-if="auth.isLoggedIn()" class="mb-6">
          <div v-if="replyTo" class="text-sm text-gray-500 mb-2">
            回复 @{{ replyTo.name }}
            <button class="ml-2 text-primary-500 hover:underline" @click="replyTo = null">取消</button>
          </div>
          <textarea
            v-model="newComment"
            class="input-field min-h-[100px] resize-none"
            :placeholder="replyTo ? `回复 @${replyTo.name}...` : '写下你的评论...'"
          ></textarea>
          <div class="flex justify-end mt-2">
            <button class="btn-primary text-sm" @click="submitComment">发表评论</button>
          </div>
        </div>
        <p v-else class="text-sm text-gray-500 mb-6">
          <router-link to="/login" class="text-primary-500 hover:underline">登录</router-link> 后参与评论
        </p>

        <!-- 评论列表 -->
        <div v-if="comments.length === 0" class="text-center py-8 text-gray-400 text-sm">
          暂无评论，快来抢沙发吧~
        </div>
        <div v-else class="space-y-4">
          <div v-for="comment in comments" :key="comment.id" class="border-b border-gray-100 dark:border-gray-700 pb-4 last:border-0">
            <div class="flex items-start gap-3">
              <div class="w-8 h-8 rounded-full bg-gray-300 dark:bg-gray-600 flex items-center justify-center text-xs font-bold flex-shrink-0">
                {{ comment.authorName?.[0] }}
              </div>
              <div class="flex-1 min-w-0">
                <div class="flex items-center gap-2 mb-1">
                  <span class="text-sm font-medium">{{ comment.authorName }}</span>
                  <span class="text-xs text-gray-500">{{ new Date(comment.createTime).toLocaleDateString() }}</span>
                </div>
                <p class="text-sm text-gray-700 dark:text-gray-300 mb-2">{{ comment.content }}</p>
                <button
                  v-if="auth.isLoggedIn()"
                  class="text-xs text-gray-500 hover:text-primary-500"
                  @click="startReply(comment)"
                >回复</button>

                <!-- 子回复 -->
                <div v-if="comment.replies && comment.replies.length > 0" class="mt-3 ml-4 space-y-3">
                  <div v-for="reply in comment.replies" :key="reply.id" class="border-l-2 border-gray-200 dark:border-gray-700 pl-3">
                    <div class="flex items-center gap-2 mb-1">
                      <span class="text-sm font-medium">{{ reply.authorName }}</span>
                      <span class="text-xs text-gray-500">{{ new Date(reply.createTime).toLocaleDateString() }}</span>
                    </div>
                    <p class="text-sm text-gray-700 dark:text-gray-300">{{ reply.content }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<style>
.prose pre {
  @apply bg-gray-900 text-gray-100 rounded-lg p-4 overflow-x-auto text-sm;
}
.prose code {
  @apply text-sm;
}
.prose img {
  @apply rounded-lg mx-auto;
}
.prose blockquote {
  @apply border-l-4 border-primary-500 pl-4 italic;
}
.prose a {
  @apply text-primary-500 hover:underline;
}
.prose h2 {
  @apply text-xl font-bold mt-8 mb-4;
}
.prose h3 {
  @apply text-lg font-bold mt-6 mb-3;
}
</style>
