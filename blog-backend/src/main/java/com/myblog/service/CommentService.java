package com.myblog.service;

import com.myblog.dto.CommentDTO;
import com.myblog.dto.PageResult;

import java.util.List;

public interface CommentService {
    List<CommentDTO> listByArticle(Long articleId);
    CommentDTO create(Long articleId, String content, Long parentId, Long replyToId);
    void delete(Long id);
}
