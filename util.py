from datetime import datetime as dt
import os


'''function that returns current data & time'''
def get_current_date_time():
    return dt.now().strftime("%Y-%m-%d %H:%M:%S")


'''furnction that removes file'''
def delete_image(path):
    if os.path.exists(path):
        os.remove(path)
        return
    else:
        return

'''function that removes files '''
def delete_all_images(paths):
    for path in paths:
        if path.get("image"):
            delete_image(path["image"])

'''function that specify how the votes number should change'''
def get_difference_of_votes(post_result):
    if post_result == "vote_up":
        difference = 1
    elif post_result == "vote_down":
        difference = -1

    return difference
