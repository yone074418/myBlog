<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const auth = useAuthStore()
const form = reactive({ username: '', password: '' })
const loading = ref(false)
const error = ref('')
const agreed = ref(false)

// Parallax effect for geometric characters
const mousePos = reactive({ x: 0, y: 0 })

function onMouseMove(e: MouseEvent) {
  const rect = (e.currentTarget as HTMLElement)?.getBoundingClientRect()
  if (!rect) return
  mousePos.x = ((e.clientX - rect.left) / rect.width - 0.5) * 2
  mousePos.y = ((e.clientY - rect.top) / rect.height - 0.5) * 2
}

async function handleLogin() {
  if (!agreed.value) {
    error.value = '请先阅读并同意用户服务协议和隐私政策'
    return
  }
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

onMounted(() => {
  if (auth.isLoggedIn()) {
    router.push('/')
  }
})
</script>

<template>
  <div class="min-h-screen flex">
    <!-- 左侧：几何插画区 -->
    <div
      class="hidden lg:flex flex-1 relative bg-slate-50 overflow-hidden select-none"
      @mousemove="onMouseMove"
    >
      <!-- 几何角色容器 - 沉底 -->
      <div class="absolute bottom-0 left-0 right-0 h-[70%]">
        <!-- 橙色半圆形 (最前方、最底部) -->
        <div
          class="absolute w-44 h-22 bg-orange-400 rounded-t-full"
          :style="{
            bottom: '-2px',
            left: '50%',
            marginLeft: '-88px',
            zIndex: 40,
            transform: `translate(${mousePos.x * -16}px, ${mousePos.y * -6}px)`,
          }"
        >
          <div class="flex gap-5 justify-center pt-6">
            <div class="w-3 h-3 rounded-full bg-white"></div>
            <div class="w-3 h-3 rounded-full bg-white"></div>
          </div>
          <div class="w-10 h-2 bg-white/50 rounded-full mx-auto mt-2"></div>
        </div>

        <!-- 黄色胶囊形 (右下角，橙色后方露出一半) -->
        <div
          class="absolute w-28 h-36 bg-amber-400 rounded-full"
          :style="{
            bottom: '25%',
            right: '8%',
            zIndex: 30,
            transform: `translate(${mousePos.x * -10}px, ${mousePos.y * -8}px)`,
          }"
        >
          <div class="flex gap-3 justify-center mt-10">
            <div class="w-3 h-3 rounded-full bg-white"></div>
            <div class="w-3 h-3 rounded-full bg-white"></div>
          </div>
          <div class="w-6 h-1 bg-white/50 rounded-full mx-auto mt-3"></div>
        </div>

        <!-- 紫色高矩形 (左侧，高高耸立) -->
        <div
          class="absolute w-36 h-56 bg-violet-500 rounded-2xl"
          :style="{
            bottom: '8%',
            left: '12%',
            zIndex: 20,
            transform: `translate(${mousePos.x * -12}px, ${mousePos.y * -10}px)`,
          }"
        >
          <div class="flex gap-4 justify-center mt-8">
            <div class="w-3 h-3 rounded-full bg-white/90"></div>
            <div class="w-3 h-3 rounded-full bg-white/90"></div>
          </div>
          <div class="w-10 h-2 bg-white/50 rounded-full mx-auto mt-5"></div>
        </div>

        <!-- 黑色中矩形 (夹在紫黄中间后方，只露上半部分) -->
        <div
          class="absolute w-32 h-28 bg-gray-900 rounded-xl"
          :style="{
            bottom: '38%',
            left: '38%',
            zIndex: 10,
            transform: `translate(${mousePos.x * -8}px, ${mousePos.y * -7}px)`,
          }"
        >
          <div class="flex gap-3 justify-center mt-4">
            <div class="w-3 h-3 rounded-full bg-white"></div>
            <div class="w-3 h-3 rounded-full bg-white/60"></div>
            <div class="w-3 h-3 rounded-full bg-white"></div>
          </div>
        </div>

        <!-- 装饰小圆点 -->
        <div
          v-for="i in 6"
          :key="i"
          class="absolute w-2 h-2 rounded-full"
          :class="i % 2 === 0 ? 'bg-blue-400/25' : 'bg-violet-400/25'"
          :style="{
            bottom: `${8 + Math.sin(i * 1.3) * 20 + 50}%`,
            left: `${15 + Math.cos(i * 0.8) * 30}%`,
            transform: `translate(${mousePos.x * (3 + i)}px, ${mousePos.y * (3 + i)}px)`,
          }"
        ></div>
      </div>
    </div>

    <!-- 右侧：登录表单 -->
    <div class="flex-1 flex items-center justify-center p-8 bg-white">
      <div class="w-full max-w-sm">
        <!-- Logo & 品牌名 -->
        <div class="flex items-center gap-2 mb-10">
          <div class="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center text-white text-sm font-bold tracking-wide">
            M
          </div>
          <span class="text-lg font-bold text-gray-900">MyBlog</span>
        </div>

        <!-- 标题 -->
        <h1 class="text-3xl font-bold text-gray-900 mb-2">欢迎回来</h1>
        <p class="text-gray-400 text-sm mb-8">登录以继续访问你的内容</p>

        <!-- 表单区域 -->
        <form @submit.prevent="handleLogin" class="space-y-5">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1.5">邮箱 / 用户名</label>
            <input
              v-model="form.username"
              type="text"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all duration-200 text-sm"
              placeholder="请输入邮箱或用户名"
              required
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1.5">密码</label>
            <input
              v-model="form.password"
              type="password"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all duration-200 text-sm"
              placeholder="请输入密码"
              required
            />
          </div>

          <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>

          <button
            type="submit"
            class="w-full py-3 rounded-xl bg-blue-600 hover:bg-blue-700 disabled:opacity-50 text-white font-medium transition-colors text-sm"
            :disabled="loading"
          >
            {{ loading ? '登录中...' : '登录' }}
          </button>
        </form>

        <!-- 协议复选框 -->
        <label class="flex items-start gap-2 mt-5 cursor-pointer">
          <input
            v-model="agreed"
            type="checkbox"
            class="mt-0.5 w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
          />
          <span class="text-xs text-gray-400 leading-relaxed">
            我已阅读并同意
            <a href="#" class="text-blue-600 hover:text-blue-700">《用户服务协议》</a>
            和
            <a href="#" class="text-blue-600 hover:text-blue-700">《隐私政策》</a>
          </span>
        </label>

        <!-- 注册入口 -->
        <div class="mt-8 text-center text-sm text-gray-400">
          还没有账号？
          <router-link to="/register" class="text-blue-600 hover:text-blue-700 font-medium">
            立即注册
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>
