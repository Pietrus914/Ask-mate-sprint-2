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
                ORDER BY submission_time
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
        """
    cursor.execute(query)
    return cursor.fetchall()


@database_common.connection_handler
def add_question(cursor: RealDictCursor, new_question: dict) -> dict:
    query = f"""
        INSERT INTO question (title, message, image, submission_time)
        VALUES ('{new_question['title']}', '{new_question['message']}', '{new_question['image']}', '{new_question['submission_time']}')
        RETURNING id
        """
    cursor.execute(query)
    return cursor.fetchone()

@database_common.connection_handler
def update_question(cursor: RealDictCursor, edited_question: dict):
    query = f"""
        UPDATE question 
        SET title = '{edited_question['title']}', message = '{edited_question['message']}', image = '{edited_question['image']}'
        WHERE id = {edited_question['id']}
        """
    cursor.execute(query)


@database_common.connection_handler
def views_updated(cursor: RealDictCursor, question_id):
    query= f"""
        UPDATE question
        SET view_number = view_number + 1
        WHERE id = {question_id}"""
    cursor.execute(query)
    return



#
# @database_common.connection_handler
# def get_question_id(cursor: RealDictCursor) -> list:
#     query = f"""
#         SELECT MAX(id)
#         FROM question
#         """
#     cursor.execute(query)
#     return cursor.fetchone().values()
