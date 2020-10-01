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
INSERT INTO question VALUES (3, '2018-04-28 08:29:00', 3, 7, 'How to keep the header static, always on top while scrolling?', 'How would I go about keeping my header from scrolling with the rest of the page? I thought about utilizing frame-sets and iframes, just wondering if there is a easier and more user friendly way, what would be the best-practice for doing this?', 'uploads/kwiatki1.jfif');
INSERT INTO question VALUES (4, '2018-05-29 09:19:00', 5, 19, 'Is there a CSS parent selector?','How do I select the <li> element that is a direct parent of the anchor element?

As an example, my CSS would be something like this:

li < a.active {
    property: value;
}
Obviously there are ways of doing this with JavaScript, but I''m hoping that there is some sort of workaround that exists native to CSS Level 2.

The menu that I am trying to style is being spewed out by a CMS, so I can''t move the active element to the <li> element... (unless I theme the menu creation module which I''d rather not do).

Any ideas?', 'uploads/magnolia.jfif');
INSERT INTO question VALUES (5, '2020-05-01 10:41:00', 14, 57, 'How do I create a folder in a GitHub repository?', 'I want to create a folder in a GitHub repository and want to add files in that folder. How do I achieve this?
', 'uploads/narcyz.jfif');


SELECT pg_catalog.setval('question_id_seq', 5, true);

INSERT INTO answer VALUES (1, '2017-04-28 16:49:00', 4, 1, 'You need to use brackets: my_list = []', 'uploads/bananas.jpg');
INSERT INTO answer VALUES (2, '2017-04-25 14:42:00', 35, 1, 'Look it up in the Python docs', 'uploads/strawberries.jpg');
INSERT INTO answer VALUES (3, '2020-04-28 16:49:00', 4, 3, 'Use position: fixed on the div that contains your header. when #content starts off 100px below #header, but as the user scrolls, #header stays in place. Of course it goes without saying that you''ll want to make sure #header has a background so that its content will actually be visible when the two divs overlap.', 'uploads/niezapominajki.jfif');
INSERT INTO answer VALUES (4, '2020-04-25 14:42:00', 35, 4, 'There is currently no way to select the parent of an element in CSS.

If there was a way to do it, it would be in either of the current CSS selectors specs:

Selectors Level 3 Spec
CSS 2.1 Selectors Spec
That said, the Selectors Level 4 Working Draft includes a :has() pseudo-class that will provide this capability. It will be similar to the jQuery implementation.', 'https://1.bp.blogspot.com/-kGcxwneCgiM/Xseae3AuoYI/AAAAAAAAcHc/nJBKSBJXYKw2ZGGwj46OZ1cTWrXPlCZmwCLcBGAsYHQ/s1600/IMG_3162.jpg');

INSERT INTO answer VALUES (5, '2020-04-15 14:42:00', 35, 5, 'You cannot create an empty folder and then add files to that folder, but rather creation of a folder must happen together with adding of at least a single file. On GitHub you can do it this way:

Go to the folder inside which you want to create another folder
Click on New file
On the text field for the file name, first write the folder name you want to create
Then type /. This creates a folder
You can add more folders similarly
Finally, give the new file a name (for example, .gitkeep which is conventionally used to make Git track otherwise empty folders; it is not a Git feature though)
Finally, click Commit new file');
INSERT INTO answer VALUES (6, '2020-04-15 14:42:00', 5, 5, 'Git doesn''t store empty folders. Just make sure there''s a file in the folder like doc/foo.txt and run git add doc or git add doc/foo.txt, and the folder will be added to your local repository once you''ve committed (and appear on GitHub once you''ve pushed it).');


SELECT pg_catalog.setval('answer_id_seq', 6, true);

INSERT INTO comment VALUES (1, 0, NULL, 'Please clarify the question as it is too vague!', '2017-05-01 05:49:00');
INSERT INTO comment VALUES (2, NULL, 1, 'I think you could use my_list = list() as well.', '2017-05-02 16:55:00');
INSERT INTO comment VALUES (3, 3, NULL,'What do you mean by header? Of a page? Of a table?', '2017-02-01 05:49:00');
INSERT INTO comment VALUES (6, NULL,3,'Do you know of a way to let it scroll until it hits the top and then "position: fixed;"? If your header started below the top?', '2017-06-01 05:49:00');
INSERT INTO comment VALUES (7, NULL,3,'This solution requires defining a hard-coded size. Is there a way doing it without a hard-coded size? Perhaps by defining one div to be below another? Perhaps some relationship between the header and content without hard-coded values?', '2017-08-01 05:49:00');

INSERT INTO comment VALUES (5, 4, NULL,'Per my comment on the accepted answer, it looks like the polyfill may be required even in the near future after all, because the subject indicator may never be implemented by browsers in CSS.', '2017-05-11 05:49:00');
INSERT INTO comment VALUES (8, 4, NULL,'There is no parent selector; just the way there is no previous sibling selector. One good reason for not having these selectors is because the browser has to traverse through all children of an element to determine whether or not a class should be applied. For example, if you wrote:

body:contains-selector(a.active) { background: red; }', '2017-05-11 05:49:00');
INSERT INTO comment VALUES (4, NULL, 4, 'Looks like the subject selector has been revisited, except by using a ! now: The subject of the selector can be explicitly identified by appending an exclamation mark (!) to one of the compound selectors in a selector.', '2017-05-12 16:55:00');


INSERT INTO comment VALUES (9, 5, NULL,'I know this is very old question but still might save time for someone The below link is to an answer mentioning how to create folder on Github website itself.', '2018-02-21 05:49:00');
INSERT INTO comment VALUES (10, NULL,6,'If you set up your repository on github the way the site suggests, it''d be "git push origin master" - origin being the default name for the remote repository and master being the default name of your branch.', '2018-03-01 05:49:00');


SELECT pg_catalog.setval('comment_id_seq', 10, true);

INSERT INTO tag VALUES (1, 'python');
INSERT INTO tag VALUES (2, 'sql');
INSERT INTO tag VALUES (3, 'css');
SELECT pg_catalog.setval('tag_id_seq', 3, true);

INSERT INTO question_tag VALUES (0, 1);
INSERT INTO question_tag VALUES (1, 3);
INSERT INTO question_tag VALUES (2, 3);
