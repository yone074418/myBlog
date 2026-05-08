<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const auth = useAuthStore()
const form = reactive({ username: '', password: '', confirmPassword: '', nickname: '', email: '' })
const loading = ref(false)
const error = ref('')

async function handleRegister() {
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
    // Auto login after register
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
    <div class="hidden lg:flex flex-1 relative overflow-hidden bg-gradient-to-br from-primary-900 via-primary-700 to-orange-500 items-center justify-center">
      <div class="absolute inset-0 opacity-20">
        <div class="absolute top-1/3 right-1/3 w-80 h-80 bg-white rounded-full blur-3xl animate-pulse"></div>
      </div>
      <div class="relative text-white text-center">
        <h1 class="text-4xl font-bold mb-4">加入 MyBlog</h1>
        <p class="text-white/70 text-lg">开始记录你的技术之旅</p>
      </div>
    </div>

    <div class="flex-1 flex items-center justify-center p-8 bg-gray-50 dark:bg-gray-900">
      <div class="w-full max-w-md">
        <div class="card p-8 backdrop-blur-lg bg-white/90 dark:bg-gray-800/90">
          <h2 class="text-2xl font-bold mb-6 text-center">创建账号</h2>

          <form @submit.prevent="handleRegister" class="space-y-4">
            <div>
              <label class="block text-sm font-medium mb-1.5">用户名 *</label>
              <input v-model="form.username" type="text" class="input-field" placeholder="3-50个字符" required />
            </div>
            <div>
              <label class="block text-sm font-medium mb-1.5">昵称</label>
              <input v-model="form.nickname" type="text" class="input-field" placeholder="选填" />
            </div>
            <div>
              <label class="block text-sm font-medium mb-1.5">邮箱</label>
              <input v-model="form.email" type="email" class="input-field" placeholder="选填" />
            </div>
            <div>
              <label class="block text-sm font-medium mb-1.5">密码 *</label>
              <input v-model="form.password" type="password" class="input-field" placeholder="至少6个字符" required />
            </div>
            <div>
              <label class="block text-sm font-medium mb-1.5">确认密码 *</label>
              <input v-model="form.confirmPassword" type="password" class="input-field" placeholder="再次输入密码" required />
            </div>

            <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>

            <button type="submit" class="btn-primary w-full !py-2.5" :disabled="loading">
              {{ loading ? '注册中...' : '注册' }}
            </button>
          </form>

          <div class="mt-6 text-center text-sm text-gray-500">
            已有账号？
            <router-link to="/login" class="text-primary-500 hover:text-primary-600">立即登录</router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
