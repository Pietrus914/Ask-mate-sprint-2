--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

ALTER TABLE IF EXISTS ONLY public.question DROP CONSTRAINT IF EXISTS pk_question_id CASCADE;
ALTER TABLE IF EXISTS ONLY public.answer DROP CONSTRAINT IF EXISTS pk_answer_id CASCADE;
ALTER TABLE IF EXISTS ONLY public.answer DROP CONSTRAINT IF EXISTS fk_question_id CASCADE;
ALTER TABLE IF EXISTS ONLY public.comment DROP CONSTRAINT IF EXISTS pk_comment_id CASCADE;
ALTER TABLE IF EXISTS ONLY public.comment DROP CONSTRAINT IF EXISTS fk_question_id CASCADE;
ALTER TABLE IF EXISTS ONLY public.comment DROP CONSTRAINT IF EXISTS fk_answer_id CASCADE;
ALTER TABLE IF EXISTS ONLY public.question_tag DROP CONSTRAINT IF EXISTS pk_question_tag_id CASCADE;
ALTER TABLE IF EXISTS ONLY public.question_tag DROP CONSTRAINT IF EXISTS fk_question_id CASCADE;
ALTER TABLE IF EXISTS ONLY public.tag DROP CONSTRAINT IF EXISTS pk_tag_id CASCADE;
ALTER TABLE IF EXISTS ONLY public.question_tag DROP CONSTRAINT IF EXISTS fk_tag_id CASCADE;

DROP TABLE IF EXISTS public.question;
CREATE TABLE question (
    id serial NOT NULL,
    submission_time timestamp without time zone,
    view_number integer,
    vote_number integer,
    title text,
    message text,
    image text
);

DROP TABLE IF EXISTS public.answer;
CREATE TABLE answer (
    id serial NOT NULL,
    submission_time timestamp without time zone,
    vote_number integer,
    question_id integer,
    message text,
    image text
);

DROP TABLE IF EXISTS public.comment;
CREATE TABLE comment (
    id serial NOT NULL,
    question_id integer,
    answer_id integer,
    message text,
    submission_time timestamp without time zone,
    edited_count integer
);


DROP TABLE IF EXISTS public.question_tag;
CREATE TABLE question_tag (
    question_id integer NOT NULL,
    tag_id integer NOT NULL
);

DROP TABLE IF EXISTS public.tag;
CREATE TABLE tag (
    id serial NOT NULL,
    name text
);


ALTER TABLE ONLY answer
    ADD CONSTRAINT pk_answer_id PRIMARY KEY (id);

ALTER TABLE ONLY comment
    ADD CONSTRAINT pk_comment_id PRIMARY KEY (id);

ALTER TABLE ONLY question
    ADD CONSTRAINT pk_question_id PRIMARY KEY (id);

ALTER TABLE ONLY question_tag
    ADD CONSTRAINT pk_question_tag_id PRIMARY KEY (question_id, tag_id);

ALTER TABLE ONLY tag
    ADD CONSTRAINT pk_tag_id PRIMARY KEY (id);

ALTER TABLE ONLY comment
    ADD CONSTRAINT fk_answer_id FOREIGN KEY (answer_id) REFERENCES answer(id);

ALTER TABLE ONLY answer
    ADD CONSTRAINT fk_question_id FOREIGN KEY (question_id) REFERENCES question(id);

ALTER TABLE ONLY question_tag
    ADD CONSTRAINT fk_question_id FOREIGN KEY (question_id) REFERENCES question(id);

ALTER TABLE ONLY comment
    ADD CONSTRAINT fk_question_id FOREIGN KEY (question_id) REFERENCES question(id);

ALTER TABLE ONLY question_tag
    ADD CONSTRAINT fk_tag_id FOREIGN KEY (tag_id) REFERENCES tag(id);

INSERT INTO question VALUES (0, '2017-04-28 08:29:00', 29, 7, 'How to make lists in Python?', 'I am totally new to this, any hints?', 'uploads/translate.png');
INSERT INTO question VALUES (1, '2017-04-29 09:19:00', 15, 9, 'Wordpress loading multiple jQuery Versions', 'I developed a plugin that uses the jquery booklet plugin (http://builtbywill.com/booklet/#/) this plugin binds a function to $ so I cann call $(".myBook").booklet();

I could easy managing the loading order with wp_enqueue_script so first I load jquery then I load booklet so everything is fine.

BUT in my theme i also using jquery via webpack so the loading order is now following:

jquery
booklet
app.js (bundled file with webpack, including jquery)', 'uploads/images1.jpg');
INSERT INTO question VALUES (2, '2017-05-01 10:41:00', 1364, 57, 'Drawing canvas with an image picked with Cordova Camera Plugin', 'I''m getting an image from device and drawing a canvas with filters using Pixi JS. It works all well using computer to get an image. But when I''m on IOS, it throws errors such as cross origin issue, or that I''m trying to use an unknown format.
', NULL);
INSERT INTO question VALUES (3, '2017-09-01 12:49:00', 553, 98, 'Best way to do baked potatoes?', 'I''m going to do up 2 racks of ribs and to simplify cooking i was thinking of doing some baked potatoes. Is there a good easy way to make them on the smoker over the last 2 hours the ribs are cooking? If not i can dice up potatoes in the oven, it''d just be nice to not have to run back and forth.', NULL);
INSERT INTO question VALUES (4, '2017-10-01 12:12:00', 553, 98, 'Helpful tips to better sleep with babies', 'Hi mummies

I have read different theories on how to put babies to sleep, some advise not to rock, just put on cot, some said can rock...

I am now trying to put my girl (11 Month) to sleep by going thru bedtime ritual which include bath, milk, book...then I would put her in her cot awake and sit by the cot. She would get up and stand in the cot, then I put her down and we would "wrestle" like that for 45 mins, 30 mins, 20 mins etc.. (wow, tiring!)...the few nights she would then finally remain in bed and doze off...so my question is am I doing the right thing? Will I make my baby detest sleeping?

At this point I am very sure I cannot just put her down and walk out of the room, she would definitely cry...

So any mummies have same experience? Pls advise.

Thanks.', 'uploads/birds_rainbow-lorakeets.png');


SELECT pg_catalog.setval('question_id_seq', 2, true);

INSERT INTO answer VALUES (1, '2017-04-28 16:49:00', 4, 1, 'You need to use brackets: my_list = []', 'uploads/bananas.jpg');
INSERT INTO answer VALUES (2, '2017-04-25 14:42:00', 35, 1, 'Look it up in the Python docs', 'uploads/strawberries.jpg');
INSERT INTO answer VALUES (3, '2017-09-01 14:42:00', 1, 3, 'you could start them in the micro wave for 5 or ten minutes then just through them in the smoker to finish, you could wrap them foil if you don''t want the smoke on them, but I don''t know why you wouldn''t good luck', 'https://www.kasandbox.org/programming-images/landscapes/mountain_matterhorn.png');
INSERT INTO answer VALUES (4, '2017-09-01 20:24:00', 2, 3, 'Rub them down with butter, salt/pepper them, wrap them completely in foil and throw them on the smoker. You''re probably looking at 4 hours of cook time at 250 degree smoker temp.', NULL);
INSERT INTO answer VALUES (5, '2017-10-01 20:24:00', 5, 4, 'Hey, i have the same problem as you. I will put my son and wrestle with him on our bed when i know it is nearly his time to sleep like bout 9plus. And because he always sleep on our bed, he knows when i lift him up to put him in his cot and he cries and so end up will be back on our bed. I have no ides how to stop this cos i think it has been a habit and i think we will have a problem making him sleep alone next time.', NULL);
INSERT INTO answer VALUES (6, '2017-10-01 20:37:00', 2, 4, 'You have to do it the hard way. My mum is a baby sitter, currently looking after 2 kids. She had looked after more than 5 kids and have 4 kids of her own. You have to break the habit. At their bedtime, put them to bed and leave the room. If they are crying, you have to let them cry. The 1st few days you can walk in and look at them at different intervals but do not carry them. Make the intervals longer and longer. It''s really heart breaking at first. But after sometime, they will realise it''s no use crying, they will fall asleep on their own. Most of the time after 1 week you will see the effect.', NULL);



SELECT pg_catalog.setval('answer_id_seq', 2, true);

INSERT INTO comment VALUES (1, 0, NULL, 'Please clarify the question as it is too vague!', '2017-05-01 05:49:00');
INSERT INTO comment VALUES (2, NULL, 1, 'I think you could use my_list = list() as well.', '2017-05-02 16:55:00');
INSERT INTO comment VALUES (3, NULL, 4, 'If you wrap them in foil, then what''s the point in putting them in the smoker?', '2017-09-02 16:55:00');
INSERT INTO comment VALUES (4, NULL, 6, 'Wow, i really cannot bear to do that. I tried and it is so torturing to see my son really crying and i will quickly carry him in my arms again. Sigh, i know this is bad, but got no choice, heart too soft. I will try see if got other methods not.', '2017-10-02 16:55:00');
INSERT INTO comment VALUES (5, NULL, 6, 'No choice ma. This method is the most effective one I know. Work for all the babies so far. But really heart breaking.', '2017-10-02 18:52:00');


SELECT pg_catalog.setval('comment_id_seq', 2, true);

INSERT INTO tag VALUES (1, 'python');
INSERT INTO tag VALUES (2, 'sql');
INSERT INTO tag VALUES (3, 'css');
SELECT pg_catalog.setval('tag_id_seq', 3, true);

INSERT INTO question_tag VALUES (0, 1);
INSERT INTO question_tag VALUES (1, 3);
INSERT INTO question_tag VALUES (2, 3);
