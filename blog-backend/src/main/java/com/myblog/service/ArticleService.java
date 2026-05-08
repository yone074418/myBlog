package com.myblog.service;

import com.myblog.dto.ArticleCreateRequest;
import com.myblog.dto.ArticleDTO;
import com.myblog.dto.ArticleUpdateRequest;
import com.myblog.dto.PageResult;

public interface ArticleService {
    PageResult<ArticleDTO> listPublished(int page, int pageSize, String sort, Long categoryId, Long tagId);
    ArticleDTO getById(Long id);
    ArticleDTO create(ArticleCreateRequest request);
    ArticleDTO update(Long id, ArticleUpdateRequest request);
    void delete(Long id);
    PageResult<ArticleDTO> listByUser(Long userId, int page, int pageSize);
}
