#!/usr/bin/env bash

0 */2 * * * curl -sS -H "Accept: text/plain" https://icanhazdadjoke.com/ >> jokes.txt && echo >> jokes.txt
