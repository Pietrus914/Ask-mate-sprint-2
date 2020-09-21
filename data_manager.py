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
                LIMIT {limit}
                """
    cursor.execute(query)
    return cursor.fetchall()


print(get_questions(5))


@database_common.connection_handler
def get_question_by_id(cursor: RealDictCursor, question_id: int) -> list:
    query = f"""
        SELECT *
        FROM question
        WHERE id = {question_id}
        """
    cursor.execute(query)
    return cursor.fetchall()


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
def add_question(cursor: RealDictCursor, new_question: tuple):
    query = f"""
        INSERT INTO question (submission_time, title, message, image)  
        VALUES {new_question}
        """
    cursor.execute(query)
    cursor.close()


# SELECT * FROM Table ORDER BY ID DESC LIMIT 1

@database_common.connection_handler
def get_question_id(cursor: RealDictCursor) -> list:
    query = f"""
        SELECT MAX(id)
        FROM question
        """
    cursor.execute(query)
    return cursor.fetchone().values()
