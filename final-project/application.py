import os

from flask import Flask, redirect, render_template

from helpers import get_data, random_class, random_code

app = Flask(__name__)

app.config["TEMPLATES_AUTO_RELOAD"] = True

data = get_data('data.json')

@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route('/')
def index():
    """ Show status-code per responses class """

    return render_template('index.html', data = data)


@app.route('/status', strict_slashes=False)
def status():
    """ Redirect to a random status-code page """

    # Get random status-code
    code = random_code(random_class(data), data)

    # Redirect to random status-code page
    return redirect('/status/{}'.format(code))


@app.route('/status/<code>', strict_slashes=False)
def status_code(code):
    """ Show status-code information """

    i = code

    for k, v in data.items():
        if i in v['status']:
            code = v['status'][i]
            code.update({ 'code': i })
            code.update({ 'classname': k})
            code.update({ 'class_definition': v['definition']})

            return render_template('status-code.html', code = code)

    return render_template('apology.html')

if __name__ == '__main__':
    app.run()
