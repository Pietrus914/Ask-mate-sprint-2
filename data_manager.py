from typing import List, Dict

from psycopg2 import sql
from psycopg2.extras import RealDictCursor
import datetime
import database_common


@database_common.connection_handler
def get_questions(cursor: RealDictCursor, limit: (None, int)) -> list:  # all questions: limit is None
    if limit is None:
        query = f"""
                SELECT *
                FROM question
                """
    else:
        query = f"""
                SELECT *
                FROM question
                ORDER BY submission_time DESC
                LIMIT {limit}
                """
    cursor.execute(query)
    return cursor.fetchall()


@database_common.connection_handler
def get_questions_by_order(cursor: RealDictCursor, order: str, direct: str):
    query = f"""
            SELECT *
            FROM question
            ORDER BY {order} {direct}
            """
    cursor.execute(query)
    return cursor.fetchall()


@database_common.connection_handler
def get_questions_by_phrase(cursor: RealDictCursor, phrase: str) -> list:
    query = f"""
                SELECT *
                FROM question
                WHERE LOWER(title) LIKE LOWER('%{phrase}%') or LOWER(message) LIKE LOWER('%{phrase}%')
                """
    cursor.execute(query)
    return cursor.fetchall()


@database_common.connection_handler
def get_answers_by_phrase(cursor: RealDictCursor, phrase: str) -> list:
    query = f"""
                SELECT *
                FROM answer
                WHERE LOWER(message) LIKE LOWER('%{phrase}%')
                """
    cursor.execute(query)
    return cursor.fetchall()


@database_common.connection_handler
def get_question_by_id(cursor: RealDictCursor, question_id: int) -> list:
    query = f"""
        SELECT *
        FROM question
        WHERE id = {question_id}
        """
    cursor.execute(query)
    return cursor.fetchone()


@database_common.connection_handler
def get_answers_by_question_id(cursor: RealDictCursor, question_id: int) -> list:
    query = f"""
        SELECT *
        FROM answer
        WHERE question_id = {question_id}
        ORDER BY submission_time DESC
        """
    cursor.execute(query)
    return cursor.fetchall()


@database_common.connection_handler
def add_question(cursor: RealDictCursor, new_question: dict) -> dict:
    query = f"""
        INSERT INTO question (title, message, image, submission_time)
        VALUES (%(title)s, %(message)s, %(image)s, %(submission_time)s)
        RETURNING id
        """
    cursor.execute(query, new_question)
    return cursor.fetchone()


@database_common.connection_handler
def update_question(cursor: RealDictCursor, edited_question: dict):
    query = f"""
        UPDATE question 
        SET title = %(title)s, message = %(message)s, image = %(image)s
        WHERE id = %(id)s
        """
    cursor.execute(query, edited_question)


@database_common.connection_handler
def update_question_votes(cursor:RealDictCursor, question_id, difference: int):
    query = f"""
        UPDATE question
        SET vote_number = vote_number + {difference}
        WHERE id = {question_id}"""
    cursor.execute(query)
    return


@database_common.connection_handler
def views_updated(cursor: RealDictCursor, question_id: int):
    query= f"""
        UPDATE question
        SET view_number = view_number + 1
        WHERE id = {question_id}"""
    cursor.execute(query)

    return


@database_common.connection_handler
def delete_answers_for_question(cursor: RealDictCursor, question_id: int):
    query = f"""
        DELETE from answer
        WHERE question_id = {question_id}"""
    cursor.execute(query)
    return

@database_common.connection_handler
def delete_comment_for_question(cursor: RealDictCursor, question_id: int):
    query = f"""
            DELETE from comment
            WHERE question_id = {question_id}"""
    cursor.execute(query)
    return


@database_common.connection_handler
def delete_comment_for_answers_for_question(cursor: RealDictCursor, question_id: int):
    query = f"""
        DELETE from comment
        WHERE answer_id IN (
        SELECT id 
        FROM answer 
        WHERE question_id = {question_id})"""
    cursor.execute(query)
    return


@database_common.connection_handler
def delete_question_from_question_tag(cursor: RealDictCursor, question_id: int):
    query = f"""
            DELETE from question_tag
            WHERE question_id = {question_id}"""
    cursor.execute(query)
    return

@database_common.connection_handler
def has_question_comment(cursor: RealDictCursor, question_id: int):
    query = f"""
        SELECT id
        FROM comment 
        WHERE question_id = {question_id}"""
    cursor.execute(query)
    return cursor.fetchone()



@database_common.connection_handler
def has_answer_comment(cursor: RealDictCursor, answer_id: int):
    query = f"""
        SELECT id
        FROM comment 
        WHERE answer_id = {answer_id}"""
    cursor.execute(query)
    return cursor.fetchone()


@database_common.connection_handler
def delete_comment_for_answer(cursor: RealDictCursor, answer_id: int):
    query = f"""
        DELETE from comment
        WHERE answer_id = {answer_id}"""
    cursor.execute(query)

@database_common.connection_handler
def delete_answer_from_answers(cursor: RealDictCursor, answer_id: int):
    query = f"""
        DELETE from answer
        WHERE id = {answer_id}"""
    cursor.execute(query)

    return


@database_common.connection_handler
def update_answer_votes(cursor: RealDictCursor, answer_id: int, difference: int):
    query = f"""
        UPDATE answer
        SET vote_number = vote_number + {difference}
        WHERE id = {answer_id}"""
    cursor.execute(query)
    return


@database_common.connection_handler
def get_answer_pictures_paths(cursor: RealDictCursor, question_id: int):
    query = f"""
        SELECT image
        FROM answer
        WHERE question_id = {question_id}"""
    cursor.execute(query)
    return cursor.fetchall()


@database_common.connection_handler
def get_answer_id_pictures_paths(cursor: RealDictCursor, answer_id):
    query = f"""
            SELECT image
            FROM answer
            WHERE id = {answer_id}"""
    cursor.execute(query)
    return cursor.fetchall()



@database_common.connection_handler
def get_question_pictures_paths(cursor: RealDictCursor, question_id: int):
    query = f"""
        SELECT image 
        FROM question
        WHERE id = {question_id}"""
    cursor.execute(query)
    return cursor.fetchall()


@database_common.connection_handler
def delete_question(cursor: RealDictCursor, question_id: int):
    query = f"""
            DELETE from question
            WHERE id = {question_id}"""
    cursor.execute(query)
    return


# @database_common.connection_handler
# def delete_question_id_form_question_tag(cursor: RealDictCursor, question_id: int):
#     query = f"""
#             DELETE from question_tag
#             WHERE question_id = {question_id}"""
#     cursor.execute(query)
#     return



#
# @database_common.connection_handler
# def get_question_id(cursor: RealDictCursor) -> list:
#     query = f"""
#         SELECT MAX(id)
#         FROM question
#         """
#     cursor.execute(query)
#     return cursor.fetchone().values()
