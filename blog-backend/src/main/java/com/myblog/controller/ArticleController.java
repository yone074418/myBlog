package com.myblog.controller;

import com.myblog.common.result.Result;
import com.myblog.dto.*;
import com.myblog.service.ArticleService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/articles")
@RequiredArgsConstructor
public class ArticleController {

    private final ArticleService articleService;

    @GetMapping
    public Result<PageResult<ArticleDTO>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(defaultValue = "latest") String sort,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Long tagId) {
        return Result.success(articleService.listPublished(page, pageSize, sort, categoryId, tagId));
    }

    @GetMapping("/{id}")
    public Result<ArticleDTO> detail(@PathVariable Long id) {
        return Result.success(articleService.getById(id));
    }

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public Result<ArticleDTO> create(@Valid @RequestBody ArticleCreateRequest request) {
        return Result.success(articleService.create(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public Result<ArticleDTO> update(@PathVariable Long id,
                                      @Valid @RequestBody ArticleUpdateRequest request) {
        return Result.success(articleService.update(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public Result<Void> delete(@PathVariable Long id) {
        articleService.delete(id);
        return Result.success();
    }

    @GetMapping("/user/{userId}")
    public Result<PageResult<ArticleDTO>> listByUser(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(articleService.listByUser(userId, page, pageSize));
    }
}
