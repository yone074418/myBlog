package com.myblog.controller;

import com.myblog.common.result.Result;
import com.myblog.dto.CommentDTO;
import com.myblog.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    @GetMapping("/article/{articleId}")
    public Result<List<CommentDTO>> listByArticle(@PathVariable Long articleId) {
        return Result.success(commentService.listByArticle(articleId));
    }

    @PostMapping("/article/{articleId}")
    @PreAuthorize("isAuthenticated()")
    public Result<CommentDTO> create(@PathVariable Long articleId,
                                      @RequestParam String content,
                                      @RequestParam(required = false) Long parentId,
                                      @RequestParam(required = false) Long replyToId) {
        return Result.success(commentService.create(articleId, content, parentId, replyToId));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public Result<Void> delete(@PathVariable Long id) {
        commentService.delete(id);
        return Result.success();
    }
}
