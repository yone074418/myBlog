-- =====================================================
-- 个人博客系统 数据库初始化脚本 (Phase 1 - MVP)
-- =====================================================

CREATE DATABASE IF NOT EXISTS myblog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE myblog;

-- ==================== 用户表 ====================
CREATE TABLE IF NOT EXISTS `blog_user` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `username`    VARCHAR(50)  NOT NULL COMMENT '用户名',
    `password`    VARCHAR(255) NOT NULL COMMENT '加密密码',
    `nickname`    VARCHAR(50)  DEFAULT NULL COMMENT '昵称',
    `email`       VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `avatar`      VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    `bio`         VARCHAR(200) DEFAULT NULL COMMENT '个人简介',
    `github_id`   VARCHAR(100) DEFAULT NULL COMMENT 'GitHub OAuth ID',
    `role`        TINYINT      DEFAULT 1 COMMENT '角色(0:管理员, 1:博主, 2:普通用户)',
    `level`       INT          DEFAULT 0 COMMENT '用户等级',
    `status`      TINYINT      DEFAULT 1 COMMENT '状态(0:封禁, 1:正常)',
    `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ==================== 分类表 ====================
CREATE TABLE IF NOT EXISTS `blog_category` (
    `id`          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
    `name`        VARCHAR(50) NOT NULL COMMENT '分类名称',
    `description` VARCHAR(200) DEFAULT NULL COMMENT '分类描述',
    `sort_order`  INT         DEFAULT 0 COMMENT '排序顺序',
    `create_time` DATETIME    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章分类表';

-- ==================== 标签表 ====================
CREATE TABLE IF NOT EXISTS `blog_tag` (
    `id`          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
    `name`        VARCHAR(30) NOT NULL COMMENT '标签名称',
    `color`       VARCHAR(20) DEFAULT '#3B82F6' COMMENT '标签颜色(用于前端展示)',
    `create_time` DATETIME    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签表';

-- ==================== 文章表 ====================
CREATE TABLE IF NOT EXISTS `blog_article` (
    `id`           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`      BIGINT        NOT NULL COMMENT '作者ID',
    `category_id`  BIGINT        DEFAULT NULL COMMENT '分类ID',
    `title`        VARCHAR(200)  NOT NULL COMMENT '文章标题',
    `summary`      VARCHAR(500)  DEFAULT NULL COMMENT '文章摘要',
    `content`      LONGTEXT      NOT NULL COMMENT '文章内容(Markdown)',
    `cover_image`  VARCHAR(500)  DEFAULT NULL COMMENT '封面图URL',
    `seo_keywords` VARCHAR(200)  DEFAULT NULL COMMENT 'SEO关键词',
    `status`       TINYINT       DEFAULT 0 COMMENT '状态(0:草稿, 1:已发布, 2:定时发布, 3:封禁)',
    `publish_time` DATETIME      DEFAULT NULL COMMENT '发布时间',
    `score`        DOUBLE        DEFAULT 0 COMMENT '热度分数(Hacker News算法)',
    `view_count`   INT           DEFAULT 0 COMMENT '阅读量',
    `like_count`   INT           DEFAULT 0 COMMENT '点赞数',
    `comment_count` INT          DEFAULT 0 COMMENT '评论数',
    `collect_count` INT          DEFAULT 0 COMMENT '收藏数',
    `is_top`       TINYINT       DEFAULT 0 COMMENT '是否置顶(0:否, 1:是)',
    `is_recommend` TINYINT       DEFAULT 0 COMMENT '是否推荐(0:否, 1:是)',
    `create_time`  DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`  DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_category_id` (`category_id`),
    KEY `idx_status` (`status`),
    KEY `idx_publish_time` (`publish_time`),
    KEY `idx_score` (`score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章表';

-- ==================== 文章-标签关联表 ====================
CREATE TABLE IF NOT EXISTS `blog_article_tag` (
    `id`         BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `article_id` BIGINT NOT NULL COMMENT '文章ID',
    `tag_id`     BIGINT NOT NULL COMMENT '标签ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_article_tag` (`article_id`, `tag_id`),
    KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章标签关联表';

-- ==================== 评论表(支持多级嵌套) ====================
CREATE TABLE IF NOT EXISTS `blog_comment` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `article_id`  BIGINT       NOT NULL COMMENT '文章ID',
    `user_id`     BIGINT       NOT NULL COMMENT '评论用户ID',
    `parent_id`   BIGINT       DEFAULT NULL COMMENT '父评论ID(支持嵌套)',
    `reply_to_id` BIGINT       DEFAULT NULL COMMENT '回复目标评论ID',
    `content`     TEXT         NOT NULL COMMENT '评论内容(支持Markdown)',
    `like_count`  INT          DEFAULT 0 COMMENT '点赞数',
    `status`      TINYINT      DEFAULT 1 COMMENT '状态(0:隐藏, 1:正常)',
    `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_article_id` (`article_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- ==================== 互动流水表(高频写入) ====================
CREATE TABLE IF NOT EXISTS `blog_interaction_log` (
    `id`          BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`     BIGINT   NOT NULL COMMENT '发起互动的用户ID',
    `target_id`   BIGINT   NOT NULL COMMENT '目标ID(文章/评论ID)',
    `action_type` TINYINT  NOT NULL COMMENT '动作类型(1:点赞, 2:收藏, 3:关注)',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '互动时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_target_id` (`target_id`),
    KEY `idx_action_type` (`action_type`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='互动流水表(异步写入)';

-- ==================== 消息通知表 ====================
CREATE TABLE IF NOT EXISTS `sys_message` (
    `id`          BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `receiver_id` BIGINT   NOT NULL COMMENT '接收者ID',
    `type`        TINYINT  NOT NULL COMMENT '消息类型(1:系统通知, 2:点赞, 3:评论, 4:新粉丝)',
    `content`     JSON     DEFAULT NULL COMMENT '详细内容(JSON)',
    `is_read`     TINYINT  DEFAULT 0 COMMENT '是否已读(0:未读, 1:已读)',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_receiver_id` (`receiver_id`),
    KEY `idx_is_read` (`is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息通知表';

-- ==================== 用户关注表 ====================
CREATE TABLE IF NOT EXISTS `blog_user_follow` (
    `id`          BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `follower_id` BIGINT   NOT NULL COMMENT '关注者ID',
    `followed_id` BIGINT   NOT NULL COMMENT '被关注者ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_follow` (`follower_id`, `followed_id`),
    KEY `idx_followed_id` (`followed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户关注表';

-- ==================== 标签云表 ====================
CREATE TABLE IF NOT EXISTS `blog_tag_cloud` (
    `id`          BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `tag_id`      BIGINT NOT NULL COMMENT '标签ID',
    `article_count` INT DEFAULT 0 COMMENT '关联文章数',
    `weight`      DOUBLE DEFAULT 0 COMMENT '权重(用于标签云展示)',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签云统计表';

-- ==================== 初始数据 ====================
INSERT INTO `blog_category` (`name`, `description`, `sort_order`) VALUES
('技术分享', '后端、前端、架构等技术文章', 1),
('开源项目', '开源项目介绍与使用指南', 2),
('生活随笔', '生活感悟与日常记录', 3),
('学习笔记', '学习过程中的笔记与总结', 4);

INSERT INTO `blog_tag` (`name`, `color`) VALUES
('Java', '#E74C3C'),
('Spring Boot', '#27AE60'),
('Vue', '#3498DB'),
('数据库', '#9B59B6'),
('架构', '#F39C12'),
('前端', '#1ABC9C'),
('DevOps', '#E67E22'),
('算法', '#2C3E50');
