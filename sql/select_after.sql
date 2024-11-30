WITH relevant_posts AS ( 
    SELECT
        p.post_id
        , p.content AS post_content
        , p.created_at AS post_created_at
        , u.username AS post_user 
    FROM
        posts p 
        JOIN users u 
            ON p.user_id = u.user_id 
    WHERE
        p.user_id IN ( 
            SELECT
                followee_id 
            FROM
                followers 
            WHERE
                follower_id = 1
        ) 
    ORDER BY
        p.created_at DESC 
    LIMIT
        100
) 
SELECT
    rp.post_id
    , rp.post_content
    , rp.post_created_at
    , rp.post_user
    , count(c.comment_id) AS comment_count
    , max(c.created_at) AS last_comment_at
    , string_agg(c_recent.content, '; ') AS recent_comments 
FROM
    relevant_posts rp 
    LEFT JOIN comments c 
        ON rp.post_id = c.post_id 
    LEFT JOIN LATERAL ( 
        SELECT
            content 
        FROM
            comments 
        WHERE
            post_id = rp.post_id 
        ORDER BY
            created_at DESC 
        LIMIT
            5
    ) c_recent 
        ON TRUE 
GROUP BY
    rp.post_id
    , rp.post_content
    , rp.post_created_at
    , rp.post_user 
ORDER BY
    rp.post_created_at DESC;
