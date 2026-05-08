# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A personal blog / tech community system built with a front-end/back-end separation architecture. Phase 1 (MVP) is in progress.

- **Frontend**: Vue 3 + TypeScript + Vite 5 + Tailwind CSS 3 + Pinia
- **Backend**: Spring Boot 3.2.5 + Java 17 + MyBatis-Plus + Spring Security (JWT)
- **Database**: MySQL 8.0 (init script in `db/init.sql`)
- **Ports**: Frontend dev server on 5173, backend on 8080

## Commands

### Backend (blog-backend/)

```bash
# Build
cd blog-backend && mvn clean package -DskipTests

# Run (starts on port 8080)
cd blog-backend && mvn spring-boot:run

# Package as JAR
cd blog-backend && mvn clean package
```

### Frontend (blog-frontend/)

```bash
# Install dependencies
cd blog-frontend && npm install

# Dev server (starts on port 5173, proxies /api to 8080)
cd blog-frontend && npm run dev

# Build for production
cd blog-frontend && npm run build

# Preview production build
cd blog-frontend && npm run preview
```

### Database

```bash
# Initialize database (run once)
mysql -u root -p < db/init.sql
```

## Architecture

### Backend Structure (blog-backend/)

```
src/main/java/com/myblog/
├── BlogApplication.java          # Entry point
├── common/
│   ├── constant/AppConstant.java # Shared constants (article status, user roles, action types)
│   ├── exception/                # BusinessException, GlobalExceptionHandler
│   └── result/                   # Result<T> (unified API response), ResultCode, PageResult
├── config/
│   ├── CorsConfig.java           # CORS (allows localhost:5173)
│   ├── MyBatisPlusConfig.java    # MyBatis-Plus pagination plugin
│   ├── MyMetaObjectHandler.java  # Auto-fill createTime/updateTime
│   └── SecurityConfig.java       # JWT stateless auth, role-based access
├── controller/                   # REST endpoints (6 controllers)
│   ├── AuthController.java       # /api/auth/**
│   ├── ArticleController.java    # /api/articles/**
│   ├── CommentController.java    # /api/comments/**
│   ├── CategoryController.java   # /api/categories/**
│   ├── TagController.java        # /api/tags/**
│   └── UserController.java       # /api/users/**
├── dto/                          # Data transfer objects
├── entity/                       # Database entities: User, Article, Category, Tag, etc.
├── mapper/                       # MyBatis-Plus mappers
├── security/                     # JwtTokenProvider, JwtAuthenticationFilter, UserDetailsServiceImpl
└── service/                      # Service interfaces + impls
```

**Security flow**: JWT token in `Authorization: Bearer <token>` header. Public endpoints: auth, GET articles/categories/tags. Authenticated required for POST/PUT/DELETE on articles. Admin endpoints under `/api/admin/**` require `ROLE_ADMIN`.

### Frontend Structure (blog-frontend/)

```
src/
├── api/           # Axios-based API modules (request.ts with auth interceptor)
├── components/    # Reusable Vue components (HeaderBar, ArticleCard)
├── router/        # Vue Router config with auth guard (requiresAuth meta)
├── stores/        # Pinia stores (auth, theme)
├── types/         # TypeScript interfaces
└── views/         # Page components
    ├── Home.vue          # Article list with featured section, sidebar
    ├── Login.vue         # Login page
    ├── Register.vue      # Registration
    ├── ArticleDetail.vue # Article detail view
    ├── Editor.vue        # Markdown editor (create/edit)
    ├── UserProfile.vue   # User profile page
    └── Admin.vue         # Admin panel
```

**Auth interceptor**: Axios interceptor reads `localStorage.getItem('token')`, sets `Authorization` header, redirects to `/login` on 401.

### Database

Tables use `blog_` prefix. Key tables:
- `blog_user` — roles: 0=admin, 1=blogger, 2=user
- `blog_article` — status: 0=draft, 1=published, 2=scheduled, 3=banned
- `blog_comment` — supports nested replies via parent_id/reply_to_id
- `blog_interaction_log` — high-write throughput table for likes/collects/follows
- `sys_message` — notification messages (JSON content field)

### Key Conventions

- **API response format**: `{ code, message, data }` via `Result<T>` — code 200 for success, 4xx/5xx for errors
- **Pagination**: Uses MyBatis-Plus Page + custom `PageResult<T>` DTO with `records/total/page/pageSize/pages`
- **Article status lifecycle**: Draft (0) → Published (1) on explicit publish action; DTOs filter to published only via `listPublished()`
- **Backend auth**: `getCurrentUserId()` reads from SecurityContextHolder (JWT subject = user ID)
- **Backend time fields**: Auto-filled by MyMetaObjectHandler for createTime/updateTime
- **Frontend routing**: Guards use `meta.requiresAuth` (redirect to /login) and `meta.requiresAdmin`
- **Frontend API**: All requests go through `/api` prefix, proxied to 8080 in dev via vite.config.ts
