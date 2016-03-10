#!/bin/bash

# run the given command in the background, ignoring output

"${@:1}" >/dev/null 2>&1 &

