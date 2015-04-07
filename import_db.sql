CREATE TABLE users
(
  -- column_name1 data_type(size),
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);


CREATE TABLE questions
(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  user_id INTEGER NOT NULL
);

CREATE TABLE question_follows
(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL
);

CREATE TABLE replies
(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT
);

CREATE TABLE question_likes
(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL
);

--
-- INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
-- VALUES ('Cardinal','Tom B. Erichsen','Skagen 21','Stavanger','4006','Norway');

INSERT INTO
  users(fname, lname)
VALUES
  ('Konrad', 'Dudziak'),
  ('Liann', 'Sun'),
  ('Jamil', 'Okefor'),
  ('Your', 'Mom');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('First Question', 'What do I do?', (SELECT id FROM users WHERE fname = 'Konrad' AND lname = 'Dudziak')),
  ('Second Question', 'What am I eating for dinner?', (SELECT id FROM users WHERE fname = 'Liann')),
  ('Third Question', 'Wheres the ball?', (SELECT id FROM users WHERE fname = 'Jamil')),
  ('Fourth Question', 'That was a foul?!?', (SELECT id FROM users WHERE fname = 'Konrad'));

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'First Question'), (SELECT id FROM users WHERE fname = 'Liann')),
  ((SELECT id FROM questions WHERE title = 'First Question'), (SELECT id FROM users WHERE fname = 'Your')),
  ((SELECT id FROM questions WHERE title = 'Fourth Question'), (SELECT id FROM users WHERE fname = 'Jamil')),
  ((SELECT id FROM questions WHERE title = 'Second Question'), (SELECT id FROM users WHERE fname = 'Jamil'));

INSERT INTO
  replies(
    question_id, reply_id, user_id, body
  )
VALUES
  ((SELECT id FROM questions WHERE title = 'First Question'), NULL, (SELECT id FROM users WHERE fname = 'Liann'), 'Eat!'),
  ((SELECT id FROM questions WHERE title = 'Fourth Question'), NULL, (SELECT id FROM users WHERE fname = 'Liann'), 'NO.'),
  ((SELECT id FROM questions WHERE title = 'Second Question'), NULL, (SELECT id FROM users WHERE fname = 'Konrad'), 'RIBS!'),
  ((SELECT id FROM questions WHERE title = 'Second Question'), NULL, (SELECT id FROM users WHERE fname = 'Your'), 'Some Veggies dear');

INSERT INTO
  replies(
    question_id, reply_id, user_id, body
  )
VALUES
  ((SELECT id FROM questions WHERE title = 'Fourth Question'), (SELECT id FROM replies WHERE body = 'NO.'), (SELECT id FROM users WHERE fname = 'Jamil'), 'Yea it was!');


  INSERT INTO
    question_likes(user_id, question_id)
  VALUES
    ((SELECT id FROM users WHERE fname = 'Your'), (SELECT id FROM questions WHERE title = 'Second Question')),
    ((SELECT id FROM users WHERE fname = 'Konrad'), (SELECT id FROM questions WHERE title = 'Second Question'));
