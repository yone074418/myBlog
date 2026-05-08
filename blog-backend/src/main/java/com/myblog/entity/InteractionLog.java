package com.myblog.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("blog_interaction_log")
public class InteractionLog {
    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;
    private Long targetId;
    private Integer actionType;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
