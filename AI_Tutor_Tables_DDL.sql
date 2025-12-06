-- =========================================================
-- 1) RAW TABLES
-- =========================================================

-- =========================
-- 1.1) MATH TABLE
-- =========================
CREATE TABLE IF NOT EXISTS math (
    math_id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    -- Who & where this came from
    child_id           BIGINT UNSIGNED NOT NULL,  -- Kevin for now
    source_type        ENUM('HOMEWORK', 'QUIZ', 'TEST', 'ASSIGNMENT', 'PROJECT') NOT NULL,
    source_title       VARCHAR(255),
    source_date        DATE,

    -- Question content (text only)
    question_number    INT,
    question_text      TEXT NOT NULL,
    given_expression   VARCHAR(500),

    -- Topic / skill tags
    grade_level        VARCHAR(20),
    main_topic         VARCHAR(100),
    sub_topic          VARCHAR(100),
    difficulty_level   TINYINT UNSIGNED,

    -- Kevin's answer & scoring
    student_answer     VARCHAR(255),
    correct_answer     VARCHAR(255),
    is_correct         BOOLEAN,
    score_obtained     DECIMAL(5,2),
    score_max          DECIMAL(5,2),
    teacher_comment    TEXT,

    -- AI fields
    ai_extracted_json  JSON,
    ai_feedback        TEXT,

    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    KEY idx_math_child_date (child_id, source_date),
    KEY idx_math_topic (main_topic, sub_topic),
    KEY idx_math_correct (is_correct)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- 1.2) ENGLISH GRAMMAR TABLE
-- =========================
CREATE TABLE IF NOT EXISTS english_grammar (
    grammar_id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    child_id           BIGINT UNSIGNED NOT NULL,
    source_type        ENUM('HOMEWORK', 'QUIZ', 'TEST', 'ASSIGNMENT', 'PROJECT') NOT NULL,
    source_title       VARCHAR(255),
    source_date        DATE,

    question_number    INT,
    question_text      TEXT NOT NULL,

    -- Grammar-specific tags
    grammar_point      VARCHAR(150),     -- e.g. 'past tense', 'subject-verb agreement'
    error_type         VARCHAR(150),     -- e.g. 'verb tense', 'capitalization'
    sentence_original  TEXT,
    sentence_corrected TEXT,

    grade_level        VARCHAR(20),
    difficulty_level   TINYINT UNSIGNED,

    -- Kevin's response
    student_answer     TEXT,
    correct_answer     TEXT,
    is_correct         BOOLEAN,
    score_obtained     DECIMAL(5,2),
    score_max          DECIMAL(5,2),
    teacher_comment    TEXT,

    -- AI fields
    ai_extracted_json  JSON,
    ai_feedback        TEXT,

    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    KEY idx_eg_child_date (child_id, source_date),
    KEY idx_eg_grammar_point (grammar_point),
    KEY idx_eg_correct (is_correct)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- 1.3) ENGLISH VOCABULARY TABLE
-- =========================
CREATE TABLE IF NOT EXISTS english_vocabulary (
    vocab_id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    child_id           BIGINT UNSIGNED NOT NULL,
    source_type        ENUM('HOMEWORK', 'QUIZ', 'TEST', 'ASSIGNMENT', 'PROJECT') NOT NULL,
    source_title       VARCHAR(255),
    source_date        DATE,

    question_number    INT,
    question_text      TEXT NOT NULL,

    -- Vocabulary tags
    vocab_word         VARCHAR(100),
    part_of_speech     VARCHAR(50),
    question_type      ENUM('SPELLING', 'DEFINITION', 'USE_IN_SENTENCE',
                            'SYNONYM', 'ANTONYM', 'FILL_IN_BLANK') NOT NULL,

    grade_level        VARCHAR(20),
    difficulty_level   TINYINT UNSIGNED,

    -- Kevin's response
    student_answer     TEXT,
    correct_answer     TEXT,
    is_correct         BOOLEAN,
    score_obtained     DECIMAL(5,2),
    score_max          DECIMAL(5,2),
    teacher_comment    TEXT,

    -- AI fields
    ai_extracted_json  JSON,
    ai_feedback        TEXT,

    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    KEY idx_ev_child_date (child_id, source_date),
    KEY idx_ev_word (vocab_word),
    KEY idx_ev_correct (is_correct)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- 2) PROGRESS TABLES
-- =========================================================

-- =========================
-- 2.1) MATH PROGRESS TABLE
-- =========================
CREATE TABLE IF NOT EXISTS math_progress (
    child_id           BIGINT UNSIGNED NOT NULL,
    main_topic         VARCHAR(100) NOT NULL,
    sub_topic          VARCHAR(100) DEFAULT NULL,

    total_questions    INT UNSIGNED NOT NULL DEFAULT 0,
    correct_questions  INT UNSIGNED NOT NULL DEFAULT 0,
    total_score        DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_max_score    DECIMAL(10,2) NOT NULL DEFAULT 0,

    last_practiced_at  TIMESTAMP NULL,
    ai_summary         TEXT,

    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (child_id, main_topic, sub_topic),
    KEY idx_mp_child (child_id),
    KEY idx_mp_topic (main_topic, sub_topic)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- 2.2) ENGLISH GRAMMAR PROGRESS TABLE
-- =========================
CREATE TABLE IF NOT EXISTS english_grammar_progress (
    child_id           BIGINT UNSIGNED NOT NULL,
    grammar_point      VARCHAR(150) NOT NULL,

    total_questions    INT UNSIGNED NOT NULL DEFAULT 0,
    correct_questions  INT UNSIGNED NOT NULL DEFAULT 0,
    total_score        DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_max_score    DECIMAL(10,2) NOT NULL DEFAULT 0,

    last_practiced_at  TIMESTAMP NULL,
    ai_summary         TEXT,

    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (child_id, grammar_point),
    KEY idx_egp_child (child_id),
    KEY idx_egp_grammar_point (grammar_point)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- 2.3) ENGLISH VOCABULARY PROGRESS TABLE
-- =========================
CREATE TABLE IF NOT EXISTS english_vocabulary_progress (
    child_id           BIGINT UNSIGNED NOT NULL,
    vocab_word         VARCHAR(100) NOT NULL,

    total_questions    INT UNSIGNED NOT NULL DEFAULT 0,
    correct_questions  INT UNSIGNED NOT NULL DEFAULT 0,
    total_score        DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_max_score    DECIMAL(10,2) NOT NULL DEFAULT 0,

    last_practiced_at  TIMESTAMP NULL,
    ai_summary         TEXT,

    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (child_id, vocab_word),
    KEY idx_evp_child (child_id),
    KEY idx_evp_word (vocab_word)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
