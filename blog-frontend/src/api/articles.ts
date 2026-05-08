import request from './request'
import type { Article, PageResult } from '@/types'

export const articleApi = {
  list(params: {
    page?: number
    pageSize?: number
    sort?: string
    categoryId?: number
    tagId?: number
  }) {
    return request.get<{ data: PageResult<Article> }>('/articles', { params })
  },

  getById(id: number) {
    return request.get<{ data: Article }>(`/articles/${id}`)
  },

  create(data: {
    title: string
    content: string
    categoryId: number
    summary?: string
    coverImage?: string
    status?: number
    tagIds?: number[]
  }) {
    return request.post<{ data: Article }>('/articles', data)
  },

  update(id: number, data: Partial<Article>) {
    return request.put<{ data: Article }>(`/articles/${id}`, data)
  },

  delete(id: number) {
    return request.delete(`/articles/${id}`)
  },

  listByUser(userId: number, page = 1, pageSize = 10) {
    return request.get<{ data: PageResult<Article> }>(`/articles/user/${userId}`, {
      params: { page, pageSize },
    })
  },

  like(id: number) {
    return request.post<{ data: number }>(`/articles/${id}/like`)
  },
}
