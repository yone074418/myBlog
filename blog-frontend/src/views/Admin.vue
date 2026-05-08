<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { articleApi } from '@/api/articles'
import { categoryApi } from '@/api/categories'
import { tagApi } from '@/api/tags'
import type { Article, Category, Tag } from '@/types'

const activeTab = ref<'articles' | 'categories' | 'tags'>('articles')
const articles = ref<Article[]>([])
const categories = ref<Category[]>([])
const tags = ref<Tag[]>([])
const newCategoryName = ref('')
const newTagName = ref('')

async function fetchArticles() {
  const res = await articleApi.list({ page: 1, pageSize: 50 })
  articles.value = res.data.data.records
}

async function fetchCategories() {
  const res = await categoryApi.list()
  categories.value = res.data.data
}

async function fetchTags() {
  const res = await tagApi.list()
  tags.value = res.data.data
}

function deleteArticle(id: number) {
  articleApi.delete(id).then(fetchArticles)
}

onMounted(() => {
  fetchArticles()
  fetchCategories()
  fetchTags()
})
</script>

<template>
  <div class="max-w-6xl mx-auto px-4 py-8">
    <h1 class="text-2xl font-bold mb-6">管理后台</h1>

    <!-- 选项卡 -->
    <div class="flex gap-1 mb-6 border-b border-gray-200 dark:border-gray-700">
      <button
        v-for="tab in ['articles', 'categories', 'tags'] as const"
        :key="tab"
        class="px-4 py-2 text-sm font-medium transition-colors border-b-2 -mb-px"
        :class="activeTab === tab
          ? 'text-primary-500 border-primary-500'
          : 'text-gray-500 border-transparent hover:text-gray-700 dark:hover:text-gray-300'"
        @click="activeTab = tab"
      >{{ { articles: '文章管理', categories: '分类管理', tags: '标签管理' }[tab] }}</button>
    </div>

    <!-- 文章管理 -->
    <div v-if="activeTab === 'articles'">
      <div class="card overflow-hidden">
        <table class="w-full text-sm">
          <thead>
            <tr class="bg-gray-50 dark:bg-gray-800">
              <th class="text-left px-4 py-3 font-medium">标题</th>
              <th class="text-left px-4 py-3 font-medium hidden md:table-cell">状态</th>
              <th class="text-left px-4 py-3 font-medium hidden md:table-cell">阅读</th>
              <th class="text-left px-4 py-3 font-medium hidden md:table-cell">时间</th>
              <th class="text-left px-4 py-3 font-medium">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="article in articles" :key="article.id" class="border-t border-gray-100 dark:border-gray-700">
              <td class="px-4 py-3">
                <router-link :to="`/articles/${article.id}`" class="hover:text-primary-500 line-clamp-1">
                  {{ article.title }}
                </router-link>
              </td>
              <td class="px-4 py-3 hidden md:table-cell">
                <span class="px-2 py-0.5 rounded-full text-xs"
                  :class="article.status === 1 ? 'bg-green-100 text-green-600' : 'bg-yellow-100 text-yellow-600'">
                  {{ article.status === 1 ? '已发布' : '草稿' }}
                </span>
              </td>
              <td class="px-4 py-3 hidden md:table-cell">{{ article.viewCount }}</td>
              <td class="px-4 py-3 hidden md:table-cell text-gray-500">{{ new Date(article.createTime).toLocaleDateString() }}</td>
              <td class="px-4 py-3">
                <button class="text-red-500 hover:underline text-xs" @click="deleteArticle(article.id)">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 分类管理 -->
    <div v-if="activeTab === 'categories'">
      <div class="mb-4 flex gap-2">
        <input v-model="newCategoryName" placeholder="新分类名称" class="input-field max-w-xs" />
        <button class="btn-primary text-sm">添加</button>
      </div>
      <div class="card overflow-hidden">
        <table class="w-full text-sm">
          <thead>
            <tr class="bg-gray-50 dark:bg-gray-800">
              <th class="text-left px-4 py-3 font-medium">ID</th>
              <th class="text-left px-4 py-3 font-medium">名称</th>
              <th class="text-left px-4 py-3 font-medium">描述</th>
              <th class="text-left px-4 py-3 font-medium">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="cat in categories" :key="cat.id" class="border-t border-gray-100 dark:border-gray-700">
              <td class="px-4 py-3">{{ cat.id }}</td>
              <td class="px-4 py-3">{{ cat.name }}</td>
              <td class="px-4 py-3 text-gray-500">{{ cat.description }}</td>
              <td class="px-4 py-3">
                <button class="text-red-500 hover:underline text-xs">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 标签管理 -->
    <div v-if="activeTab === 'tags'">
      <div class="mb-4 flex gap-2">
        <input v-model="newTagName" placeholder="新标签名称" class="input-field max-w-xs" />
        <button class="btn-primary text-sm">添加</button>
      </div>
      <div class="card overflow-hidden">
        <table class="w-full text-sm">
          <thead>
            <tr class="bg-gray-50 dark:bg-gray-800">
              <th class="text-left px-4 py-3 font-medium">ID</th>
              <th class="text-left px-4 py-3 font-medium">名称</th>
              <th class="text-left px-4 py-3 font-medium">颜色</th>
              <th class="text-left px-4 py-3 font-medium">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="tag in tags" :key="tag.id" class="border-t border-gray-100 dark:border-gray-700">
              <td class="px-4 py-3">{{ tag.id }}</td>
              <td class="px-4 py-3">{{ tag.name }}</td>
              <td class="px-4 py-3">
                <span class="px-2 py-0.5 rounded text-xs text-white" :style="{ backgroundColor: tag.color }">{{ tag.color }}</span>
              </td>
              <td class="px-4 py-3">
                <button class="text-red-500 hover:underline text-xs">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
