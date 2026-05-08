export interface User {
  id: number
  username: string
  nickname: string
  email: string
  avatar: string
  bio: string
  role: number
  level: number
}

export interface Article {
  id: number
  userId: number
  authorName: string
  authorAvatar: string
  categoryId: number
  categoryName: string
  title: string
  summary: string
  content: string
  coverImage: string
  seoKeywords: string
  status: number
  publishTime: string
  score: number
  viewCount: number
  likeCount: number
  commentCount: number
  collectCount: number
  isTop: number
  isRecommend: number
  tags: Tag[]
  createTime: string
  updateTime: string
}

export interface Tag {
  id: number
  name: string
  color: string
}

export interface Category {
  id: number
  name: string
  description: string
  sortOrder: number
}

export interface Comment {
  id: number
  articleId: number
  userId: number
  authorName: string
  authorAvatar: string
  parentId: number | null
  replyToId: number | null
  replyToName: string
  content: string
  likeCount: number
  createTime: string
  replies: Comment[]
}

export interface PageResult<T> {
  records: T[]
  total: number
  page: number
  pageSize: number
  pages: number
}

export interface ApiResult<T> {
  code: number
  message: string
  data: T
}
