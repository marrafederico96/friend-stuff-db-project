CREATE DATABASE IF NOT EXISTS `friend_stuff`;

USE DATABASE `friend_stuff`;

CREATE TABLE IF NOT EXISTS `users` (
    `user_id` AUTO_INCREMENT NOT NULL INT,
    `username` NOT NULL UNIQUE VARCHAR(100),
    `email` NOT NULL UNIQUE VARCHAR(100),
    `first_name` NOT NULL VARCHAR(100),
    `last_name` NOT NULL VARCHAR(100),
    PRIMARY KEY (`user_id`)
);

CREATE TABLE IF NOT EXISTS `friendships` (
    `user1_id` NOT NULL INT,
    `user2_id` NOT NULL INT,
    `state_request` NOT NULL ENUM ('pending', 'accepted', 'denied') DEFAULT 'pending',
    PRIMARY KEY (`user1_id`, `user2_id`),
    FOREIGN KEY (`user1_id`) REFERENCES users (`user_id`),
    FOREIGN KEY (`user2_id`) REFERENCES users (`user_id`)
);

CREATE TABLE IF NOT EXISTS `groups` (
    `group_id` NOT NULL AUTO_INCREMENT INT,
    `group_name` NOT NULL VARCHAR(100),
    `description` NULL VARCHAR(255),
    `creation_date` NOT NULL DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`group_id`)
);

CREATE TABLE IF NOT EXISTS `group_members` (
    `group_id` NOT NULL INT,
    `user_id` NOT NULL INT,
    `join_date` NOT NULL DATETIME DEFAULT CURRENT_TIMESTAMP,
    `role` NOT NULL ENUM ('admin', 'member') DEFAULT 'member',
    PRIMARY KEY (`group_id`, `user_id`),
    FOREIGN KEY (`group_id`) REFERENCES groups (`group_id`),
    FOREIGN KEY (`user_id`) REFERENCES users (`user_id`)
);

CREATE TABLE IF NOT EXISTS `locations` (
    `location_id` NOT NULL AUTO_INCREMENT INT,
    `location_name` NOT NULL VARCHAR(100),
    `city` NULL VARCHAR(100),
    `street` NULL VARCHAR(100),
    `street_number` NULL INT,
    PRIMARY KEY (`location_id`)
);

CREATE TABLE IF NOT EXISTS `events` (
    `event_id` NOT NULL AUTO_INCREMENT INT,
    `group_id` NOT NULL INT,
    `location_id` NOT NULL INT,
    `event_title` NOT NULL VARCHAR(100),
    `category` NOT NULL ENUM (
        'food',
        'party',
        'holidays',
        'relax',
        'camping',
        'other'
    ) DEFAULT 'other',
    `start_date` NOT NULL DATETIME,
    `end_date` NOT NULL DATETIME,
    `description` NULL VARCHAR(255),
    PRIMARY KEY (`event_id`),
    FOREIGN KEY (`group_id`) REFERENCES groups (`group_id`),
    FOREIGN KEY (`location_id`) REFERENCES locations (`location_id`)
);

CREATE TABLE IF NOT EXISTS `chat` (
    `chat_id` NOT NULL AUTO_INCREMENT INT,
    `event_id` NOT NULL INT,
    PRIMARY KEY (`chat_id`),
    FOREIGN KEY (`event_id`) REFERENCES events (`event_id`)
);

CREATE TABLE IF NOT EXISTS `messages` (
    `message_id` NOT NULL AUTO_INCREMENT INT,
    `chat_id` NOT NULL INT,
    `user_id` NOT NULL INT,
    `content` NOT NULL TEXT,
    `send_date` NOT NULL DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`message_id`),
    FOREIGN KEY (`chat_id`) REFERENCES chat (`chat_id`),
    FOREIGN KEY (`user_id`) REFERENCES users (`user_id`)
);

CREATE TABLE IF NOT EXISTS `attachments` (
    `attachment_id` NOT NULL AUTO_INCREMENT INT,
    `message_id` NOT NULL INT,
    `file_name` NOT NULL VARCHAR(255),
    `file_type` NOT NULL VARCHAR(255),
    `file_size` NOT NULL BIGINT,
    PRIMARY KEY (`attachment_id`),
    FOREIGN KEY (`message_id`) REFERENCES messages (`message_id`)
);

CREATE TABLE IF NOT EXISTS `expenses` (
    `expense_id` NOT NULL AUTO_INCREMENT INT,
    `event_id` NOT NULL INT,
    `payer_id` NOT NULL INT,
    `amount` NOT NULL DECIMAL(10, 2),
    `expense_name` NOT NULL VARCHAR(100),
    `description` NULL VARCHAR(255),
    `expense_date` NOT NULL DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`expense_id`),
    FOREIGN KEY (`event_id`) REFERENCES events (`event_id`),
    FOREIGN KEY (`payer_id`) REFERENCES users (`user_id`)
);

CREATE TABLE IF NOT EXISTS `expense_contributinos` (
    `participant_id` NOT NULL INT,
    `expense_id` NOT NULL INT,
    `amount_owed` NOT NULL DECIMAL(10, 2),
    PRIMARY KEY (`participant_id`, `expense_id`),
    FOREIGN KEY (`participant_id`) REFERENCES users (`user_id`),
    FOREIGN KEY (`expense_id`) REFERENCES expenses (`expense_id`)
);
