-- =====================================================
-- 个人博客系统 种子数据 (首次部署后执行)
-- =====================================================
USE myblog;

-- 插入示例文章 (已发布状态, user_id=4 是 demo 用户)
INSERT IGNORE INTO `blog_article` (`id`, `user_id`, `category_id`, `title`, `summary`, `content`, `status`, `publish_time`, `score`, `view_count`, `like_count`, `comment_count`, `collect_count`, `is_top`, `is_recommend`) VALUES
(1, 4, 1, 'Spring Boot 3 入门指南',
 '本文介绍如何使用 Spring Boot 3 快速构建 RESTful API 服务，涵盖项目初始化、依赖配置和常用注解。',
 '## 为什么选择 Spring Boot 3\n\nSpring Boot 3 是构建现代 Java 微服务的最佳选择之一。它提供了自动配置、起步依赖和嵌入式服务器等特性，让开发者可以快速启动项目。\n\n## 快速开始\n\n### 1. 创建项目\n\n可以通过 [Spring Initializr](https://start.spring.io/) 快速创建项目，选择以下依赖：\n\n- Spring Web\n- Spring Data JPA\n- MySQL Driver\n- Lombok\n\n### 2. 编写第一个 Controller\n\n```java\n@RestController\n@RequestMapping("/api/hello")\npublic class HelloController {\n\n    @GetMapping\n    public String hello() {\n        return "Hello, Spring Boot 3!";\n    }\n}\n```\n\n### 3. 配置数据库\n\n```yaml\nspring:\n  datasource:\n    url: jdbc:mysql://localhost:3306/myblog\n    username: root\n    password: your_password\n```\n\n## 总结\n\nSpring Boot 3 带来了很多新特性，包括 Jakarta EE 9+ 支持、AOT 编译等。推荐所有 Java 开发者尝试。',
 1, '2025-12-01 10:00:00', 95.5, 128, 32, 5, 12, 1, 1),

(2, 4, 3, '我的 2025 年度技术总结',
 '回顾过去一年的技术学习和项目实践，分享成长路上的思考与感悟。',
 '## 回顾 2025\n\n转眼间 2025 年就要过去了。这一年里，我深入学习了 Spring Boot 和 Vue 3 的生态体系，也完成了一些有意思的项目。\n\n### 技术成长\n\n- **后端**: 从 Spring MVC 迁移到 Spring Boot 3，学习了响应式编程\n- **前端**: 掌握了 Vue 3 + Composition API + TypeScript 的开发模式\n- **数据库**: 深入理解了 MySQL 索引优化和查询性能调优\n\n### 项目实践\n\n今年最大的收获是独立开发了 MyBlog 这个项目，从零开始搭建了一个完整的前后端分离博客系统。过程中遇到了很多挑战，也学到了很多。\n\n## 2026 年计划\n\n- 深入学习微服务架构（Spring Cloud）\n- 探索云原生技术（Docker, Kubernetes）\n- 持续输出优质技术文章\n\n> 路漫漫其修远兮，吾将上下而求索。',
 1, '2025-12-25 08:00:00', 88.0, 256, 48, 12, 25, 0, 1),

(3, 4, 1, 'Vue 3 + TypeScript 实战经验分享',
 'Vue 3 搭配 TypeScript 开发体验极佳，本文分享在实际项目中的最佳实践和常见陷阱。',
 '## 为什么选择 Vue 3 + TypeScript\n\nVue 3 的组合式 API（Composition API）与 TypeScript 的结合，让代码更加类型安全且易于维护。\n\n## 项目结构推荐\n\n```\nsrc/\n├── api/          # API 请求模块\n├── components/   # 公共组件\n├── composables/  # 组合式函数\n├── router/       # 路由配置\n├── stores/       # Pinia 状态管理\n├── types/        # TypeScript 类型定义\n└── views/        # 页面组件\n```\n\n## 实用技巧\n\n### 1. 使用 defineProps 和 defineEmits\n\n```typescript\ninterface Props {\n  title: string\n  count?: number\n}\n\nconst props = defineProps<Props>()\n```\n\n### 2. Pinia 的最佳实践\n\n```typescript\nexport const useCounterStore = defineStore("counter", () => {\n  const count = ref(0)\n  const doubleCount = computed(() => count.value * 2)\n  function increment() { count.value++ }\n  return { count, doubleCount, increment }\n})\n```\n\n## 总结\n\nVue 3 + TypeScript + Pinia 是现代前端开发的黄金组合，推荐每个前端开发者掌握。',
 1, '2026-01-15 14:00:00', 92.0, 189, 41, 8, 18, 0, 1),

(4, 4, 2, '开源一个博客系统：MyBlog',
 '介绍 MyBlog 开源项目的技术架构、设计理念和开发计划，诚邀社区贡献。',
 '## 项目介绍\n\nMyBlog 是一个基于前后端分离架构的个人博客与技术社区系统。前端使用 Vue 3 + TypeScript + Vite，后端使用 Spring Boot 3 + MyBatis-Plus。\n\n## 技术栈\n\n| 前端 | 后端 | 数据库 |\n|------|------|--------|\n| Vue 3 | Spring Boot 3 | MySQL 8.0 |\n| TypeScript | Java 17 | Redis |\n| Vite | MyBatis-Plus | Elasticsearch |\n| Tailwind CSS | Spring Security | RabbitMQ |\n\n## 核心功能\n\n1. **文章管理**: Markdown 编辑器、分类标签、定时发布\n2. **互动系统**: 点赞、收藏、评论（多级嵌套）\n3. **用户系统**: JWT 认证、个人主页、关注\n4. **检索系统**: 全文搜索、标签筛选\n\n## 如何贡献\n\n欢迎提交 Issue 和 PR！项目地址：https://github.com/example/myblog',
 1, '2026-02-01 09:00:00', 78.5, 342, 56, 15, 32, 0, 1),

(5, 4, 4, 'MySQL 索引优化实战笔记',
 '深入分析 MySQL 索引的工作原理，通过实际案例讲解如何优化慢查询。',
 '## 索引基础\n\nMySQL 的 InnoDB 引擎使用 B+ 树作为索引结构。合理使用索引可以大幅提升查询性能。\n\n## 常见索引类型\n\n- **主键索引**: 聚簇索引，叶子节点存储整行数据\n- **普通索引**: 非聚簇索引，叶子节点存储主键值\n- **联合索引**: 多列组合索引，遵循最左前缀原则\n- **全文索引**: 用于全文搜索\n\n## 优化案例\n\n### 慢查询分析\n\n```sql\n-- 原始查询（全表扫描）\nSELECT * FROM blog_article WHERE title LIKE "%Spring%";\n\n-- 优化方案：使用全文索引\nALTER TABLE blog_article ADD FULLTEXT INDEX ft_title_content(title, content);\nSELECT * FROM blog_article\nWHERE MATCH(title, content) AGAINST("Spring" IN BOOLEAN MODE);\n```\n\n### 分页优化\n\n```sql\n-- 传统分页（越往后越慢）\nSELECT * FROM blog_article ORDER BY id LIMIT 100000, 20;\n\n-- 优化：基于游标的分页\nSELECT * FROM blog_article WHERE id > 100000 ORDER BY id LIMIT 20;\n```\n\n## 总结\n\n索引优化是数据库性能调优的核心。建议在实际项目中多使用 EXPLAIN 分析查询计划。',
 1, '2026-03-10 16:00:00', 85.0, 167, 38, 7, 15, 0, 1),

(6, 4, 5, '从单体到微服务：架构演进之路',
 '探讨当项目规模扩大时，如何从单体架构平滑迁移到微服务架构。',
 '## 为什么要迁移\n\n当项目发展到一定规模，单体架构会遇到以下痛点：\n\n1. **构建部署慢**: 代码量增大导致构建时间变长\n2. **扩展困难**: 无法按需扩展单个模块\n3. **技术栈锁定**: 无法针对不同模块使用合适的技术\n\n## 微服务架构设计原则\n\n- **单一职责**: 每个服务只负责一个业务领域\n- **自治性**: 每个服务可以独立开发、部署和扩展\n- **去中心化**: 每个服务可以选择最适合的技术栈\n- **容错性**: 单个服务的失败不应影响整个系统\n\n## 技术选型\n\n- **服务框架**: Spring Cloud / Dubbo\n- **服务网关**: Spring Cloud Gateway / Kong\n- **配置中心**: Nacos / Apollo\n- **服务注册**: Nacos / Eureka\n- **分布式事务**: Seata\n\n## 迁移策略\n\n推荐使用"绞杀者模式"（Strangler Fig Pattern）：\n\n1. 识别可以拆分的模块边界\n2. 将新功能作为独立服务实现\n3. 逐步将旧功能迁移到新服务\n4. 最终移除单体应用中对已迁移功能的代码\n\n## 总结\n\n架构演进需要权衡利弊，不要为了微服务而微服务。小项目使用单体架构完全足够。',
 1, '2026-04-05 11:00:00', 82.0, 98, 22, 4, 10, 0, 0);

-- 插入文章-标签关联
INSERT IGNORE INTO `blog_article_tag` (`article_id`, `tag_id`) VALUES
(1, 1), (1, 2),    -- Spring Boot入门 -> Java, Spring Boot
(2, 3), (2, 6),    -- 年度总结 -> Vue, 前端
(3, 3), (3, 6),    -- Vue实战 -> Vue, 前端
(4, 1), (4, 2), (4, 5), -- 开源项目 -> Java, Spring Boot, 架构
(5, 4), (5, 8),    -- MySQL索引 -> 数据库, 算法
(6, 5), (6, 7);    -- 架构演进 -> 架构, DevOps

-- 插入示例评论
INSERT IGNORE INTO `blog_comment` (`id`, `article_id`, `user_id`, `parent_id`, `reply_to_id`, `content`, `status`) VALUES
(1, 1, 4, NULL, NULL, '写得很详细，对新手很友好！', 1),
(2, 2, 4, NULL, NULL, '2026 一起加油！', 1),
(3, 3, 4, NULL, NULL, 'Vue 3 + TypeScript 确实好用，我现在也在用这套组合', 1),
(4, 1, 4, 1, 1, '谢谢支持！后续还会写更多教程', 1);
