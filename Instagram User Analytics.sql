-- ////////////////////////////////////////////////////////
-- Find the 5 oldest users
SELECT 
    id, username, created_at
FROM
    users
ORDER BY created_at
LIMIT 5;

-- ////////////////////////////////////////////////////////
-- Find the users who have never posted a single photo
SELECT 
    users.id AS 'user id', users.username
FROM
    users
WHERE
    users.id NOT IN (SELECT 
            photos.user_id
        FROM
            photos);
            
-- ///////////////////////////////////////////////////////
-- user most likes on a single photo
SELECT 
    photos.user_id,
    users.username,
    likes.photo_id,
    COUNT(likes.photo_id) AS likes_count
FROM
    likes
        JOIN
    photos ON likes.photo_id = photos.id
        JOIN
    users ON photos.user_id = users.id
GROUP BY photo_id
ORDER BY likes_count DESC
LIMIT 1;

-- /////////////////////////////////////////
-- top 5 most commonly used hashtags
SELECT 
    tags.id AS tag_id,
    CONCAT('#', tags.tag_name) AS Hashtag,
    COUNT(photo_tags.tag_id) AS uses_count
FROM
    tags
        JOIN
    photo_tags ON photo_tags.tag_id = tags.id
GROUP BY photo_tags.tag_id
ORDER BY uses_count DESC
LIMIT 5;

-- /////////////////////////////////////////////////////
-- day of the week do most users register on
SELECT 
    COUNT(created_at) AS registration,
    DAYNAME(created_at) AS day_name
FROM
    users
GROUP BY day_name
ORDER BY 1 DESC;

-- ///////////////////////////////////////////////////
-- how many times does average user posts
	SELECT 
		AVG(post_count) AS 'avrage post count',
		SUM(post_count) AS 'total photos',
		COUNT(ID) AS 'total users'
	FROM
		(SELECT 
			users.id AS ID, COUNT(photos.id) AS post_count
		FROM
			photos
		RIGHT JOIN users ON photos.user_id = users.id
		GROUP BY users.id) post_per_user;
	
-- ////////////////////////////////////////////////////////////
-- data on users (bots) who have liked every single photo
SELECT 
    a.user_id, users.username
FROM
    (SELECT 
        user_id, COUNT(photo_id) AS like_count
    FROM
        likes
    GROUP BY user_id) a
        JOIN
    users ON a.user_id = users.id
WHERE
    like_count = (SELECT 
            COUNT(id)
        FROM
            photos);
