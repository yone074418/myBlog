<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useThemeStore } from '@/stores/theme'

const router = useRouter()
const auth = useAuthStore()
const theme = useThemeStore()
const searchKeyword = ref('')
const showUserMenu = ref(false)

function handleSearch() {
  if (searchKeyword.value.trim()) {
    router.push({ path: '/', query: { search: searchKeyword.value } })
  }
}

function goHome() {
  router.push('/')
}

function goEditor() {
  if (auth.isLoggedIn()) {
    router.push('/editor')
  } else {
    router.push('/login')
  }
}
</script>

<template>
  <header class="fixed top-0 left-0 right-0 z-50">
    <!-- 主顶栏 -->
    <div class="bg-gray-900 text-white">
      <div class="max-w-7xl mx-auto px-4 h-12 flex items-center justify-between">
        <div class="flex items-center gap-6">
          <span class="text-xl font-bold text-primary-500 cursor-pointer" @click="goHome">
            MyBlog
          </span>
          <nav class="hidden md:flex items-center gap-4 text-sm">
            <router-link to="/" class="hover:text-primary-400 transition-colors">首页</router-link>
            <router-link to="/?sort=hot" class="hover:text-primary-400 transition-colors">热门</router-link>
            <router-link to="/?sort=latest" class="hover:text-primary-400 transition-colors">最新</router-link>
          </nav>
        </div>

        <div class="flex items-center gap-3">
          <!-- 搜索 -->
          <div class="hidden sm:flex items-center">
            <input
              v-model="searchKeyword"
              type="text"
              placeholder="搜索文章..."
              class="w-40 lg:w-56 px-3 py-1.5 rounded-lg bg-gray-800 text-white text-sm
                     border border-gray-700 focus:ring-2 focus:ring-primary-500 outline-none"
              @keyup.enter="handleSearch"
            />
          </div>

          <!-- 暗色模式 -->
          <button
            class="p-2 rounded-lg hover:bg-gray-800 transition-colors"
            @click="theme.toggle()"
          >
            <svg v-if="!theme.isDark" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
            </svg>
            <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
          </button>

          <!-- 写文章 -->
          <button
            v-if="auth.isLoggedIn()"
            class="btn-primary text-sm !px-3 !py-1.5"
            @click="goEditor"
          >
            写文章
          </button>

          <!-- 用户菜单 -->
          <div v-if="auth.isLoggedIn()" class="relative">
            <button
              class="flex items-center gap-2 p-1 rounded-lg hover:bg-gray-800 transition-colors"
              @click="showUserMenu = !showUserMenu"
            >
              <div class="w-7 h-7 rounded-full bg-primary-500 flex items-center justify-center text-xs font-bold">
                {{ auth.user?.nickname?.[0] || auth.user?.username[0] }}
              </div>
            </button>
            <div
              v-if="showUserMenu"
              class="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-xl shadow-lg
                     border border-gray-200 dark:border-gray-700 py-2"
              @click="showUserMenu = false"
            >
              <router-link
                :to="`/user/${auth.user?.id}`"
                class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700"
              >
                个人主页
              </router-link>
              <router-link
                to="/editor"
                class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700"
              >
                我的文章
              </router-link>
              <hr class="my-1 border-gray-200 dark:border-gray-700" />
              <button
                class="w-full text-left px-4 py-2 text-sm text-red-500 hover:bg-gray-100 dark:hover:bg-gray-700"
                @click="auth.logout(); router.push('/')"
              >
                退出登录
              </button>
            </div>
          </div>

          <!-- 登录按钮 -->
          <router-link
            v-else
            to="/login"
            class="text-sm text-primary-400 hover:text-primary-300 transition-colors"
          >
            登录
          </router-link>
        </div>
      </div>
    </div>
  </header>
</template>
