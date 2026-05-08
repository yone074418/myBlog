package com.myblog.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class CommentDTO {
    private Long id;
    private Long articleId;
    private Long userId;
    private String authorName;
    private String authorAvatar;
    private Long parentId;
    private Long replyToId;
    private String replyToName;
    private String content;
    private Integer likeCount;
    private LocalDateTime createTime;
    private List<CommentDTO> replies;
}
