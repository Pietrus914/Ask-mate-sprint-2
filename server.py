from flask import Flask, render_template, url_for, redirect, request, send_from_directory
import data_handler, connection, data_manager, util
import os

app = Flask(__name__)
app.config['UPLOAD_PATH'] = 'uploads'
app.config['MAX_CONTENT_LENGTH'] = 1024 * 1024  # maksymalna wielkosc uploadowanego obrazu
headers = ["Title", "Message", "Submission Time", "Views", "Votes"]
story_keys = ["title", "message", "submission_time", "view_number", "vote_number"]

'''function to use when user can upload file'''
def swap_image(uploaded_file):
    if uploaded_file.filename != '':
        uploaded_file.save(os.path.join(app.config['UPLOAD_PATH'], uploaded_file.filename))
        return os.path.join(app.config['UPLOAD_PATH'], uploaded_file.filename) # question['image'] = ...


@app.route("/")
def main_page():
    questions = data_manager.get_questions(5)
    return render_template("index.html", headers=headers, questions=questions, story_keys=story_keys)


@app.route("/list")
def question_page():
    questions = data_manager.get_questions(None)
    if len(request.args) != 0:
        questions = data_manager.get_questions_by_order(request.args.get("order_by"), request.args.get("order_direction"))
    return render_template("question_list.html", headers=headers, questions=questions, story_keys=story_keys)


@app.route("/search")
def display_search_question():
    search_phrase = request.args.get("search")
    questions = data_manager.get_questions_by_phrase(search_phrase)
    return render_template("search_page.html", headers=headers, questions=questions, story_keys=story_keys)


def display_time(s):
    return data_handler.transform_timestamp(s)


app.jinja_env.globals.update(display_time=display_time)


@app.route("/uploads/<filename>")
def get_img(filename):
    return send_from_directory(app.config['UPLOAD_PATH'], filename)


def get_filename(path):
    file_name = os.path.split(path)[1]
    return file_name


app.jinja_env.globals.update(get_filename=get_filename)


@app.route("/question/<question_id>")
def display_question(question_id):
    if request.referrer != request.url:
        data_manager.views_updated(question_id)

    question = data_manager.get_question_by_id(question_id)
    answers = data_manager.get_answers_by_question_id(question_id)

    answers_headers = ["Votes' number", "Answer", "Submission time"]

    # if request.referrer != request.url:
    #     data_handler.views_updated(question_id)
    # question = data_handler.prepare_question_for_display(question_id)
    # answers = data_handler.prepare_answers_for_display(question_id)
    # answers_headers = ["Votes' number", "Answer", "Submission time"]
    # picture = os.path.split(question["image"])[1]

    return render_template("question.html", question=question, answers=answers, answers_headers=answers_headers)


@app.route("/add")
def add_question_get():
    new_question = {
        "id": None,
        "title": "",
        "message": "",
        "image": "",
        "submission_time": None,
        "view_number": 0,
        "vote_number": 0
    }
    return render_template("add_update_question.html", question=new_question)


@app.route("/add/post", methods=["POST"])
def add_question_post():
    new_question = dict(request.form)
    new_question['submission_time'] = util.get_current_date_time()

    uploaded_file = request.files['file']
    new_question['image'] = swap_image(uploaded_file)

    question_id = data_manager.add_question(new_question).get('id')
    return redirect(url_for("display_question", question_id=question_id))


@app.route("/question/<int:question_id>/edit")
def edit_question_get(question_id):
    question = data_manager.get_question_by_id(question_id)
    if question is None:
        return redirect(url_for("display_question", question_id=question_id))
    else:
        return render_template("add_update_question.html", question=question)


@app.route("/question/<int:question_id>/edit/post", methods=["POST"])
def edit_question_post(question_id):
    edited_question = dict(request.form)

    uploaded_file = request.files['file']
    edited_question['image'] = swap_image(uploaded_file)

    data_manager.update_question(edited_question)

    return redirect(url_for("display_question", question_id=question_id))





@app.route("/question/<question_id>/delete")
def delete_question(question_id):

    answer_pictures_paths = data_manager.get_answer_pictures_paths(question_id)
    util.delete_all_images(answer_pictures_paths)

    # for path in answer_pictures_paths:
    #     if path.get("image"):
    #         util.delete_image(path["image"])

    question_pictures_paths = data_manager.get_question_pictures_paths(question_id)
    util.delete_all_images(question_pictures_paths)
    # for path in question_pictures_paths:
    #     if path.get("image"):
    #         util.delete_image(path["image"])

    data_manager.delete_answers_for_question(question_id)
    data_manager.delete_question_id_from_question_tag(question_id)
    data_manager.delete_question(question_id)






    # questions = connection.read_csv("sample_data/question.csv")
    # data_handler.delete_img(question_id)
    #
    # updated_answers = data_handler.delete_all_answers_for_question(question_id)
    # connection.write_csv("sample_data/answer.csv", updated_answers)
    #
    # data_handler.delete_item_from_items(questions, question_id)
    #
    # connection.write_csv("sample_data/question.csv", questions)

    return redirect(url_for("question_page"))


@app.route("/question/<question_id>/new_answer")
def add_answer(question_id):
    question = data_handler.prepare_question_for_display(question_id)
    new_answer = \
        {
            "answer_id": None,
            "submission_time": None,
            "view_number": 0,
            "vote_number": 0,
            "id": None,
            "message": "",
            "image": ""
        }
    return render_template("answer.html", question=question, answer=new_answer)


'''@app.route("/question/<int:question_id>/new_answer/img", methods=["POST"])
def add_img_to_answer(question_id):
    uploaded_file = request.files['file']
    if uploaded_file.filename != '':
        uploaded_file.save(os.path.join(app.config['UPLOAD_PATH'], uploaded_file.filename))

    return redirect(url_for("add_answer", question_id=question_id, uploaded_file=uploaded_file))'''


@app.route("/question/<int:question_id>/new_answer/post", methods=["POST"])
def add_answer_post(question_id):
    answers = connection.read_csv("sample_data/answer.csv")

    new_answer = dict(request.form)
    new_answer["id"] = data_handler.get_new_id(answers)
    new_answer["submission_time"] = data_handler.get_current_timestamp()
    new_answer["vote_number"] = 0
    new_answer["question_id"] = question_id

    uploaded_file = request.files['file']
    if uploaded_file.filename != '':
        uploaded_file.save(os.path.join(app.config['UPLOAD_PATH'], uploaded_file.filename))
        new_answer["image"] = os.path.join(app.config['UPLOAD_PATH'], uploaded_file.filename)

    answers.append(new_answer)
    connection.write_csv("sample_data/answer.csv", answers)

    return redirect(url_for("display_question", question_id=question_id))


@app.route("/question/<question_id>/new-answer", methods=["POST"])
def edit_answer_post(answer_id):
    return redirect(url_for("display_question"))


@app.route("/answer/<question_id>/<answer_id>/delete")
def delete_answer(question_id, answer_id):
    data_manager.delete_answer_from_answers(question_id, answer_id)


    # answers = data_handler.delete_answer_from_answers(question_id, answer_id)
    # connection.write_csv("sample_data/answer.csv", answers)

    return redirect(url_for("display_question", question_id=question_id))


@app.route("/question/<question_id>/vote_up", methods=["POST"])
def question_vote_up(question_id):
    questions = connection.read_csv("sample_data/question.csv")
    questions = data_handler.add_vote_up(questions, question_id)
    connection.write_csv("sample_data/question.csv", questions)

    return redirect(url_for("display_question", question_id=question_id))


@app.route("/question/<question_id>/vote_down", methods=["POST"])
def question_vote_down(question_id):
    questions = connection.read_csv("sample_data/question.csv")
    questions = data_handler.substract_vote(questions, question_id)
    connection.write_csv("sample_data/question.csv", questions)

    return redirect(url_for("display_question", question_id=question_id))


@app.route("/answer/<question_id>/<answer_id>/vote_up", methods=["POST"])
def answer_vote(question_id, answer_id):
    post_result = dict(request.form)["vote_answer"]
    print(post_result)
    difference =  util.get_difference_of_votes(post_result)
    data_manager.update_answer_votes(answer_id, difference)

    #
    # answers = data_handler.get_answers_for_question(connection.read_csv("sample_data/answer.csv"), question_id)
    # answers = data_handler.update_votes(answers, answer_id, post_result)
    #
    # connection.write_csv("sample_data/answer.csv", answers)

    return redirect(url_for("display_question", question_id=question_id))


# @app.route("/answer/<answer_id>/vote_down", methods=["POST"])
# def answer_vote_down(answer_id):
#     return redirect(url_for("display_question"))


if __name__ == "__main__":
    app.run()
