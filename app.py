from flask import Flask, render_template

app = Flask(__name__)
app.config['PREFERRED_URL_SCHEME'] = 'http'

@app.route('/')
def home():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000) 