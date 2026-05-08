package com.myblog.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ArticleUpdateRequest {
    private Long categoryId;
    private String title;
    private String summary;
    private String coverImage;
    private String seoKeywords;
    private String content;
    private Integer status;
    private LocalDateTime publishTime;
    private List<Long> tagIds;
}
