package com.myblog.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.myblog.common.exception.BusinessException;
import com.myblog.dto.CommentDTO;
import com.myblog.entity.Article;
import com.myblog.entity.Comment;
import com.myblog.entity.User;
import com.myblog.mapper.ArticleMapper;
import com.myblog.mapper.CommentMapper;
import com.myblog.mapper.UserMapper;
import com.myblog.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {

    private final CommentMapper commentMapper;
    private final UserMapper userMapper;
    private final ArticleMapper articleMapper;

    @Override
    public List<CommentDTO> listByArticle(Long articleId) {
        List<Comment> comments = commentMapper.selectList(
                Wrappers.<Comment>lambdaQuery()
                        .eq(Comment::getArticleId, articleId)
                        .eq(Comment::getStatus, 1)
                        .orderByAsc(Comment::getCreateTime));

        // Build nested comment tree
        List<Comment> topLevel = comments.stream()
                .filter(c -> c.getParentId() == null)
                .toList();
        Map<Long, List<Comment>> repliesMap = comments.stream()
                .filter(c -> c.getParentId() != null)
                .collect(Collectors.groupingBy(Comment::getParentId));

        return topLevel.stream()
                .map(c -> toCommentDTO(c, repliesMap))
                .toList();
    }

    @Override
    public CommentDTO create(Long articleId, String content, Long parentId, Long replyToId) {
        if (articleMapper.selectById(articleId) == null) {
            throw new BusinessException(404, "article not found");
        }

        Long userId = getCurrentUserId();

        Comment comment = new Comment();
        comment.setArticleId(articleId);
        comment.setUserId(userId);
        comment.setParentId(parentId);
        comment.setReplyToId(replyToId);
        comment.setContent(content);
        comment.setLikeCount(0);
        comment.setStatus(1);
        commentMapper.insert(comment);

        // increment comment count
        articleMapper.update(null,
                Wrappers.<Article>lambdaUpdate()
                        .setSql("comment_count = comment_count + 1")
                        .eq(Article::getId, articleId));

        CommentDTO dto = toCommentDTO(comment);
        if (replyToId != null) {
            Comment replyToComment = commentMapper.selectById(replyToId);
            if (replyToComment != null) {
                User replyToUser = userMapper.selectById(replyToComment.getUserId());
                if (replyToUser != null) {
                    dto.setReplyToName(replyToUser.getNickname() != null ?
                            replyToUser.getNickname() : replyToUser.getUsername());
                }
            }
        }
        return dto;
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Comment comment = commentMapper.selectById(id);
        if (comment == null) {
            throw new BusinessException(404, "comment not found");
        }
        commentMapper.deleteById(id);

        articleMapper.update(null,
                Wrappers.<Article>lambdaUpdate()
                        .setSql("comment_count = GREATEST(comment_count - 1, 0)")
                        .eq(Article::getId, comment.getArticleId()));
    }

    private CommentDTO toCommentDTO(Comment comment) {
        return toCommentDTO(comment, null);
    }

    private CommentDTO toCommentDTO(Comment comment, Map<Long, List<Comment>> repliesMap) {
        CommentDTO dto = new CommentDTO();
        dto.setId(comment.getId());
        dto.setArticleId(comment.getArticleId());
        dto.setUserId(comment.getUserId());
        dto.setParentId(comment.getParentId());
        dto.setReplyToId(comment.getReplyToId());
        dto.setContent(comment.getContent());
        dto.setLikeCount(comment.getLikeCount());
        dto.setCreateTime(comment.getCreateTime());

        User user = userMapper.selectById(comment.getUserId());
        if (user != null) {
            dto.setAuthorName(user.getNickname() != null ? user.getNickname() : user.getUsername());
            dto.setAuthorAvatar(user.getAvatar());
        }

        if (repliesMap != null) {
            List<Comment> replies = repliesMap.get(comment.getId());
            if (replies != null) {
                dto.setReplies(replies.stream()
                        .map(r -> toCommentDTO(r, repliesMap))
                        .toList());
            } else {
                dto.setReplies(new ArrayList<>());
            }
        }

        return dto;
    }

    private Long getCurrentUserId() {
        return Long.parseLong(
                SecurityContextHolder.getContext().getAuthentication().getName());
    }
}
