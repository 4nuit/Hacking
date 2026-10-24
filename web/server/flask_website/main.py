from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

@app.route('/test/script.js')
def color():
    return render_template('color.html')

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)
