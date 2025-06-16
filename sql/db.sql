CREATE DATABASE IF NOT EXISTS `friend_stuff`;

USE `friend_stuff`;

CREATE TABLE IF NOT EXISTS `users` (
    `user_id` INT AUTO_INCREMENT NOT NULL,
    `username` VARCHAR(100) NOT NULL UNIQUE,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`user_id`)
);

CREATE TABLE IF NOT EXISTS `friendships` (
    `user1_id` INT NOT NULL,
    `user2_id` INT NOT NULL,
    `state_request` ENUM ('pending', 'accepted', 'denied') DEFAULT 'pending' NOT NULL,
    PRIMARY KEY (`user1_id`, `user2_id`),
    FOREIGN KEY (`user1_id`) REFERENCES users (`user_id`),
    FOREIGN KEY (`user2_id`) REFERENCES users (`user_id`)
);

CREATE TABLE IF NOT EXISTS `groups` (
    `group_id` INT NOT NULL AUTO_INCREMENT,
    `group_name` VARCHAR(100) NOT NULL,
    `description` VARCHAR(255) NULL,
    `creation_date` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (`group_id`)
);

CREATE TABLE IF NOT EXISTS `group_members` (
    `group_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `join_date` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    `role` ENUM ('admin', 'member') DEFAULT 'member' NOT NULL,
    PRIMARY KEY (`group_id`, `user_id`),
    FOREIGN KEY (`group_id`) REFERENCES groups (`group_id`),
    FOREIGN KEY (`user_id`) REFERENCES users (`user_id`)
);

CREATE TABLE IF NOT EXISTS `locations` (
    `location_id` INT NOT NULL AUTO_INCREMENT,
    `location_name` VARCHAR(100) NOT NULL,
    `city` VARCHAR(100) NULL,
    `street` VARCHAR(100) NULL,
    `street_number` INT NULL,
    PRIMARY KEY (`location_id`)
);

CREATE TABLE IF NOT EXISTS `events` (
    `event_id` INT NOT NULL AUTO_INCREMENT,
    `group_id` INT NOT NULL,
    `location_id` INT NOT NULL,
    `event_title` VARCHAR(100) NOT NULL,
    `category` ENUM (
        'food',
        'party',
        'holidays',
        'relax',
        'camping',
        'other'
    ) DEFAULT 'other' NOT NULL,
    `start_date` DATETIME NOT NULL,
    `end_date` DATETIME NOT NULL,
    `description` VARCHAR(255) NULL,
    PRIMARY KEY (`event_id`),
    FOREIGN KEY (`group_id`) REFERENCES groups (`group_id`),
    FOREIGN KEY (`location_id`) REFERENCES locations (`location_id`),
    CHECK (`end_date` >= `start_date`)
);

CREATE TABLE IF NOT EXISTS `chat` (
    `chat_id` INT NOT NULL AUTO_INCREMENT,
    `event_id` INT NOT NULL,
    PRIMARY KEY (`chat_id`),
    FOREIGN KEY (`event_id`) REFERENCES events (`event_id`)
);

CREATE TABLE IF NOT EXISTS `messages` (
    `message_id` INT NOT NULL AUTO_INCREMENT,
    `chat_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `content` TEXT NOT NULL,
    `send_date` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (`message_id`),
    FOREIGN KEY (`chat_id`) REFERENCES chat (`chat_id`),
    FOREIGN KEY (`user_id`) REFERENCES users (`user_id`)
);

CREATE TABLE IF NOT EXISTS `attachments` (
    `attachment_id` INT NOT NULL AUTO_INCREMENT,
    `message_id` INT NOT NULL,
    `file_name` VARCHAR(255) NOT NULL,
    `file_type` VARCHAR(255) NOT NULL,
    `file_size` BIGINT NOT NULL,
    PRIMARY KEY (`attachment_id`),
    FOREIGN KEY (`message_id`) REFERENCES messages (`message_id`)
);

CREATE TABLE IF NOT EXISTS `expenses` (
    `expense_id` INT NOT NULL AUTO_INCREMENT,
    `event_id` INT NOT NULL,
    `payer_id` INT NOT NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `expense_name` VARCHAR(100) NOT NULL,
    `description` VARCHAR(255) NULL,
    `expense_date` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (`expense_id`),
    FOREIGN KEY (`event_id`) REFERENCES events (`event_id`),
    FOREIGN KEY (`payer_id`) REFERENCES users (`user_id`),
    CHECK (`amount` > 0)
);

CREATE TABLE IF NOT EXISTS `expense_contributions` (
    `participant_id` INT NOT NULL,
    `expense_id` INT NOT NULL,
    `amount_owed` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`participant_id`, `expense_id`),
    FOREIGN KEY (`participant_id`) REFERENCES users (`user_id`),
    FOREIGN KEY (`expense_id`) REFERENCES expenses (`expense_id`),
    CHECK (`amount_owed` >= 0)
);
