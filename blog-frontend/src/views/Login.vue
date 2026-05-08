<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const auth = useAuthStore()
const form = reactive({ username: '', password: '' })
const loading = ref(false)
const error = ref('')
const agreed = ref(false)
const focusedField = ref<'username' | 'password' | null>(null)

// Mouse tracking for eye movement
const mouse = reactive({ x: 0.5, y: 0.5 })

function onMouseMove(e: MouseEvent) {
  const panel = (e.currentTarget as HTMLElement)
  if (!panel) return
  const rect = panel.getBoundingClientRect()
  mouse.x = (e.clientX - rect.left) / rect.width
  mouse.y = (e.clientY - rect.top) / rect.height
}

// Pupil offset: map mouse [0,1] to pupil offset [-6, 6]px
const pupilOffset = computed(() => {
  const px = (mouse.x - 0.5) * 14
  const py = (mouse.y - 0.5) * 14
  return { x: px, y: py }
})

// When password is focused, arms cover eyes → hide pupils
const hideEyes = computed(() => focusedField.value === 'password')


// Mouth expression based on state
const mouthClass = computed(() => {
  if (focusedField.value === 'password') return 'worried'
  if (focusedField.value === 'username') return 'smirk'
  return 'smile'
})

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
    <!-- 左侧：插画区 -->
    <div
      class="hidden lg:flex flex-1 relative bg-gradient-to-br from-sky-50 via-white to-indigo-50 overflow-hidden select-none flex-col items-center justify-center"
      @mousemove="onMouseMove"
    >
      <!-- 装饰背景圆 -->
      <div class="absolute top-1/4 -left-20 w-72 h-72 bg-blue-100/40 rounded-full blur-3xl"></div>
      <div class="absolute bottom-1/4 -right-20 w-64 h-64 bg-indigo-100/30 rounded-full blur-3xl"></div>

      <!-- 动漫角色 -->
      <div class="relative">
        <!-- 身体 -->
        <div class="w-40 h-44 bg-gradient-to-b from-indigo-400 to-indigo-500 rounded-t-full rounded-b-2xl mx-auto relative shadow-lg">
          <!-- 衣领 -->
          <div class="absolute bottom-2 left-1/2 -translate-x-1/2 w-12 h-3 bg-indigo-600 rounded-full"></div>
        </div>

        <!-- 头部 -->
        <div class="w-52 h-56 bg-gradient-to-b from-amber-50 to-amber-100 rounded-full mx-auto -mt-8 relative shadow-xl z-10">
          <!-- 手臂 (从肩膀位置伸出) -->
          <!-- 左臂 -->
          <div
            class="absolute w-5 h-[72px] bg-gradient-to-b from-amber-100 to-amber-200 rounded-full -left-8 top-[88px] origin-top transition-transform duration-500 ease-in-out"
            :style="{
              transform: hideEyes ? 'rotate(-130deg)' : 'rotate(10deg)',
            }"
          >
            <div class="absolute -bottom-2 -left-1.5 w-8 h-8 bg-gradient-to-b from-amber-100 to-amber-200 rounded-full"></div>
          </div>

          <!-- 右臂 -->
          <div
            class="absolute w-5 h-[72px] bg-gradient-to-b from-amber-100 to-amber-200 rounded-full -right-8 top-[88px] origin-top transition-transform duration-500 ease-in-out"
            :style="{
              transform: hideEyes ? 'rotate(130deg)' : 'rotate(-10deg)',
            }"
          >
            <div class="absolute -bottom-2 -right-1.5 w-8 h-8 bg-gradient-to-b from-amber-100 to-amber-200 rounded-full"></div>
          </div>

          <!-- 头发 - 刘海 -->
          <div class="absolute -top-1 left-1/2 -translate-x-1/2 w-56 h-28">
            <div class="w-full h-full bg-gradient-to-b from-gray-800 to-gray-700 rounded-t-full" style="clip-path: polygon(0 0, 100% 0, 85% 100%, 50% 85%, 15% 100%)">
            </div>
            <!-- 刘海分叉 -->
            <div class="absolute top-4 left-1/2 -translate-x-1/2 w-32 h-16 bg-gray-800 rounded-b-full"></div>
            <div class="absolute top-6 left-[30%] w-4 h-6 bg-gray-800 rounded-b-full"></div>
            <div class="absolute top-6 right-[30%] w-4 h-6 bg-gray-800 rounded-b-full"></div>
          </div>

          <!-- 侧发 -->
          <div class="absolute -left-3 top-8 w-3 h-24 bg-gray-800 rounded-full"></div>
          <div class="absolute -right-3 top-8 w-3 h-24 bg-gray-800 rounded-full"></div>

          <!-- 眼睛区域 -->
          <div class="flex justify-center gap-10 pt-20 relative" style="z-index: 5">
            <!-- 左眼 -->
            <div class="relative w-14 h-14 bg-white rounded-full shadow-inner overflow-hidden border-2 border-gray-700">
              <!-- 眼珠 (密码输入时隐藏) -->
              <div
                v-if="!hideEyes"
                class="absolute w-8 h-8 bg-gradient-to-br from-gray-800 to-gray-900 rounded-full transition-opacity duration-300"
                :style="{
                  left: `calc(50% - 16px + ${pupilOffset.x}px)`,
                  top: `calc(50% - 16px + ${pupilOffset.y}px)`,
                }"
              >
                <div class="absolute top-1.5 left-2 w-2.5 h-2.5 bg-white/80 rounded-full"></div>
                <div class="absolute bottom-2 right-1.5 w-1.5 h-1.5 bg-white/40 rounded-full"></div>
              </div>
              <!-- 密码输入时显示 > < 眼 -->
              <div v-else class="absolute inset-0 flex items-center justify-center text-gray-600 text-lg font-bold">
                &gt; &lt;
              </div>
            </div>
            <!-- 右眼 -->
            <div class="relative w-14 h-14 bg-white rounded-full shadow-inner overflow-hidden border-2 border-gray-700">
              <div
                v-if="!hideEyes"
                class="absolute w-8 h-8 bg-gradient-to-br from-gray-800 to-gray-900 rounded-full transition-opacity duration-300"
                :style="{
                  left: `calc(50% - 16px + ${pupilOffset.x}px)`,
                  top: `calc(50% - 16px + ${pupilOffset.y}px)`,
                }"
              >
                <div class="absolute top-1.5 left-2 w-2.5 h-2.5 bg-white/80 rounded-full"></div>
                <div class="absolute bottom-2 right-1.5 w-1.5 h-1.5 bg-white/40 rounded-full"></div>
              </div>
              <div v-else class="absolute inset-0 flex items-center justify-center text-gray-600 text-lg font-bold">
                &gt; &lt;
              </div>
            </div>
          </div>

          <!-- 腮红 -->
          <div class="absolute left-5 top-[68%] w-4 h-2.5 bg-pink-300/50 rounded-full" style="z-index: 5"></div>
          <div class="absolute right-5 top-[68%] w-4 h-2.5 bg-pink-300/50 rounded-full" style="z-index: 5"></div>

          <!-- 嘴巴 (动态表情) -->
          <div class="flex justify-center mt-2 relative" style="z-index: 5">
            <!-- 微笑 (默认) -->
            <div v-if="mouthClass === 'smile'" class="w-6 h-3 border-b-2 border-gray-500 rounded-full"></div>
            <!-- 抿嘴笑 (输用户名时) -->
            <div v-else-if="mouthClass === 'smirk'" class="w-6 h-3 border-b-2 border-gray-500 rounded-full" style="transform: skewX(-8deg)"></div>
            <!-- O形嘴 (输密码时 - 表示"我不该看") -->
            <div v-else-if="mouthClass === 'worried'" class="w-3 h-3.5 border-2 border-gray-500 rounded-full bg-pink-100"></div>
          </div>
        </div>
      </div>

      <!-- 底部状态文字 -->
      <p class="mt-6 text-gray-400 text-sm tracking-wider transition-all duration-300">
        <span v-if="focusedField === 'password'">🙈 放心，我看不见</span>
        <span v-else-if="focusedField === 'username'">✍️ 继续填写吧</span>
        <span v-else>👋 欢迎来到 MyBlog</span>
      </p>
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
              @focus="focusedField = 'username'"
              @blur="focusedField = null"
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
              @focus="focusedField = 'password'"
              @blur="focusedField = null"
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
