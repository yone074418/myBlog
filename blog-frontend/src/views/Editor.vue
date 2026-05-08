<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { marked } from 'marked'
import { articleApi } from '@/api/articles'
import { categoryApi } from '@/api/categories'
import { tagApi } from '@/api/tags'
import type { Category, Tag } from '@/types'

const route = useRoute()
const router = useRouter()
const isEdit = computed(() => !!route.params.id)

const form = ref({
  title: '',
  summary: '',
  content: '',
  categoryId: null as number | null,
  coverImage: '',
  status: 0,
  tagIds: [] as number[],
})

const categories = ref<Category[]>([])
const tags = ref<Tag[]>([])
const saving = ref(false)
const saved = ref(false)
const errorMsg = ref('')

const previewHtml = computed(() => {
  if (!form.value.content) return '<p class="text-gray-400">开始编写...</p>'
  return marked.parse(form.value.content) as string
})

async function fetchMeta() {
  const [catRes, tagRes] = await Promise.all([
    categoryApi.list(),
    tagApi.list(),
  ])
  categories.value = catRes.data.data
  tags.value = tagRes.data.data
}

async function fetchArticle() {
  if (!route.params.id) return
  try {
    const res = await articleApi.getById(Number(route.params.id))
    const a = res.data.data
    form.value = {
      title: a.title,
      summary: a.summary || '',
      content: a.content,
      categoryId: a.categoryId,
      coverImage: a.coverImage || '',
      status: a.status,
      tagIds: a.tags?.map(t => t.id) || [],
    }
  } catch {}
}

async function save() {
  errorMsg.value = ''

  if (!form.value.title.trim()) {
    errorMsg.value = '请输入文章标题'
    return
  }
  if (!form.value.content.trim()) {
    errorMsg.value = '请输入文章内容'
    return
  }
  if (!form.value.categoryId) {
    errorMsg.value = '请选择文章分类'
    return
  }

  saving.value = true
  saved.value = false
  try {
    const data = {
      title: form.value.title,
      content: form.value.content,
      categoryId: form.value.categoryId!,
      summary: form.value.summary || undefined,
      coverImage: form.value.coverImage || undefined,
      status: form.value.status,
      tagIds: form.value.tagIds,
    }
    if (isEdit.value) {
      await articleApi.update(Number(route.params.id), data)
    } else {
      await articleApi.create(data)
    }
    saved.value = true
    setTimeout(() => { saved.value = false }, 2000)
  } catch (e: any) {
    errorMsg.value = e.response?.data?.message || e.message || '保存失败，请重试'
  } finally {
    saving.value = false
  }
}

async function publish() {
  form.value.status = 1
  saving.value = true
  errorMsg.value = ''

  if (!form.value.title.trim()) { errorMsg.value = '请输入文章标题'; saving.value = false; return }
  if (!form.value.content.trim()) { errorMsg.value = '请输入文章内容'; saving.value = false; return }
  if (!form.value.categoryId) { errorMsg.value = '请选择文章分类'; saving.value = false; return }

  try {
    const data = {
      title: form.value.title,
      content: form.value.content,
      categoryId: form.value.categoryId!,
      summary: form.value.summary || undefined,
      coverImage: form.value.coverImage || undefined,
      status: 1,
      tagIds: form.value.tagIds,
    }
    const res = isEdit.value
      ? await articleApi.update(Number(route.params.id), data)
      : await articleApi.create(data)

    const articleId = isEdit.value ? Number(route.params.id) : res.data.data.id
    router.push(`/articles/${articleId}`)
  } catch (e: any) {
    errorMsg.value = e.response?.data?.message || e.message || '发布失败，请重试'
  } finally {
    saving.value = false
  }
}

function toggleTag(tagId: number) {
  const idx = form.value.tagIds.indexOf(tagId)
  if (idx >= 0) {
    form.value.tagIds.splice(idx, 1)
  } else {
    form.value.tagIds.push(tagId)
  }
}

onMounted(() => {
  fetchMeta()
  if (isEdit.value) fetchArticle()
})
</script>

<template>
  <div class="h-[calc(100vh-3rem)] flex flex-col">
    <!-- 工具栏 -->
    <div class="flex items-center gap-3 px-4 py-2 border-b border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800">
      <input
        v-model="form.title"
        type="text"
        placeholder="输入文章标题..."
        class="flex-1 text-lg font-bold bg-transparent outline-none"
      />

      <select
        v-model="form.categoryId"
        class="text-sm border border-gray-300 dark:border-gray-600 rounded-lg px-2 py-1 bg-transparent"
      >
        <option :value="null" disabled>选择分类</option>
        <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
      </select>

      <button
        class="btn-ghost text-sm border border-gray-300 dark:border-gray-600"
        @click="save"
        :disabled="saving"
      >
        {{ saving ? '保存中...' : '保存草稿' }}
      </button>
      <button
        class="btn-primary text-sm"
        @click="publish"
        :disabled="saving"
      >
        发布
      </button>
      <span v-if="saved" class="text-green-500 text-sm">已保存 ✓</span>
      <span v-if="errorMsg" class="text-red-500 text-sm">{{ errorMsg }}</span>
    </div>

    <!-- 标签选择 -->
    <div class="flex items-center gap-2 px-4 py-1.5 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800/50">
      <span class="text-xs text-gray-500">标签：</span>
      <button
        v-for="tag in tags"
        :key="tag.id"
        class="px-2 py-0.5 rounded-full text-xs font-medium transition-all"
        :style="{
          backgroundColor: form.tagIds.includes(tag.id) ? tag.color + '30' : 'transparent',
          color: tag.color,
          border: '1px solid ' + (form.tagIds.includes(tag.id) ? tag.color : 'transparent'),
        }"
        @click="toggleTag(tag.id)"
      >{{ tag.name }}</button>
    </div>

    <!-- 编辑区：左右分栏 -->
    <div class="flex flex-1 overflow-hidden">
      <!-- 左侧：编辑器 -->
      <div class="flex-1 flex flex-col border-r border-gray-200 dark:border-gray-700">
        <div class="px-4 py-1.5 text-xs text-gray-500 bg-gray-50 dark:bg-gray-800/50 border-b border-gray-200 dark:border-gray-700">
          Markdown 编辑器
        </div>
        <textarea
          v-model="form.content"
          class="flex-1 p-4 font-mono text-sm bg-white dark:bg-gray-800 outline-none resize-none leading-relaxed"
          placeholder="开始编写 Markdown 内容..."
        ></textarea>
      </div>

      <!-- 右侧：预览 -->
      <div class="flex-1 flex flex-col overflow-hidden">
        <div class="px-4 py-1.5 text-xs text-gray-500 bg-gray-50 dark:bg-gray-800/50 border-b border-gray-200 dark:border-gray-700">
          预览
        </div>
        <div
          class="flex-1 p-4 overflow-y-auto prose dark:prose-invert max-w-none text-sm"
          v-html="previewHtml"
        ></div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.prose pre {
  @apply bg-gray-900 text-gray-100 rounded-lg p-4 overflow-x-auto;
}
</style>
