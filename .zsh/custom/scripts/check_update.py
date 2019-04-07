#!/usr/bin/env python
import pathlib
import re
from datetime import datetime

LOG_PATH = pathlib.Path("/var/log/pacman.log")

def get_log():
    with LOG_PATH.open() as fp:
        log_text = fp.read()

    return log_text

def parse_pacman_line(line):
    if len(line) > 0:
        date_str = line[:18]
        pacman_indicator = line[19:27]
        message = line[28:]

        if pacman_indicator == "[PACMAN]":
            parsed_date = datetime.strptime(date_str,
                                            "[%Y-%m-%d %H:%M]")
            return {"date": parsed_date,
                    "message": message}

    return None

def get_last_sync(log_text):
    last_sync = None
    for line in log_text.split("\n"):
        
        parsed_line = parse_pacman_line(line)
        if parsed_line is None:
            continue
        else:
            if parsed_line["message"] == "synchronizing package lists":
                last_sync = parsed_line["date"]

    return last_sync

def get_last_system_upgrade(log_text):
    last_upgrade = None
    for line in log_text.split("\n"):        
        parsed_line = parse_pacman_line(line)
        if parsed_line is None:
            continue
        else:
            if parsed_line["message"] == "starting full system upgrade":
                last_upgrade = parsed_line["date"]

    return last_upgrade

def get_diffs(t):
    now = datetime.now()
    diff = now - t

    if diff.days > 0:
        return True
    return False

if __name__ == "__main__":
    print ( get_diffs ( get_last_system_upgrade ( get_log() ) ) )
