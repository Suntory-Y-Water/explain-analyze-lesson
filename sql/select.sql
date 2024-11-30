SELECT
    p.post_id
    , p.content AS post_content
    , p.created_at AS post_created_at
    , u.username AS post_user
    , count(c.comment_id) AS comment_count
    , max(c.created_at) AS last_comment_at
    , string_agg(c2.content, '; ') AS recent_comments 
FROM
    posts p 
    JOIN users u 
        ON p.user_id = u.user_id 
    LEFT JOIN comments c 
        ON p.post_id = c.post_id 
    LEFT JOIN LATERAL ( 
        SELECT
            content 
        FROM
            comments 
        WHERE
            post_id = p.post_id 
        ORDER BY
            created_at DESC 
        LIMIT
            5
    ) c2 
        ON TRUE 
WHERE
    p.user_id IN ( 
        SELECT
            followee_id 
        FROM
            followers 
        WHERE
            follower_id = 1
    ) 
GROUP BY
    p.post_id
    , p.content
    , p.created_at
    , u.username 
ORDER BY
    p.created_at DESC 
LIMIT
    100;
