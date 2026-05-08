<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { articleApi } from '@/api/articles'
import { categoryApi } from '@/api/categories'
import { tagApi } from '@/api/tags'
import type { Article, Category, Tag } from '@/types'
import ArticleCard from '@/components/ArticleCard.vue'

const route = useRoute()
const router = useRouter()
const articles = ref<Article[]>([])
const featuredArticles = ref<Article[]>([])
const categories = ref<Category[]>([])
const tags = ref<Tag[]>([])
const currentPage = ref(1)
const totalPages = ref(0)
const total = ref(0)
const sort = ref('latest')
const loading = ref(false)

async function fetchData() {
  loading.value = true
  try {
    const params: any = {
      page: currentPage.value,
      pageSize: 10,
      sort: sort.value,
    }
    if (route.query.categoryId) params.categoryId = Number(route.query.categoryId)
    if (route.query.tagId) params.tagId = Number(route.query.tagId)

    const [artRes, catRes, tagRes] = await Promise.all([
      articleApi.list(params),
      categoryApi.list(),
      tagApi.list(),
    ])

    articles.value = artRes.data.data.records
    totalPages.value = artRes.data.data.pages
    total.value = artRes.data.data.total
    categories.value = catRes.data.data
    tags.value = tagRes.data.data
  } finally {
    loading.value = false
  }
}

// Fetch featured articles separately
async function fetchFeatured() {
  try {
    const res = await articleApi.list({ page: 1, pageSize: 4, sort: 'hot' })
    featuredArticles.value = res.data.data.records.filter(a => a.isRecommend)
    if (featuredArticles.value.length === 0) {
      featuredArticles.value = res.data.data.records.slice(0, 4)
    }
  } catch {}
}

function changeSort(newSort: string) {
  sort.value = newSort
  currentPage.value = 1
  fetchData()
}

function filterByCategory(id?: number) {
  router.push({ query: id ? { ...route.query, categoryId: id } : {} })
}

function filterByTag(id?: number) {
  router.push({ query: id ? { ...route.query, tagId: id } : {} })
}

watch(() => route.query, fetchData)

onMounted(() => {
  fetchFeatured()
  fetchData()
})
</script>

<template>
  <div class="max-w-7xl mx-auto px-4 py-6">
    <!-- 精选推荐区 -->
    <div v-if="featuredArticles.length > 0" class="mb-8">
      <h2 class="text-lg font-bold mb-4 flex items-center gap-2 text-gray-900 dark:text-gray-100">
        <span class="text-primary-500">★</span> 精选推荐
      </h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <router-link
          v-for="article in featuredArticles"
          :key="article.id"
          :to="`/articles/${article.id}`"
          class="card group cursor-pointer overflow-hidden hover:-translate-y-1 hover:shadow-md
                 transition-all duration-300"
        >
          <div class="h-32 relative overflow-hidden bg-gray-200 dark:bg-gray-700">
            <img
              :src="article.coverImage || `https://picsum.photos/seed/${article.id}/400/200`"
              :alt="article.title"
              class="w-full h-full object-cover"
              loading="lazy"
            />
            <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
            <div class="absolute bottom-2 left-3 right-3">
              <h3 class="text-white font-medium text-sm line-clamp-2 group-hover:text-primary-200 transition-colors">
                {{ article.title }}
              </h3>
            </div>
          </div>
          <div class="p-3">
            <div class="flex items-center gap-2 text-xs text-gray-500">
              <span>{{ article.authorName }}</span>
              <span>·</span>
              <span>{{ new Date(article.publishTime).toLocaleDateString() }}</span>
            </div>
          </div>
        </router-link>
      </div>
    </div>

    <!-- 主内容区：左70% 右30% -->
    <div class="flex flex-col lg:flex-row gap-6">
      <!-- 左侧文章流 -->
      <div class="flex-1 lg:w-[70%]">
        <!-- 排序和筛选 -->
        <div class="flex items-center gap-4 mb-4">
          <button
            :class="sort === 'latest' ? 'text-primary-500 border-b-2 border-primary-500' : 'text-gray-600 dark:text-gray-400'"
            class="pb-1 text-sm font-medium hover:text-primary-500 transition-colors"
            @click="changeSort('latest')"
          >最新</button>
          <button
            :class="sort === 'hot' ? 'text-primary-500 border-b-2 border-primary-500' : 'text-gray-600 dark:text-gray-400'"
            class="pb-1 text-sm font-medium hover:text-primary-500 transition-colors"
            @click="changeSort('hot')"
          >最热</button>
        </div>

        <!-- 文章列表 -->
        <div v-if="loading" class="text-center py-12 text-gray-500">加载中...</div>
        <div v-else-if="articles.length === 0" class="text-center py-12 text-gray-500">暂无文章</div>
        <div v-else class="space-y-4">
          <ArticleCard v-for="article in articles" :key="article.id" :article="article" />
        </div>

        <!-- 分页 -->
        <div v-if="totalPages > 1" class="flex justify-center gap-2 mt-8">
          <button
            :disabled="currentPage <= 1"
            class="px-3 py-1.5 rounded-lg border border-gray-300 dark:border-gray-600
                   disabled:opacity-50 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors text-sm"
            @click="currentPage--; fetchData()"
          >上一页</button>
          <span class="px-3 py-1.5 text-sm text-gray-600 dark:text-gray-400">
            {{ currentPage }} / {{ totalPages }}
          </span>
          <button
            :disabled="currentPage >= totalPages"
            class="px-3 py-1.5 rounded-lg border border-gray-300 dark:border-gray-600
                   disabled:opacity-50 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors text-sm"
            @click="currentPage++; fetchData()"
          >下一页</button>
        </div>
      </div>

      <!-- 右侧边栏 -->
      <div class="lg:w-[30%] space-y-6">
        <!-- 分类 -->
        <div class="card p-4">
          <h3 class="font-bold mb-3 text-sm text-gray-900 dark:text-gray-100">文章分类</h3>
          <div class="space-y-1">
            <button
              class="w-full text-left px-3 py-2 rounded-lg text-sm hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
              @click="filterByCategory()"
            >全部分类</button>
            <button
              v-for="cat in categories"
              :key="cat.id"
              class="w-full text-left px-3 py-2 rounded-lg text-sm hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
              :class="{ 'text-primary-500 bg-primary-50 dark:bg-primary-900/20': Number(route.query.categoryId) === cat.id }"
              @click="filterByCategory(cat.id)"
            >{{ cat.name }}</button>
          </div>
        </div>

        <!-- 热门标签云 -->
        <div class="card p-4">
          <h3 class="font-bold mb-3 text-sm text-gray-900 dark:text-gray-100">热门标签</h3>
          <div class="flex flex-wrap gap-2">
            <button
              v-for="tag in tags"
              :key="tag.id"
              class="px-3 py-1 rounded-full text-xs font-medium transition-all hover:scale-105"
              :style="{ backgroundColor: tag.color + '20', color: tag.color }"
              @click="filterByTag(tag.id)"
            >{{ tag.name }}</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
