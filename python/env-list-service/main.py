import json
import os
from flask import Flask

def create_app(name):
    app = Flask(name)

    @app.route("/conf/env", methods=['GET'])
    def show_environment_variables():
        return json.dumps({"variables": dict(os.environ)})

    return app

if __name__ == '__main__':
    create_app(__name__).run(debug=True)
