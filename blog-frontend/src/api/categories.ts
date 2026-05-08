import request from './request'
import type { Category } from '@/types'

export const categoryApi = {
  list() {
    return request.get<{ data: Category[] }>('/categories')
  },
}
