import request from './request'
import type { Tag } from '@/types'

export const tagApi = {
  list() {
    return request.get<{ data: Tag[] }>('/tags')
  },
}
