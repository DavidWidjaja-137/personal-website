from flask import Flask, render_template, url_for

app = Flask(__name__)

@app.route("/test")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/")
def main_site():

    return render_template('index.html')

@app.route("/blogs/<blogname>")
def blogs(blogname):

    return render_template(f'blogs/{blogname}.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0')
