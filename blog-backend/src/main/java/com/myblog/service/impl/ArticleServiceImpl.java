package com.myblog.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.myblog.common.constant.AppConstant;
import com.myblog.common.exception.BusinessException;
import com.myblog.dto.*;
import com.myblog.entity.*;
import com.myblog.mapper.*;
import com.myblog.service.ArticleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {

    private final ArticleMapper articleMapper;
    private final ArticleTagMapper articleTagMapper;
    private final UserMapper userMapper;
    private final CategoryMapper categoryMapper;
    private final TagMapper tagMapper;

    @Override
    public PageResult<ArticleDTO> listPublished(int page, int pageSize, String sort, Long categoryId, Long tagId) {
        LambdaQueryWrapper<Article> wrapper = Wrappers.<Article>lambdaQuery()
                .eq(Article::getStatus, AppConstant.ARTICLE_STATUS_PUBLISHED);

        if (categoryId != null) {
            wrapper.eq(Article::getCategoryId, categoryId);
        }

        if (tagId != null) {
            List<ArticleTag> articleTags = articleTagMapper.selectList(
                    Wrappers.<ArticleTag>lambdaQuery().eq(ArticleTag::getTagId, tagId));
            List<Long> articleIds = articleTags.stream()
                    .map(ArticleTag::getArticleId).toList();
            if (articleIds.isEmpty()) {
                PageResult<ArticleDTO> result = new PageResult<>();
                result.setRecords(Collections.emptyList());
                result.setTotal(0);
                result.setPage(page);
                result.setPageSize(pageSize);
                result.setPages(0);
                return result;
            }
            wrapper.in(Article::getId, articleIds);
        }

        if ("hot".equals(sort)) {
            wrapper.orderByDesc(Article::getScore);
        } else {
            wrapper.orderByDesc(Article::getIsTop).orderByDesc(Article::getPublishTime);
        }

        Page<Article> articlePage = articleMapper.selectPage(new Page<>(page, pageSize), wrapper);
        return toPageResult(articlePage);
    }

    @Override
    public ArticleDTO getById(Long id) {
        Article article = articleMapper.selectById(id);
        if (article == null) {
            throw new BusinessException(404, "article not found");
        }

        articleMapper.incrementViewCount(id);
        article.setViewCount(article.getViewCount() + 1);

        return toDTO(article);
    }

    @Override
    @Transactional
    public ArticleDTO create(ArticleCreateRequest request) {
        Article article = new Article();
        article.setUserId(getCurrentUserId());
        article.setCategoryId(request.getCategoryId());
        article.setTitle(request.getTitle());
        article.setSummary(request.getSummary());
        article.setCoverImage(request.getCoverImage());
        article.setSeoKeywords(request.getSeoKeywords());
        article.setContent(request.getContent());
        article.setStatus(request.getStatus() != null ? request.getStatus() : AppConstant.ARTICLE_STATUS_DRAFT);
        article.setPublishTime(request.getPublishTime());
        article.setScore(0.0);
        article.setViewCount(0);
        article.setLikeCount(0);
        article.setCommentCount(0);
        article.setCollectCount(0);
        article.setIsTop(0);
        article.setIsRecommend(0);

        if (article.getStatus() == AppConstant.ARTICLE_STATUS_PUBLISHED && article.getPublishTime() == null) {
            article.setPublishTime(java.time.LocalDateTime.now());
        }

        articleMapper.insert(article);

        if (request.getTagIds() != null) {
            for (Long tagId : request.getTagIds()) {
                ArticleTag at = new ArticleTag();
                at.setArticleId(article.getId());
                at.setTagId(tagId);
                articleTagMapper.insert(at);
            }
        }

        return toDTO(article);
    }

    @Override
    @Transactional
    public ArticleDTO update(Long id, ArticleUpdateRequest request) {
        Article article = articleMapper.selectById(id);
        if (article == null) {
            throw new BusinessException(404, "article not found");
        }

        if (!article.getUserId().equals(getCurrentUserId())) {
            throw new BusinessException(403, "not allowed to update this article");
        }

        if (request.getCategoryId() != null) article.setCategoryId(request.getCategoryId());
        if (request.getTitle() != null) article.setTitle(request.getTitle());
        if (request.getSummary() != null) article.setSummary(request.getSummary());
        if (request.getCoverImage() != null) article.setCoverImage(request.getCoverImage());
        if (request.getSeoKeywords() != null) article.setSeoKeywords(request.getSeoKeywords());
        if (request.getContent() != null) article.setContent(request.getContent());
        if (request.getStatus() != null) {
            article.setStatus(request.getStatus());
            if (request.getStatus() == AppConstant.ARTICLE_STATUS_PUBLISHED && article.getPublishTime() == null) {
                article.setPublishTime(java.time.LocalDateTime.now());
            }
        }
        if (request.getPublishTime() != null) article.setPublishTime(request.getPublishTime());

        articleMapper.updateById(article);

        if (request.getTagIds() != null) {
            articleTagMapper.deleteByArticleId(id);
            for (Long tagId : request.getTagIds()) {
                ArticleTag at = new ArticleTag();
                at.setArticleId(id);
                at.setTagId(tagId);
                articleTagMapper.insert(at);
            }
        }

        return toDTO(article);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Article article = articleMapper.selectById(id);
        if (article == null) {
            throw new BusinessException(404, "article not found");
        }
        articleMapper.deleteById(id);
        articleTagMapper.deleteByArticleId(id);
    }

    @Override
    public PageResult<ArticleDTO> listByUser(Long userId, int page, int pageSize) {
        LambdaQueryWrapper<Article> wrapper = Wrappers.<Article>lambdaQuery()
                .eq(Article::getUserId, userId)
                .orderByDesc(Article::getCreateTime);
        Page<Article> articlePage = articleMapper.selectPage(new Page<>(page, pageSize), wrapper);
        return toPageResult(articlePage);
    }

    private ArticleDTO toDTO(Article article) {
        ArticleDTO dto = new ArticleDTO();
        dto.setId(article.getId());
        dto.setUserId(article.getUserId());
        dto.setCategoryId(article.getCategoryId());
        dto.setTitle(article.getTitle());
        dto.setSummary(article.getSummary());
        dto.setContent(article.getContent());
        dto.setCoverImage(article.getCoverImage());
        dto.setSeoKeywords(article.getSeoKeywords());
        dto.setStatus(article.getStatus());
        dto.setPublishTime(article.getPublishTime());
        dto.setScore(article.getScore());
        dto.setViewCount(article.getViewCount());
        dto.setLikeCount(article.getLikeCount());
        dto.setCommentCount(article.getCommentCount());
        dto.setCollectCount(article.getCollectCount());
        dto.setIsTop(article.getIsTop());
        dto.setIsRecommend(article.getIsRecommend());
        dto.setCreateTime(article.getCreateTime());
        dto.setUpdateTime(article.getUpdateTime());

        // author info
        User author = userMapper.selectById(article.getUserId());
        if (author != null) {
            dto.setAuthorName(author.getNickname() != null ? author.getNickname() : author.getUsername());
            dto.setAuthorAvatar(author.getAvatar());
        }

        // category name
        Category category = categoryMapper.selectById(article.getCategoryId());
        if (category != null) {
            dto.setCategoryName(category.getName());
        }

        // tags
        List<Long> tagIds = articleTagMapper.selectTagIdsByArticleId(article.getId());
        if (!tagIds.isEmpty()) {
            List<Tag> tags = tagMapper.selectBatchIds(tagIds);
            dto.setTags(tags.stream().map(t -> {
                TagDTO tagDTO = new TagDTO();
                tagDTO.setId(t.getId());
                tagDTO.setName(t.getName());
                tagDTO.setColor(t.getColor());
                return tagDTO;
            }).collect(Collectors.toList()));
        }

        return dto;
    }

    private PageResult<ArticleDTO> toPageResult(Page<Article> articlePage) {
        PageResult<ArticleDTO> result = new PageResult<>();
        result.setRecords(articlePage.getRecords().stream().map(this::toDTO).toList());
        result.setTotal(articlePage.getTotal());
        result.setPage(articlePage.getCurrent());
        result.setPageSize(articlePage.getSize());
        result.setPages(articlePage.getPages());
        return result;
    }

    private Long getCurrentUserId() {
        return Long.parseLong(
                org.springframework.security.core.context.SecurityContextHolder.getContext()
                        .getAuthentication().getName());
    }
}
