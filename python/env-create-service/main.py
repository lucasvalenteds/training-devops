import json
import os
from flask import Flask

def create_app(name):
    app = Flask(name)

    @app.route("/env/<name>/<value>", methods=['POST'])
    def create_environment_variable(name, value):
        os.environ[name] = value
        return json.dumps({name: value})

    return app

if __name__ == '__main__':
    app = create_app(__name__).run(debug=True)
