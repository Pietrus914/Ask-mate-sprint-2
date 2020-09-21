from datetime import datetime as dt


'''function that returns current data & time'''
def get_current_date_time():
    return dt.now().strftime("%Y-%m-%d %H:%M:%S")