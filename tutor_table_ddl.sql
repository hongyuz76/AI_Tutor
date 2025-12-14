USE ai_tutor;
-- DROP TABLE IF EXISTS students; 

CREATE TABLE IF NOT EXISTS students (
    student_id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name          VARCHAR(100) NOT NULL,
    last_name 			VARCHAR(100) NOT NULL,
    grade_level     	INT, -- e.g., 1 , 5
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO students (first_name, last_name, grade_level, created_at) VALUES
('Kevin', 'Zhang', 5, '2025-12-13'),
('Ethan', 'Zhang', 1, '2025-12-13');

select * from students

-- DROP TABLE IF EXISTS schoolwork;

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
    
INSERT INTO schoolwork (
    student_id,
    subject,
    work_type,
    work_date,
    work_desc,
    grade_raw,
    grade_decimal,
    created_at
) VALUES (
    1, -- Kevin Zhang's student_id
    'MATH',
    'TEST',
    DATE('2025-11-05'), -- Using today's date (or a specific date if known)
    'Module 1 Test: Ratios and Proportions',
    '23.5/28', -- The final score is not yet known/available
    0.8393, -- The final score is not yet known/available
    NOW()
);

select * from schoolwork

-- DROP TABLE IF EXISTS math_problem_catalog; 

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

INSERT INTO math_problem_catalog (
    main_topic,
    sub_topic,
    grade_level,
    difficulty_level,
    question_text,
    given_expression,
    model_solution,
    source,
    date_added
) VALUES 
-- Problem #1: Vocabulary Matching
(
    'Ratios and Proportions',
    'Vocabulary',
    7,
    3, -- Mid-level difficulty since it involves nuance
    'Match each vocabulary word with its correct definition. (Words: ratio, scale drawing, constant of proportionality, proportional relationship, unit rate)',
    NULL,
    -- The full model solution with correct pairings
    'Model Solution: A. Unit Rate: a rate where the second quantity is one unit. B. Constant of Proportionality (k): the constant unit rate of a relationship, represented by k. C. Ratio: a comparison of two quantities. D. Proportional Relationship: a relationship where the ratio of one quantity to the other is constant.',
    'SCHOOLWORK',
    CURRENT_DATE()
),
-- Problem #2: Luis's Earnings (Interpretation)
(
    'Ratios and Proportions',
    'Proportional Interpretation',
    7,
    2, -- Lower difficulty, as it's direct reading of the graph
    'The graph shows the proportional relationship between the number of hours Luis works, x, and the amount of money he earns in dollars, y. What does the point (2, 18) represent? Explain in complete sentences and include units.',
    '(x, y) = (2, 18)',
    -- Stepped solution includes the interpretation and the constant of proportionality (k)
    'The point (2, 18) means that Luis earned $18 for working 2 hours. This shows the relationship is proportional, and the constant of proportionality (unit rate) is k = y/x = 18/2 = $9 per hour.',
    'SCHOOLWORK',
    CURRENT_DATE()
),
-- Problem #3a: Keshawn's Video Game (Find k)
(
    'Ratios and Proportions',
    'Constant of Proportionality (k)',
    7,
    3, -- Mid-level difficulty, requires calculation from graph
    'The graph shows the number of levels Keshawn already completed, x, and the total points he earned, y. What is the constant of proportionality?',
    'Graph point (1, 25)',
    -- Model solution showing the formula and calculation
    'The constant of proportionality (k) is found using the ratio k = y/x. The graph passes through the point (1, 25). Therefore, k = 25/1 = 25. The constant of proportionality is 25 points per level.',
    'SCHOOLWORK',
    CURRENT_DATE()
),
-- Problem #3b: Keshawn's Video Game (Equation)
(
    'Ratios and Proportions',
    'Proportional Equation',
    7,
    3, -- Mid-level difficulty, requires formula application
    'Which equation models the relationship between x (levels completed) and y (total points earned)?',
    'y = kx',
    'The general equation for a proportional relationship is y = kx. Since the constant of proportionality (k) is 25, the equation is y = 25x.',
    'SCHOOLWORK',
    CURRENT_DATE()
);


-- DROP TABLE IF EXISTS assessment_items; 
CREATE TABLE IF NOT EXISTS assessment_items (
    -- 1. IDENTIFIER & LINKING KEYS
    attempt_id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    
    -- Foreign Keys - Must be NOT NULL to maintain integrity
    student_id             BIGINT UNSIGNED NOT NULL,
    problem_id             BIGINT UNSIGNED NOT NULL,
    
    -- 2. STUDENT SUBMISSION & PERFORMANCE
    submission_time        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Stores the student's raw submission (steps and final answer), transcribed from the image
    student_answer         TEXT,
    
    -- The core grading metric, allowing for partial credit (e.g., 0.8500 for 85%)
    correctness            DECIMAL(5,4) NOT NULL, 
    
    -- 3. AI DIAGNOSIS & TUTORING OUTPUT
    -- Use ENUM or a controlled list for standardized error reporting
    ai_error_category      VARCHAR(200), 
    
    -- The full, detailed, structured output from the Gemini 2.5 Pro diagnosis
    ai_raw_diagnosis_json  JSON, 
    
    -- 4. CONSTRAINTS
    -- FOREIGN KEY (student_id) REFERENCES students(student_id), 
    -- FOREIGN KEY (problem_id) REFERENCES math_problem_catalog(problem_id),

    -- Highly efficient index for looking up a student's history on a specific problem
    KEY idx_student_problem (student_id, problem_id),
    
    -- Index for chronological reporting/progress charts
    KEY idx_student_time (student_id, submission_time)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;