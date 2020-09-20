from typing import List, Dict

from psycopg2 import sql
from psycopg2.extras import RealDictCursor

import database_common

''' this is only an example!'''
# @database_common.connection_handler
# def get_mentors(cursor: RealDictCursor) -> list:
#     query = """
#         SELECT first_name, last_name, city
#         FROM mentor
#         ORDER BY first_name"""
#     cursor.execute(query)
#     return cursor.fetchall()

