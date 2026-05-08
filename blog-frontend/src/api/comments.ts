import request from './request'
import type { Comment } from '@/types'

export const commentApi = {
  listByArticle(articleId: number) {
    return request.get<{ data: Comment[] }>(`/comments/article/${articleId}`)
  },

  create(articleId: number, content: string, parentId?: number, replyToId?: number) {
    return request.post<{ data: Comment }>(`/comments/article/${articleId}`, null, {
      params: { content, parentId, replyToId },
    })
  },

  delete(id: number) {
    return request.delete(`/comments/${id}`)
  },
}
