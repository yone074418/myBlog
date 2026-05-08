<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const auth = useAuthStore()
const form = reactive({ username: '', password: '', confirmPassword: '', nickname: '', email: '' })
const loading = ref(false)
const error = ref('')
const agreed = ref(false)

async function handleRegister() {
  if (!agreed.value) {
    error.value = '请先阅读并同意用户服务协议和隐私政策'
    return
  }
  if (form.password !== form.confirmPassword) {
    error.value = '两次密码输入不一致'
    return
  }
  loading.value = true
  error.value = ''
  try {
    await auth.register({
      username: form.username,
      password: form.password,
      nickname: form.nickname || undefined,
      email: form.email || undefined,
    })
    await auth.login(form.username, form.password)
    router.push('/')
  } catch (e: any) {
    error.value = e.response?.data?.message || '注册失败，请重试'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="min-h-screen flex">
    <!-- 左侧装饰区 -->
    <div class="hidden lg:flex flex-1 relative bg-slate-50 items-center justify-center overflow-hidden">
      <div class="relative w-80 h-80">
        <div class="absolute inset-0 bg-gradient-to-br from-blue-100 to-violet-100 rounded-full blur-3xl opacity-60"></div>
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-center">
          <div class="w-24 h-24 rounded-2xl bg-blue-600 flex items-center justify-center text-4xl mx-auto mb-4 shadow-lg">
            🌵
          </div>
          <h2 class="text-2xl font-bold text-gray-800">加入仙人掌</h2>
          <p class="text-gray-400 mt-2">开始你的技术之旅</p>
        </div>
      </div>
    </div>

    <!-- 右侧注册表单 -->
    <div class="flex-1 flex items-center justify-center p-8 bg-white">
      <div class="w-full max-w-md">
        <div class="flex items-center gap-2 mb-10">
          <div class="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center text-white text-sm font-bold">
            🌵
          </div>
          <span class="text-lg font-bold text-gray-900">仙人掌</span>
        </div>

        <h1 class="text-3xl font-bold text-gray-900 mb-2">创建账号</h1>
        <p class="text-gray-400 text-sm mb-8">注册后即可享受完整的社区服务</p>

        <form @submit.prevent="handleRegister" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1.5">用户名 *</label>
            <input v-model="form.username" type="text"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all duration-200"
              placeholder="3-50个字符" required />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1.5">昵称</label>
            <input v-model="form.nickname" type="text"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all duration-200"
              placeholder="选填" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1.5">邮箱</label>
            <input v-model="form.email" type="email"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all duration-200"
              placeholder="选填" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1.5">密码 *</label>
            <input v-model="form.password" type="password"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all duration-200"
              placeholder="至少6个字符" required />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1.5">确认密码 *</label>
            <input v-model="form.confirmPassword" type="password"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all duration-200"
              placeholder="再次输入密码" required />
          </div>

          <label class="flex items-start gap-2 cursor-pointer">
            <input v-model="agreed" type="checkbox"
              class="mt-0.5 w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
            <span class="text-xs text-gray-500 leading-relaxed">
              我已阅读并同意
              <a href="#" class="text-blue-600 hover:text-blue-700">《用户服务协议》</a>
              和
              <a href="#" class="text-blue-600 hover:text-blue-700">《隐私政策》</a>
            </span>
          </label>

          <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>

          <button type="submit"
            class="w-full py-2.5 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-medium transition-colors disabled:opacity-50"
            :disabled="loading">
            {{ loading ? '注册中...' : '注册' }}
          </button>
        </form>

        <div class="mt-6 text-center text-sm text-gray-400">
          已有账号？
          <router-link to="/login" class="text-blue-600 hover:text-blue-700 font-medium">立即登录</router-link>
        </div>
      </div>
    </div>
  </div>
</template>
