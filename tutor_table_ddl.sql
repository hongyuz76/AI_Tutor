USE ai_tutor;
DROP TABLE IF EXISTS students; 

CREATE TABLE IF NOT EXISTS students (
    student_id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name          VARCHAR(100) NOT NULL,
    last_name 			VARCHAR(100) NOT NULL,
    grade_level     	INT, -- e.g., 1 , 5
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS schoolwork;

CREATE TABLE IF NOT EXISTS schoolwork (
    schoolwork_id   	BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    student_id          BIGINT UNSIGNED NOT NULL,
    subject             ENUM('MATH', 'ENGLISH') NOT NULL,
    work_type           ENUM('HOMEWORK', 'QUIZ', 'TEST', 'ASSIGNMENT', 'PRACTICE', 'PROJECT') NOT NULL,
    work_date           DATE,  -- Date the work was done/due
    work_desc           VARCHAR(255) NOT NULL, -- e.g., "Chapter 5 Fractions Test"
	grade_raw           VARCHAR(50), -- e.g., "A", "88/100"
    grade_decimal       DECIMAL(5,4), -- Standardized grade out of 1.0 (e.g., 0.8800)
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Constraints
    -- FOREIGN KEY (student_id) REFERENCES students(student_id),

    KEY idx_grade_kid_date (student_id, work_date),
    KEY idx_grade_subject (subject)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    


DROP TABLE IF EXISTS math_problem_catalog; 

CREATE TABLE IF NOT EXISTS math_problem_catalog (
    -- 1. IDENTIFIER & TAGS (No Change)
    problem_id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    main_topic          VARCHAR(100) NOT NULL,
    sub_topic           VARCHAR(100),
    grade_level         INT,
    difficulty_level    TINYINT UNSIGNED,
    question_text       TEXT NOT NULL,
    given_expression    VARCHAR(500),
    
    -- 2. ANSWER FIELDS (CRUCIAL REVISIONS)
    -- This stores the AI's full, structured, stepped solution for diagnosis.
    model_solution 		TEXT,  -- set to not null in the future
    
    -- 3. SOURCE & METADATA (No Change)
    source              ENUM('SCHOOLWORK', 'STUDY_MATERIAL', 'AI_GENERATED') NOT NULL,
    schoolwork_id       BIGINT UNSIGNED NULL,
    date_added          DATE,
    
    -- Constraints
    -- FOREIGN KEY (schoolwork_id) REFERENCES schoolwork(schoolwork_id) ON DELETE SET NULL,
    KEY idx_topic_difficulty (main_topic, sub_topic, difficulty_level),
    KEY idx_grade_level (grade_level)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;