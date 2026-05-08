import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { User } from '@/types'
import { authApi } from '@/api/auth'
import request from '@/api/request'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const token = ref<string | null>(localStorage.getItem('token'))

  async function fetchCurrentUser() {
    if (!token.value) return
    try {
      const res = await request.get<{ data: User }>('/users/me')
      user.value = res.data.data
    } catch {
      logout()
    }
  }

  async function login(username: string, password: string) {
    const res = await authApi.login({ username, password })
    token.value = res.data.data.token
    user.value = res.data.data.user
    localStorage.setItem('token', token.value!)
  }

  async function register(data: { username: string; password: string; nickname?: string; email?: string }) {
    const res = await authApi.register(data)
    return res.data.data
  }

  function logout() {
    user.value = null
    token.value = null
    localStorage.removeItem('token')
  }

  function isLoggedIn() {
    return !!token.value
  }

  return { user, token, login, register, logout, isLoggedIn, fetchCurrentUser }
})
