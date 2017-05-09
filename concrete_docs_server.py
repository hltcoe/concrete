#!/usr/bin/env python

"""Webserver that serves static files in 'docs/schema/' directory"""

import argparse
import os

from bottle import route, run, static_file


def main():
    parser = argparse.ArgumentParser(description='Provide an easy-to-read API to Concrete')
    parser.add_argument('--port', '-p', dest='port', action='store',
                        default = 8097, type=int,
                        help = 'Port on which to run server')
    parser.add_argument('--host', dest='host', action='store',
                        default = 'localhost', type=str,
                        help = 'Host on which to listen on')
    args = parser.parse_args()

    run(host=args.host, port=args.port)


@route('/')
def index():
    return static_file('index.html', root=os.path.join(os.path.dirname(os.path.abspath(__file__)), "docs/schema"))

@route('<filepath:path>')
def default_route(filepath):
    return static_file(filepath, root=os.path.join(os.path.dirname(os.path.abspath(__file__)), "docs/schema"))


if __name__ == "__main__":
    main()
