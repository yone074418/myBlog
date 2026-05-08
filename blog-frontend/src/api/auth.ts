import request from './request'
import type { User } from '@/types'

export const authApi = {
  login(data: { username: string; password: string }) {
    return request.post<{ data: { token: string; user: User } }>('/auth/login', data)
  },

  register(data: { username: string; password: string; nickname?: string; email?: string }) {
    return request.post<{ data: User }>('/auth/register', data)
  },
}
