package com.myblog.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ArticleDTO {
    private Long id;
    private Long userId;
    private String authorName;
    private String authorAvatar;
    private Long categoryId;
    private String categoryName;
    private String title;
    private String summary;
    private String content;
    private String coverImage;
    private String seoKeywords;
    private Integer status;
    private LocalDateTime publishTime;
    private Double score;
    private Integer viewCount;
    private Integer likeCount;
    private Integer commentCount;
    private Integer collectCount;
    private Integer isTop;
    private Integer isRecommend;
    private List<TagDTO> tags;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
