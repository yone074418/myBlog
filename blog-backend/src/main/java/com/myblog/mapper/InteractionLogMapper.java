package com.myblog.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.myblog.entity.InteractionLog;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

public interface InteractionLogMapper extends BaseMapper<InteractionLog> {

    @Select("SELECT COUNT(*) FROM blog_interaction_log " +
            "WHERE user_id = #{userId} AND target_id = #{targetId} AND action_type = #{actionType}")
    int countInteraction(@Param("userId") Long userId,
                         @Param("targetId") Long targetId,
                         @Param("actionType") Integer actionType);
}
