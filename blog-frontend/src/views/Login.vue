<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const auth = useAuthStore()
const form = reactive({ username: '', password: '' })
const loading = ref(false)
const error = ref('')

async function handleLogin() {
  loading.value = true
  error.value = ''
  try {
    await auth.login(form.username, form.password)
    router.push('/')
  } catch (e: any) {
    error.value = e.response?.data?.message || '登录失败，请重试'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="min-h-screen flex">
    <!-- 左侧：几何插画视差效果 -->
    <div class="hidden lg:flex flex-1 relative overflow-hidden bg-gradient-to-br from-primary-900 via-primary-700 to-orange-500 items-center justify-center">
      <div class="absolute inset-0 opacity-20">
        <div class="absolute top-1/4 left-1/4 w-72 h-72 bg-white rounded-full blur-3xl animate-pulse"></div>
        <div class="absolute bottom-1/4 right-1/4 w-96 h-96 bg-orange-300 rounded-full blur-3xl animate-pulse" style="animation-delay: 1s"></div>
      </div>

      <!-- 几何图形 -->
      <div class="relative w-96 h-96">
        <!-- 旋转立方体 -->
        <div class="absolute inset-0 animate-spin-slow">
          <div class="absolute top-0 left-1/2 -translate-x-1/2 w-0 h-0
                      border-l-[60px] border-r-[60px] border-b-[104px]
                      border-l-transparent border-r-transparent border-b-white/30"></div>
          <div class="absolute bottom-0 left-1/2 -translate-x-1/2 w-0 h-0
                      border-l-[60px] border-r-[60px] border-t-[104px]
                      border-l-transparent border-r-transparent border-t-white/30"></div>
        </div>
        <!-- 浮动圆形 -->
        <div class="absolute top-8 right-8 w-20 h-20 border-2 border-white/40 rounded-full animate-float"></div>
        <div class="absolute bottom-8 left-8 w-16 h-16 border-2 border-white/30 rounded-lg rotate-45 animate-float" style="animation-delay: 2s"></div>
        <!-- 点阵 -->
        <div class="absolute inset-0">
          <div v-for="i in 6" :key="i"
               class="absolute w-2 h-2 bg-white/40 rounded-full"
               :style="{
                 top: `${20 + Math.sin(i) * 40}%`,
                 left: `${20 + Math.cos(i * 1.5) * 40}%`,
                 animationDelay: `${i * 0.5}s`
               }">
          </div>
        </div>
      </div>

      <div class="absolute bottom-12 left-12 text-white">
        <h1 class="text-4xl font-bold mb-2">MyBlog</h1>
        <p class="text-white/70 text-lg">记录技术，分享思考</p>
      </div>
    </div>

    <!-- 右侧：登录表单 -->
    <div class="flex-1 flex items-center justify-center p-8 bg-gray-50 dark:bg-gray-900">
      <div class="w-full max-w-md">
        <div class="card p-8 backdrop-blur-lg bg-white/90 dark:bg-gray-800/90">
          <h2 class="text-2xl font-bold mb-6 text-center">欢迎回来</h2>

          <form @submit.prevent="handleLogin" class="space-y-4">
            <div>
              <label class="block text-sm font-medium mb-1.5">用户名</label>
              <input
                v-model="form.username"
                type="text"
                class="input-field"
                placeholder="请输入用户名"
                required
              />
            </div>

            <div>
              <label class="block text-sm font-medium mb-1.5">密码</label>
              <input
                v-model="form.password"
                type="password"
                class="input-field"
                placeholder="请输入密码"
                required
              />
            </div>

            <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>

            <button
              type="submit"
              class="btn-primary w-full !py-2.5"
              :disabled="loading"
            >
              {{ loading ? '登录中...' : '登录' }}
            </button>
          </form>

          <div class="mt-6 text-center text-sm text-gray-500">
            还没有账号？
            <router-link to="/register" class="text-primary-500 hover:text-primary-600">
              立即注册
            </router-link>
          </div>

          <!-- 第三方登录 -->
          <div class="mt-6">
            <div class="relative mb-4">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-gray-300 dark:border-gray-600"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="px-2 bg-white dark:bg-gray-800 text-gray-500">第三方登录</span>
              </div>
            </div>
            <div class="flex justify-center gap-4">
              <button class="p-3 rounded-full border border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor"><path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/></svg>
              </button>
              <button class="p-3 rounded-full border border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor"><path d="M23.954 4.569c-.885.389-1.83.654-2.825.775 1.014-.611 1.794-1.574 2.163-2.723-.951.555-2.005.959-3.127 1.184-.896-.959-2.173-1.559-3.591-1.559-2.717 0-4.92 2.203-4.92 4.917 0 .39.045.765.127 1.124C7.691 8.094 4.066 6.13 1.64 3.161c-.427.722-.666 1.561-.666 2.475 0 1.71.87 3.213 2.188 4.096-.807-.026-1.566-.248-2.228-.616v.061c0 2.385 1.693 4.374 3.946 4.827-.413.111-.849.171-1.296.171-.314 0-.615-.03-.916-.086.631 1.953 2.445 3.377 4.604 3.417-1.68 1.319-3.809 2.105-6.102 2.105-.39 0-.779-.023-1.17-.067 2.189 1.394 4.768 2.209 7.557 2.209 9.054 0 14-7.496 14-13.986 0-.21 0-.42-.015-.63.961-.689 1.8-1.56 2.46-2.548l-.047-.02z"/></svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@keyframes spin-slow {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-20px); }
}
.animate-spin-slow { animation: spin-slow 20s linear infinite; }
.animate-float { animation: float 6s ease-in-out infinite; }
</style>
