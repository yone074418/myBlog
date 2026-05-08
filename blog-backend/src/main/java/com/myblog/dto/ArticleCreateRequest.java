package com.myblog.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ArticleCreateRequest {
    @NotNull(message = "categoryId is required")
    private Long categoryId;

    @NotBlank(message = "title is required")
    private String title;

    private String summary;
    private String coverImage;
    private String seoKeywords;

    @NotBlank(message = "content is required")
    private String content;

    private Integer status;
    private LocalDateTime publishTime;
    private List<Long> tagIds;
}
