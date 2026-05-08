-- =====================================================
-- 个人博客系统 种子数据 (首次部署后执行)
-- =====================================================
SET NAMES utf8mb4;
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

-- 插入更多文章 (id 7-12)
INSERT IGNORE INTO `blog_article` (`id`, `user_id`, `category_id`, `title`, `summary`, `content`, `status`, `publish_time`, `score`, `view_count`, `like_count`, `comment_count`, `collect_count`, `is_top`, `is_recommend`) VALUES
(7, 4, 1, '深入理解 Java 并发编程：从基础到实战',
 '全面解析 Java 并发编程的核心概念，包括线程池、锁机制、并发容器等，以及在实际项目中的应用技巧。',
 '## 为什么需要并发编程\n\n在现代多核 CPU 时代，充分利用硬件资源、提升程序性能已经成为每个后端开发者的必备技能。Java 提供了丰富的并发编程工具，从基础的 Thread 到高级的 CompletableFuture，应有尽有。\n\n## 线程池详解\n\n### ThreadPoolExecutor 的核心参数\n\n```java\nThreadPoolExecutor executor = new ThreadPoolExecutor(\n    corePoolSize,      // 核心线程数\n    maximumPoolSize,   // 最大线程数\n    keepAliveTime,     // 空闲线程存活时间\n    TimeUnit.SECONDS,\n    new LinkedBlockingQueue<>(queueCapacity), // 任务队列\n    new ThreadPoolExecutor.AbortPolicy()      // 拒绝策略\n);\n```\n\n### 拒绝策略\n\n1. **AbortPolicy** (默认): 直接抛出 RejectedExecutionException\n2. **CallerRunsPolicy**: 由调用线程执行任务\n3. **DiscardPolicy**: 静默丢弃\n4. **DiscardOldestPolicy**: 丢弃队列中最旧的任务\n\n## 锁机制\n\n### synchronized vs Lock\n\n| 特性 | synchronized | Lock |\n|------|-------------|------|\n| 获取方式 | 隐式 | 显式 (lock/unlock) |\n| 可中断 | 否 | 是 |\n| 超时 | 否 | 是 (tryLock) |\n| 公平性 | 非公平 | 可配置 |\n| 条件变量 | 单一 | 多个 (Condition) |\n\n### ReentrantLock 示例\n\n```java\nprivate final ReentrantLock lock = new ReentrantLock();\n\npublic void safeMethod() {\n    lock.lock();\n    try {\n        // 临界区代码\n        System.out.println(\"线程安全操作\");\n    } finally {\n        lock.unlock();\n    }\n}\n```\n\n## 并发容器\n\n- **ConcurrentHashMap**: 分段锁设计，高并发下性能优于 HashTable\n- **CopyOnWriteArrayList**: 读多写少场景的利器\n- **BlockingQueue**: 生产者-消费者模式的基石\n- **ConcurrentLinkedQueue**: 无锁队列，适合高并发场景\n\n## CompletableFuture 异步编程\n\n```java\nCompletableFuture<Integer> future = CompletableFuture\n    .supplyAsync(() -> fetchDataFromDB())\n    .thenApplyAsync(data -> processData(data))\n    .exceptionally(ex -> {\n        log.error(\"处理失败\", ex);\n        return 0;\n    });\n```\n\n## 实际项目中的最佳实践\n\n1. 使用线程池而不是直接创建线程\n2. 合理配置线程池参数（CPU密集型 vs IO密集型）\n3. 使用 CountDownLatch / CyclicBarrier 协调多线程\n4. 注意 ThreadLocal 的内存泄漏问题\n5. 优先使用高层次的并发工具类\n\n## 总结\n\n并发编程是 Java 后端开发的核心技能。掌握好并发编程，不仅能提升程序性能，还能写出更健壮的代码。建议多读源码（如 ConcurrentHashMap 的实现），多做实验来加深理解。',
 1, '2026-04-15 10:00:00', 91.0, 215, 45, 9, 22, 0, 1),

(8, 4, 1, 'RESTful API 设计最佳实践：构建优雅的 Web 接口',
 '从 URL 设计、状态码使用到版本管理，全面讲解如何设计出易用、可维护的 RESTful API。',
 '## 什么是 RESTful API\n\nREST（Representational State Transfer）是一种架构风格，而不是协议。RESTful API 是基于 REST 原则设计的 Web 接口，具有无状态、可缓存、统一接口等特点。\n\n## URL 设计规范\n\n### 资源命名\n\n- 使用名词复数形式：`/users`, `/articles`, `/orders`\n- 避免使用动词：`/getUser` → 应该用 `GET /users/:id`\n- 层级关系用斜杠：`/users/:userId/orders`\n- 使用下划线或连字符：`/created-articles`（推荐连字符）\n\n### 标准端点示例\n\n```\nGET    /api/articles          # 获取文章列表\nPOST   /api/articles          # 创建文章\nGET    /api/articles/:id      # 获取单篇文章\nPUT    /api/articles/:id      # 更新文章\nDELETE /api/articles/:id      # 删除文章\nGET    /api/articles/:id/comments  # 获取文章评论\n```\n\n## HTTP 状态码\n\n正确使用状态码可以让 API 更加语义化：\n\n| 范围 | 含义 | 常用状态码 |\n|------|------|-----------|\n| 2xx | 成功 | 200 OK, 201 Created, 204 No Content |\n| 3xx | 重定向 | 301 Moved Permanently, 304 Not Modified |\n| 4xx | 客户端错误 | 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found |\n| 5xx | 服务端错误 | 500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable |\n\n## 请求与响应设计\n\n### 统一响应格式\n\n```json\n{\n    \"code\": 200,\n    \"message\": \"success\",\n    \"data\": {\n        \"id\": 1,\n        \"title\": \"文章标题\",\n        \"createdAt\": \"2026-04-15T10:00:00Z\"\n    }\n}\n```\n\n### 分页\n\n```json\n{\n    \"code\": 200,\n    \"data\": {\n        \"records\": [...],\n        \"total\": 100,\n        \"page\": 1,\n        \"pageSize\": 10,\n        \"pages\": 10\n    }\n}\n```\n\n### 错误处理\n\n```json\n{\n    \"code\": 400,\n    \"message\": \"用户名不能为空\",\n    \"data\": null\n}\n```\n\n## 安全性\n\n1. 使用 HTTPS 加密传输\n2. API 认证：JWT / OAuth2\n3. 输入验证：拒绝恶意数据\n4. 速率限制：防止滥用\n5. 敏感数据脱敏\n\n## API 版本管理\n\n推荐使用 URL 路径或请求头进行版本管理：\n\n- `/api/v1/articles` (URL 路径)\n- `Accept: application/vnd.myapp.v1+json` (请求头)\n\n## 总结\n\n设计好的 RESTful API 是一门艺术。一致性、简洁性、可预测性是核心原则。建议在设计初期就制定好规范，并在团队中严格执行。',
 1, '2026-04-20 14:00:00', 87.5, 178, 36, 7, 16, 0, 0),

(9, 4, 3, '程序员如何高效学习新技术：我的方法论',
 '分享我在十年编程生涯中总结出来的高效学习方法和知识管理体系。',
 '## 前言\n\n技术日新月异，作为一名软件工程师，持续学习是保持竞争力的关键。但如何高效地学习新技术，避免浅尝辄止或迷失在知识的海洋中？\n\n## 学习金字塔\n\n根据学习金字塔理论，不同的学习方式有不同的知识留存率：\n\n1. **听课** (5%) — 被动学习，效率最低\n2. **阅读** (10%) — 有一定效果\n3. **视听结合** (20%) — 适合入门\n4. **演示** (30%) — 看别人做\n5. **讨论** (50%) — 与人交流\n6. **实践** (75%) — 亲手去做\n7. **教授他人** (90%) — 最高效的学习方式\n\n## 我的学习方法论\n\n### 第一步：建立知识地图\n\n在开始学习新技术之前，我会先花 30 分钟浏览官方文档的大纲和高频关键词，建立一个粗略的知识地图。这让我在学习过程中不会迷失方向。\n\n### 第二步：做中学 (Learning by Doing)\n\n看一百遍不如动手做一遍。我会：\n\n1. 搭建开发环境\n2. 跑通官方示例\n3. 做一个 Mini 项目\n4. 逐步增加复杂度\n\n### 第三步：费曼学习法\n\n把自己学到的知识用最简单的话讲给别人听。如果讲不清楚，说明还没真正理解。\n\n## 知识管理体系\n\n### 使用 Markdown 做笔记\n\n```markdown\n# 技术主题\n\n## 核心概念\n- 定义\n- 解决的问题\n- 优缺点\n\n## 代码示例\n```java\n// 关键代码\n```\n\n## 踩坑记录\n- 问题现象\n- 原因分析\n- 解决方案\n```\n\n### 建立个人 Wiki\n\n我使用 GitBook / Notion 搭建个人知识库，按主题分类整理。每学完一个技术，就输出一篇结构化的笔记。\n\n## 学习节奏\n\n### 番茄工作法\n- 25 分钟专注学习\n- 5 分钟休息\n- 每 4 个番茄钟休息 15 分钟\n\n### 刻意练习\n\n不要停留在舒适区，要针对自己的薄弱环节进行刻意练习。比如前端开发者深入学习算法，后端开发者研究前端工程化。\n\n## 推荐的学习资源\n\n1. **官方文档** — 最权威的学习资料\n2. **GitHub 开源项目** — 阅读优秀源码\n3. **技术博客** — 了解最佳实践\n4. **技术会议** — 把握行业趋势\n\n## 总结\n\n学习方法比学习内容更重要。找到适合自己的学习节奏，建立知识体系，保持好奇心和学习热情。记住：从输入到输出，从理论到实践，从学习到教授，这才是完整的学习闭环。',
 1, '2026-04-25 08:00:00', 93.0, 312, 67, 14, 28, 0, 1),

(10, 4, 4, 'Docker 从入门到精通：容器化部署实战',
 '详解 Docker 的核心概念、常用命令和 Docker Compose，以及如何在生产环境中进行容器化部署。',
 '## 为什么需要 Docker\n\nDocker 解决了开发环境和生产环境不一致的问题。通过容器化技术，你可以将应用及其依赖打包成一个轻量级、可移植的镜像，在任何环境中运行。\n\n## 核心概念\n\n### 镜像 (Image)\n\n镜像是容器的模板，包含了运行应用所需的代码、运行时、系统工具、库和配置。\n\n### 容器 (Container)\n\n容器是镜像的运行实例。你可以对容器进行启动、停止、删除等操作。\n\n### Dockerfile\n\nDockerfile 是构建镜像的自动化脚本。\n\n## 常用命令\n\n### 镜像管理\n\n```bash\n# 拉取镜像\ndocker pull nginx:latest\n\n# 列出本地镜像\ndocker images\n\n# 删除镜像\ndocker rmi nginx:latest\n\n# 构建镜像\ndocker build -t myapp:1.0 .\n```\n\n### 容器管理\n\n```bash\n# 运行容器\ndocker run -d --name myapp -p 8080:8080 myapp:1.0\n\n# 列出运行中的容器\ndocker ps\n\n# 查看容器日志\ndocker logs -f myapp\n\n# 进入容器\ndocker exec -it myapp bash\n\n# 停止容器\ndocker stop myapp\n```\n\n## Docker Compose\n\nDocker Compose 可以定义和运行多容器应用。\n\n```yaml\nversion: \"3.8\"\nservices:\n  web:\n    build: .\n    ports:\n      - \"8080:8080\"\n    depends_on:\n      - db\n    environment:\n      SPRING_DATASOURCE_URL: jdbc:mysql://db:3306/myblog\n\n  db:\n    image: mysql:8.0\n    environment:\n      MYSQL_ROOT_PASSWORD: root123\n      MYSQL_DATABASE: myblog\n    volumes:\n      - mysql_data:/var/lib/mysql\n\nvolumes:\n  mysql_data:\n```\n\n## 生产环境最佳实践\n\n### 多阶段构建\n\n```dockerfile\n# Build stage\nFROM maven:3.9-eclipse-temurin-17 AS builder\nWORKDIR /app\nCOPY pom.xml .\nRUN mvn dependency:go-offline\nCOPY src ./src\nRUN mvn clean package -DskipTests\n\n# Runtime stage\nFROM eclipse-temurin:17-jre\nWORKDIR /app\nCOPY --from=builder /app/target/*.jar app.jar\nEXPOSE 8080\nENTRYPOINT [\"java\", \"-jar\", \"app.jar\"]\n```\n\n### 镜像瘦身技巧\n\n1. 使用 Alpine 基础镜像\n2. 多阶段构建\n3. 清理不必要的文件\n4. 合并 RUN 命令减少层数\n\n## 总结\n\nDocker 已经成为现代软件开发和部署的事实标准。掌握 Docker 不仅能解决环境问题，还能极大地提升开发和运维效率。建议从日常开发开始使用 Docker Compose 管理依赖服务（数据库、Redis、MQ 等）。',
 1, '2026-05-01 09:00:00', 89.5, 245, 52, 11, 24, 0, 0),

(11, 4, 5, 'Redis 实战：缓存策略与高可用架构',
 '深入讲解 Redis 的数据结构、缓存策略、持久化机制以及集群高可用架构设计。',
 '## Redis 简介\n\nRedis 是一个高性能的键值存储系统，支持丰富的数据结构。它被广泛应用于缓存、会话管理、消息队列、排行榜等场景。\n\n## 数据结构详解\n\n### String (字符串)\n\n最基本的类型，可以存储任何字符串。\n\n```bash\nSET user:1:name \"张三\"\nGET user:1:name\nSETNX lock:article:1 1  # 分布式锁\n```\n\n### Hash (哈希)\n\n适合存储对象。\n\n```bash\nHSET article:1 title \"Redis实战\" views 100\nHGETALL article:1\n```\n\n### List (列表)\n\n基于链表实现，适合消息队列。\n\n```bash\nLPUSH queue:notifications \"msg1\"\nBRPOP queue:notifications 0\n```\n\n### Set (集合)\n\n无序集合，支持交集、并集、差集运算。\n\n```bash\nSADD user:1:tags \"java\" \"spring\"\nSINTER user:1:tags user:2:tags  # 共同标签\n```\n\n### ZSet (有序集合)\n\n带权重的集合，适合排行榜。\n\n```bash\nZADD leaderboard 100 \"user1\"\nZINCRBY leaderboard 10 \"user1\"\nZREVRANGE leaderboard 0 9 WITHSCORES  # 前十名\n```\n\n## 缓存策略\n\n### 缓存穿透\n\n**问题**: 查询不存在的数据，每次都穿透到数据库。\n**解决**: 布隆过滤器 + 缓存空值。\n\n### 缓存击穿\n\n**问题**: 热点 key 过期瞬间，大量请求打到数据库。\n**解决**: 互斥锁 + 热点数据永不过期。\n\n### 缓存雪崩\n\n**问题**: 大量 key 同时过期，导致数据库压力激增。\n**解决**: 过期时间加随机值 + 多级缓存 + 熔断降级。\n\n## 持久化\n\n### RDB (快照)\n\n- 优点：适合备份和灾难恢复\n- 缺点：可能丢失最后一次快照后的数据\n\n### AOF (追加文件)\n\n- 优点：数据安全性高，最多丢失 1 秒数据\n- 缺点：文件体积大，恢复速度慢\n\n## 高可用架构\n\n### 主从复制\n\n- 一主多从，主节点负责写，从节点负责读\n- 自动故障转移 (Sentinel)\n\n### Redis Cluster\n\n- 数据自动分片到 16384 个槽位\n- 每个分片有主从节点\n- 无中心化架构\n\n## 实际项目中的应用\n\n### 文章热度排行榜\n\n```java\n// 文章点赞时\nstringRedisTemplate.opsForZSet()\n    .incrementScore(\"article:hot\", articleId.toString(), 1);\n\n// 获取热门文章 Top 10\nSet<String> topArticles = stringRedisTemplate.opsForZSet()\n    .reverseRange(\"article:hot\", 0, 9);\n```\n\n## 总结\n\nRedis 是后端开发中的瑞士军刀。掌握 Redis 的各种使用场景和最佳实践，能够极大地提升应用的性能和可扩展性。建议在日常开发中多思考哪些数据适合用 Redis 来优化。',
 1, '2026-05-05 16:00:00', 90.0, 198, 42, 8, 19, 0, 1),

(12, 4, 1, '从零开始搭建 CI/CD 流水线：GitHub Actions 实战',
 '手把手教你使用 GitHub Actions 搭建自动化构建、测试和部署流水线，实现真正的持续交付。',
 '## 什么是 CI/CD\n\n持续集成 (Continuous Integration) 和持续交付/部署 (Continuous Delivery/Deployment) 是现代软件开发的核心实践。\n\n- **CI**: 代码合并后自动构建和测试，确保代码质量\n- **CD**: 自动化部署到测试/生产环境\n\n## GitHub Actions 基础\n\nGitHub Actions 是 GitHub 提供的 CI/CD 平台，使用 YAML 格式定义工作流。\n\n### 核心概念\n\n- **Workflow**: 一个完整的自动化流程\n- **Job**: 工作流中的一个任务单元\n- **Step**: Job 中的每一步操作\n- **Action**: 可复用的自动化单元\n- **Runner**: 运行工作流的服务器\n\n## 构建后端 CI 流水线\n\n```yaml\nname: Backend CI\n\non:\n  push:\n    branches: [main, develop]\n  pull_request:\n    branches: [main]\n\njobs:\n  build:\n    runs-on: ubuntu-latest\n\n    steps:\n      - uses: actions/checkout@v4\n\n      - name: Set up JDK 17\n        uses: actions/setup-java@v4\n        with:\n          java-version: \"17\"\n          distribution: \"temurin\"\n\n      - name: Build with Maven\n        run: mvn clean package -DskipTests\n\n      - name: Run tests\n        run: mvn test\n```\n\n## 构建前端 CI 流水线\n\n```yaml\nname: Frontend CI\n\non:\n  push:\n    branches: [main]\n    paths:\n      - \"blog-frontend/**\"\n\njobs:\n  build:\n    runs-on: ubuntu-latest\n    defaults:\n      run:\n        working-directory: blog-frontend\n\n    steps:\n      - uses: actions/checkout@v4\n\n      - name: Setup Node.js\n        uses: actions/setup-node@v4\n        with:\n          node-version: \"20\"\n\n      - name: Install dependencies\n        run: npm ci\n\n      - name: Build\n        run: npm run build\n```\n\n## 自动化部署\n\n### 部署到服务器\n\n```yaml\ndeploy:\n  runs-on: ubuntu-latest\n  needs: build\n  steps:\n    - name: Deploy to Server\n      uses: appleboy/ssh-action@v1\n      with:\n        host: ${{ secrets.SERVER_HOST }}\n        username: ${{ secrets.SERVER_USER }}\n        key: ${{ secrets.SSH_PRIVATE_KEY }}\n        script: |\n          cd /opt/myblog\n          git pull\n          cd blog-backend && mvn spring-boot:run &\n```\n\n### Docker 部署\n\n```yaml\ndocker-deploy:\n  runs-on: ubuntu-latest\n  steps:\n    - name: Build Docker Image\n      run: docker build -t myblog-backend:latest .\n\n    - name: Push to Registry\n      run: |\n        docker tag myblog-backend:latest ghcr.io/${{ github.repository }}/backend:latest\n        docker push ghcr.io/${{ github.repository }}/backend:latest\n```\n\n## 质量门禁\n\n在流水线中加入质量检测：\n\n1. **代码格式化检查**: Checkstyle / ESLint\n2. **代码覆盖率**: JaCoCo / Istanbul\n3. **安全扫描**: Snyk / Dependabot\n4. **性能测试**: JMeter / k6\n\n## 最佳实践\n\n1. 流水线尽量快地给出反馈\n2. 使用缓存加速构建：Maven 依赖缓存、npm 缓存\n3. 环境变量和密钥使用 Secrets 管理\n4. 区分不同环境的配置\n5. 构建产物作为 Artifact 保存\n\n## 总结\n\nCI/CD 是现代软件工程的基石。GitHub Actions 提供了强大而灵活的 CI/CD 能力，而且对开源项目完全免费。建议从简单的构建和测试开始，逐步完善部署流程。记住：自动化不是一蹴而就的，而是持续改进的过程。',
 1, '2026-05-08 11:00:00', 86.0, 156, 33, 6, 14, 0, 0);

-- 插入更多文章-标签关联
INSERT IGNORE INTO `blog_article_tag` (`article_id`, `tag_id`) VALUES
(7, 1), (7, 5),      -- Java并发 -> Java, 架构
(8, 5), (8, 6),      -- RESTful API -> 架构, 前端
(9, 3),               -- 学习方法 -> Vue (无对应标签，用前端替代)
(10, 7),              -- Docker -> DevOps
(11, 4), (11, 5),    -- Redis -> 数据库, 架构
(12, 7);              -- CI/CD -> DevOps

-- 插入更多评论
INSERT IGNORE INTO `blog_comment` (`id`, `article_id`, `user_id`, `parent_id`, `reply_to_id`, `content`, `status`) VALUES
(5, 7, 4, NULL, NULL, '写得很全面，特别是线程池这部分，讲得很清楚', 1),
(6, 9, 4, NULL, NULL, '费曼学习法确实好用，我最近也在用这个方法学习 Spring Cloud', 1),
(7, 11, 4, NULL, NULL, '缓存穿透的布隆过滤器方案，在实际项目中很有用', 1),
(8, 12, 4, NULL, NULL, 'GitHub Actions 配置得很详细，照着配就能用', 1);

-- 为推荐文章设置封面图
UPDATE `blog_article` SET `cover_image` = 'https://picsum.photos/seed/spring/400/200' WHERE `id` = 1;
UPDATE `blog_article` SET `cover_image` = 'https://picsum.photos/seed/year/400/200' WHERE `id` = 2;
UPDATE `blog_article` SET `cover_image` = 'https://picsum.photos/seed/vue3/400/200' WHERE `id` = 3;
UPDATE `blog_article` SET `cover_image` = 'https://picsum.photos/seed/docker/400/200' WHERE `id` = 10;
UPDATE `blog_article` SET `cover_image` = 'https://picsum.photos/seed/redis/400/200' WHERE `id` = 11;
UPDATE `blog_article` SET `cover_image` = 'https://picsum.photos/seed/code/400/200' WHERE `id` = 9;
