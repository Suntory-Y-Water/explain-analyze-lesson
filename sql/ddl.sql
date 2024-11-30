DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS posts CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS likes CASCADE;


CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE posts (
    post_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    content TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE comments (
    comment_id SERIAL PRIMARY KEY,
    post_id INT REFERENCES posts(post_id),
    user_id INT REFERENCES users(user_id),
    content TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE likes (
    like_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    post_id INT,  -- NULLの場合はcomment_idが使用される
    comment_id INT,
    created_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS followers CASCADE;
CREATE TABLE followers (
    follower_id INT REFERENCES users(user_id),
    followee_id INT REFERENCES users(user_id),
    followed_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (follower_id, followee_id)
);

CREATE INDEX idx_comments_post_id_created_at ON comments(post_id, created_at DESC);
CREATE INDEX idx_followers_follower_id ON followers(follower_id);
CREATE INDEX idx_posts_user_id_created_at ON posts(user_id, created_at DESC);
