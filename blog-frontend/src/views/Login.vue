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

const mouse = reactive({ x: 0.5, y: 0.5 })

function onMouseMove(e: MouseEvent) {
  const panel = (e.currentTarget as HTMLElement)
  if (!panel) return
  const rect = panel.getBoundingClientRect()
  mouse.x = (e.clientX - rect.left) / rect.width
  mouse.y = (e.clientY - rect.top) / rect.height
}

const pupilOffset = computed(() => ({
  x: (mouse.x - 0.5) * 10,
  y: (mouse.y - 0.5) * 10,
}))

const hideEyes = computed(() => focusedField.value === 'password')

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
      class="hidden lg:flex flex-1 relative bg-gradient-to-br from-amber-50 via-orange-50/40 to-rose-50 overflow-hidden select-none flex-col items-center justify-center"
      @mousemove="onMouseMove"
    >
      <!-- 装饰背景 -->
      <div class="absolute top-1/3 -left-16 w-64 h-64 bg-pink-200/30 rounded-full blur-3xl"></div>
      <div class="absolute bottom-1/3 -right-16 w-56 h-56 bg-amber-200/30 rounded-full blur-3xl"></div>

      <!-- 可爱角色 -->
      <div class="relative flex flex-col items-center">
        <!-- ===== 头部 ===== -->
        <div class="relative z-10">
          <!-- 后发 -->
          <div class="absolute -top-6 left-1/2 -translate-x-1/2 w-56 h-20 bg-gradient-to-b from-amber-700 to-amber-600 rounded-t-full"></div>

          <!-- 双马尾 (左) -->
          <div class="absolute -left-10 top-0 w-10 h-28 bg-gradient-to-b from-amber-600 to-amber-700 rounded-r-full rounded-b-full origin-top -rotate-12"></div>
          <!-- 双马尾 (右) -->
          <div class="absolute -right-10 top-0 w-10 h-28 bg-gradient-to-b from-amber-600 to-amber-700 rounded-l-full rounded-b-full origin-top rotate-12"></div>

          <!-- 脸 -->
          <div class="w-52 h-48 bg-gradient-to-b from-[#ffe8e0] to-[#ffdbd0] rounded-[45%] relative shadow-lg">
            <!-- 刘海 -->
            <div class="absolute -top-1 left-1/2 -translate-x-1/2 w-56 h-16 overflow-hidden">
              <div class="w-full h-full bg-gradient-to-b from-amber-600 to-amber-500 rounded-t-full" style="clip-path: polygon(-10% 0, 110% 0, 80% 100%, 50% 85%, 20% 100%)"></div>
              <!-- 刘海碎发 -->
              <div class="absolute top-5 left-[22%] w-3 h-4 bg-amber-600 rounded-b-full"></div>
              <div class="absolute top-4 right-[25%] w-4 h-5 bg-amber-600 rounded-b-full"></div>
            </div>

            <!-- 蝴蝶结 (发饰) -->
            <div class="absolute -top-2 left-1/2 -translate-x-1/2 z-20">
              <div class="w-6 h-4 bg-pink-300 rounded-t-full rounded-b-sm rotate-[-15deg] -ml-1 inline-block"></div>
              <div class="w-6 h-4 bg-pink-300 rounded-t-full rounded-b-sm rotate-[15deg] -mr-1 inline-block"></div>
              <div class="w-2 h-2 bg-pink-400 rounded-full -mt-2 mx-auto"></div>
            </div>

            <!-- ===== 眼睛 ===== -->
            <div class="flex justify-center gap-8 pt-16">
              <!-- 左眼 -->
              <div class="relative w-16 h-16 bg-white rounded-full shadow-inner overflow-hidden border-[2.5px] border-[#5c4033]">
                <div
                  v-if="!hideEyes"
                  class="absolute w-11 h-11 bg-gradient-to-br from-[#5c4033] to-[#3d2b22] rounded-full transition-all duration-100"
                  :style="{
                    left: `calc(50% - 22px + ${pupilOffset.x}px)`,
                    top: `calc(50% - 22px + ${pupilOffset.y}px)`,
                  }"
                >
                  <!-- 大星光高光 -->
                  <div class="absolute top-1.5 left-2 w-3.5 h-3.5 bg-white rounded-full opacity-90"></div>
                  <!-- 四角星高光 -->
                  <div class="absolute top-0.5 right-3 w-2 h-2 bg-white/70" style="clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%)"></div>
                  <!-- 小高光 -->
                  <div class="absolute bottom-2 right-1.5 w-1.5 h-1.5 bg-white/40 rounded-full"></div>
                </div>
                <!-- 遮眼表情 -->
                <div v-else class="absolute inset-0 flex items-center justify-center">
                  <span class="text-[#5c4033] text-2xl font-bold leading-none">><</span>
                </div>
              </div>

              <!-- 右眼 -->
              <div class="relative w-16 h-16 bg-white rounded-full shadow-inner overflow-hidden border-[2.5px] border-[#5c4033]">
                <div
                  v-if="!hideEyes"
                  class="absolute w-11 h-11 bg-gradient-to-br from-[#5c4033] to-[#3d2b22] rounded-full transition-all duration-100"
                  :style="{
                    left: `calc(50% - 22px + ${pupilOffset.x}px)`,
                    top: `calc(50% - 22px + ${pupilOffset.y}px)`,
                  }"
                >
                  <div class="absolute top-1.5 left-2 w-3.5 h-3.5 bg-white rounded-full opacity-90"></div>
                  <div class="absolute top-0.5 right-3 w-2 h-2 bg-white/70" style="clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%)"></div>
                  <div class="absolute bottom-2 right-1.5 w-1.5 h-1.5 bg-white/40 rounded-full"></div>
                </div>
                <div v-else class="absolute inset-0 flex items-center justify-center">
                  <span class="text-[#5c4033] text-2xl font-bold leading-none">><</span>
                </div>
              </div>
            </div>

            <!-- 腮红 -->
            <div class="absolute left-5 top-[68%] w-6 h-3.5 bg-pink-300/45 rounded-full"></div>
            <div class="absolute right-5 top-[68%] w-6 h-3.5 bg-pink-300/45 rounded-full"></div>

            <!-- 嘴巴 (动态) -->
            <div class="flex justify-center mt-2">
              <div v-if="mouthClass === 'smile'" class="w-5 h-2.5 border-b-[2.5px] border-[#b8836e] rounded-full"></div>
              <div v-else-if="mouthClass === 'smirk'" class="w-5 h-2.5 border-b-[2.5px] border-[#b8836e] rounded-full translate-x-[2px]"></div>
              <div v-else-if="mouthClass === 'worried'" class="w-4 h-4 border-[2px] border-[#b8836e] rounded-full bg-pink-200/60"></div>
            </div>
          </div>
        </div>

        <!-- ===== 手臂 ===== -->
        <!-- 左臂 -->
        <div
          class="absolute bottom-[38px] left-[calc(50%-88px)] w-6 h-[60px] bg-gradient-to-b from-[#ffe8e0] to-[#ffdbd0] rounded-full origin-top transition-transform duration-500 ease-in-out z-20"
          :style="{
            transform: hideEyes
              ? 'rotate(-140deg) translateY(-8px)'
              : 'rotate(12deg)',
          }"
        >
          <div class="absolute -bottom-2 -left-1 w-8 h-[18px] bg-gradient-to-b from-[#ffdbd0] to-[#ffcec0] rounded-full"></div>
        </div>

        <!-- 右臂 -->
        <div
          class="absolute bottom-[38px] right-[calc(50%-88px)] w-6 h-[60px] bg-gradient-to-b from-[#ffe8e0] to-[#ffdbd0] rounded-full origin-top transition-transform duration-500 ease-in-out z-20"
          :style="{
            transform: hideEyes
              ? 'rotate(140deg) translateY(-8px)'
              : 'rotate(-12deg)',
          }"
        >
          <div class="absolute -bottom-2 -right-1 w-8 h-[18px] bg-gradient-to-b from-[#ffdbd0] to-[#ffcec0] rounded-full"></div>
        </div>

        <!-- ===== 身体 ===== -->
        <div class="-mt-3 w-36 h-28 bg-gradient-to-b from-[#b8d8f0] to-[#a0c8e8] rounded-t-[40%] rounded-b-2xl relative shadow-md z-0">
          <!-- 衣领装饰 -->
          <div class="absolute top-2 left-1/2 -translate-x-1/2 w-10 h-3 bg-white/60 rounded-full"></div>
          <!-- 领口花边 -->
          <div class="absolute top-4 left-1/2 -translate-x-1/2 w-0 h-0 border-l-[10px] border-r-[10px] border-t-[8px] border-l-transparent border-r-transparent border-t-white/40"></div>
          <!-- 纽扣 -->
          <div class="absolute top-10 left-1/2 -translate-x-1/2 w-2 h-2 bg-white/60 rounded-full"></div>
          <div class="absolute top-14 left-1/2 -translate-x-1/2 w-2 h-2 bg-white/60 rounded-full"></div>
        </div>

        <!-- ===== 腿 ===== -->
        <div class="flex gap-5 -mt-0.5">
          <div class="w-6 h-7 bg-gradient-to-b from-[#ffdbd0] to-[#ffcec0] rounded-b-full"></div>
          <div class="w-6 h-7 bg-gradient-to-b from-[#ffdbd0] to-[#ffcec0] rounded-b-full"></div>
        </div>
      </div>

      <!-- 底部状态文字 -->
      <p class="mt-6 text-gray-400 text-sm tracking-wider transition-all duration-300">
        <span v-if="focusedField === 'password'">🙈 人家什么也没看到~</span>
        <span v-else-if="focusedField === 'username'">🌸 慢慢填，不着急</span>
        <span v-else>✨ 欢迎来到 MyBlog</span>
      </p>
    </div>

    <!-- 右侧：登录表单 -->
    <div class="flex-1 flex items-center justify-center p-8 bg-white">
      <div class="w-full max-w-sm">
        <div class="flex items-center gap-2 mb-10">
          <div class="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center text-white text-sm font-bold tracking-wide">
            M
          </div>
          <span class="text-lg font-bold text-gray-900">MyBlog</span>
        </div>

        <h1 class="text-3xl font-bold text-gray-900 mb-2">欢迎回来</h1>
        <p class="text-gray-400 text-sm mb-8">登录以继续访问你的内容</p>

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
