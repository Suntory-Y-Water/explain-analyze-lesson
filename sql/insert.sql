INSERT INTO users (username, email)
SELECT
    'User' || i,
    'user' || i || '@example.com'
FROM generate_series(1, 1000000) AS s(i);

INSERT INTO posts (user_id, content, created_at)
SELECT
    (RANDOM() * 999999 + 1)::INT,
    'Post content ' || i,
    NOW() - (RANDOM() * INTERVAL '365 days')
FROM generate_series(1, 5000000) AS s(i);

INSERT INTO comments (post_id, user_id, content, created_at)
SELECT
    (RANDOM() * 4999999 + 1)::INT,
    (RANDOM() * 999999 + 1)::INT,
    'Comment content ' || i,
    NOW() - (RANDOM() * INTERVAL '365 days')
FROM generate_series(1, 1000000) AS s(i);

INSERT INTO likes (user_id, post_id, comment_id, created_at)
SELECT
    (RANDOM() * 999999 + 1)::INT,
    CASE WHEN RANDOM() < 0.5 THEN (RANDOM() * 4999999 + 1)::INT ELSE NULL END,
    CASE WHEN RANDOM() >= 0.5 THEN (RANDOM() * 9999999 + 1)::INT ELSE NULL END,
    NOW() - (RANDOM() * INTERVAL '365 days')
FROM generate_series(1, 1000000) AS s(i);

INSERT INTO followers (follower_id, followee_id, followed_at)
SELECT
    follower_id,
    followee_id,
    followed_at
FROM (
    SELECT
        (RANDOM() * 999999 + 1)::INT AS follower_id,
        (RANDOM() * 999999 + 1)::INT AS followee_id,
        NOW() - (RANDOM() * INTERVAL '365 days') AS followed_at
    FROM generate_series(1, 1000000) AS s(i)
) sub
WHERE follower_id <> followee_id;


INSERT INTO followers (follower_id, followee_id, followed_at)
SELECT
    1 AS follower_id,
    followee_id,
    NOW() - (RANDOM() * INTERVAL '365 days') AS followed_at
FROM generate_series(2, 101) AS s(followee_id);