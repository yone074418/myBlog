<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const auth = useAuthStore()
const form = reactive({ username: '', password: '' })
const loading = ref(false)
const error = ref('')
const agreed = ref(false)
const activeTab = ref<'email' | 'wechat'>('email')
const showOverlay = ref(true)

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

function handleWeChat() {
  activeTab.value = 'wechat'
  showOverlay.value = true
}

function handleEmail() {
  activeTab.value = 'email'
  showOverlay.value = false
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
      class="hidden lg:flex flex-1 relative bg-slate-50 items-center justify-center overflow-hidden select-none"
      @mousemove="onMouseMove"
    >
      <!-- 几何角色容器 -->
      <div class="relative w-80 h-96">
        <!-- 黑色中矩形 (居后) -->
        <div
          class="absolute w-28 h-36 bg-gray-900 rounded-xl"
          :style="{
            top: '10%',
            left: '25%',
            transform: `translate(${mousePos.x * -6}px, ${mousePos.y * -6}px)`,
            zIndex: 1,
          }"
        >
          <div class="flex gap-2 justify-center mt-4">
            <div class="w-3 h-3 rounded-full bg-white"></div>
            <div class="w-3 h-3 rounded-full bg-white"></div>
          </div>
        </div>

        <!-- 紫色高矩形 -->
        <div
          class="absolute w-32 h-48 bg-violet-500 rounded-2xl"
          :style="{
            top: '5%',
            left: '40%',
            transform: `translate(${mousePos.x * -10}px, ${mousePos.y * -10}px)`,
            zIndex: 2,
          }"
        >
          <div class="flex gap-3 justify-center mt-6">
            <div class="w-3 h-3 rounded-full bg-white"></div>
            <div class="w-3 h-3 rounded-full bg-white"></div>
          </div>
          <div class="w-8 h-1.5 bg-white/60 rounded-full mx-auto mt-4"></div>
        </div>

        <!-- 橙色半圆形 (居前) -->
        <div
          class="absolute w-36 h-[72px] bg-orange-400 rounded-t-full"
          :style="{
            bottom: '18%',
            left: '20%',
            transform: `translate(${mousePos.x * -14}px, ${mousePos.y * -14}px)`,
            zIndex: 4,
          }"
        >
          <div class="flex gap-4 justify-center pt-5">
            <div class="w-3 h-3 rounded-full bg-white"></div>
            <div class="w-3 h-3 rounded-full bg-white"></div>
          </div>
          <div class="w-10 h-2 bg-white/50 rounded-full mx-auto mt-2"></div>
        </div>

        <!-- 黄色胶囊形 -->
        <div
          class="absolute w-24 h-32 bg-amber-400 rounded-full"
          :style="{
            top: '30%',
            left: '55%',
            transform: `translate(${mousePos.x * -8}px, ${mousePos.y * -8}px)`,
            zIndex: 3,
          }"
        >
          <div class="flex gap-2 justify-center mt-8">
            <div class="w-3 h-3 rounded-full bg-white"></div>
            <div class="w-3 h-3 rounded-full bg-white"></div>
          </div>
          <div class="w-6 h-0.5 bg-white/50 rounded-full mx-auto mt-3"></div>
        </div>

        <!-- 装饰小圆点 -->
        <div
          v-for="i in 8"
          :key="i"
          class="absolute w-2 h-2 rounded-full"
          :class="i % 2 === 0 ? 'bg-blue-400/30' : 'bg-violet-400/30'"
          :style="{
            top: `${10 + Math.sin(i * 1.2) * 38 + 50}%`,
            left: `${10 + Math.cos(i * 0.9) * 35 + 50}%`,
            transform: `translate(${mousePos.x * (4 + i)}px, ${mousePos.y * (4 + i)}px)`,
          }"
        ></div>
      </div>
    </div>

    <!-- 右侧：登录表单 -->
    <div class="flex-1 flex items-center justify-center p-8 bg-white">
      <div class="w-full max-w-md">
        <!-- Logo & 品牌名 -->
        <div class="flex items-center gap-2 mb-10">
          <div class="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center text-white text-sm font-bold">
            🌵
          </div>
          <span class="text-lg font-bold text-gray-900">仙人掌</span>
        </div>

        <!-- 标题 -->
        <h1 class="text-3xl font-bold text-gray-900 mb-2">微信登录</h1>
        <p class="text-gray-400 text-sm mb-8">未注册的手机号验证后将自动创建账号</p>

        <!-- Tab 切换栏 -->
        <div class="bg-gray-100 rounded-xl p-1 flex mb-6">
          <button
            class="flex-1 py-2 text-sm font-medium rounded-lg transition-all duration-200"
            :class="activeTab === 'email'
              ? 'bg-white text-gray-900 shadow-sm'
              : 'text-gray-500 hover:text-gray-700'"
            @click="handleEmail"
          >邮箱登录</button>
          <button
            class="flex-1 py-2 text-sm font-medium rounded-lg transition-all duration-200"
            :class="activeTab === 'wechat'
              ? 'bg-white text-gray-900 shadow-sm'
              : 'text-gray-500 hover:text-gray-700'"
            @click="handleWeChat"
          >微信</button>
        </div>

        <!-- 微信登录 - 二维码区域 -->
        <div v-if="activeTab === 'wechat'" class="relative border-2 border-dashed border-gray-200 rounded-xl h-64 flex items-center justify-center overflow-hidden">
          <div class="text-center text-gray-300">
            <svg class="w-16 h-16 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                    d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
            </svg>
            <p class="text-sm">微信扫码登录</p>
          </div>

          <!-- 毛玻璃遮罩 -->
          <div
            class="absolute inset-0 backdrop-blur-md bg-white/60 flex items-center justify-center"
          >
            <p class="text-gray-400 text-sm font-medium">请先勾选下方协议后刷新二维码</p>
          </div>
        </div>

        <!-- 邮箱登录 - 表单区域 -->
        <div v-if="activeTab === 'email'" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1.5">邮箱 / 用户名</label>
            <input
              v-model="form.username"
              type="text"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all duration-200"
              placeholder="请输入邮箱或用户名"
              required
            />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1.5">密码</label>
            <input
              v-model="form.password"
              type="password"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 bg-white focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all duration-200"
              placeholder="请输入密码"
              required
            />
          </div>

          <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>

          <button
            type="submit"
            class="btn-primary w-full !py-2.5 !rounded-lg !bg-blue-600 hover:!bg-blue-700"
            :disabled="loading"
            @click="handleLogin"
          >
            {{ loading ? '登录中...' : '登录' }}
          </button>
        </div>

        <!-- 底部操作区 -->
        <div class="mt-6 space-y-4">
          <!-- 主按钮 (微信模式下显示) -->
          <button
            v-if="activeTab === 'wechat'"
            class="w-full py-2.5 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-medium transition-colors"
          >
            刷新二维码
          </button>

          <!-- 协议复选框 -->
          <label class="flex items-start gap-2 cursor-pointer">
            <input
              v-model="agreed"
              type="checkbox"
              class="mt-0.5 w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
            />
            <span class="text-xs text-gray-500 leading-relaxed">
              我已阅读并同意
              <a href="#" class="text-blue-600 hover:text-blue-700">《用户服务协议》</a>
              和
              <a href="#" class="text-blue-600 hover:text-blue-700">《隐私政策》</a>
            </span>
          </label>

          <!-- 注册入口 -->
          <div class="text-center text-sm text-gray-400">
            还没有账号？
            <router-link to="/register" class="text-blue-600 hover:text-blue-700 font-medium">
              立即注册
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
