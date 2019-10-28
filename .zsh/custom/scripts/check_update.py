#!/usr/bin/env python
import pathlib
import re
from datetime import datetime, timezone

LOG_PATH = pathlib.Path("/var/log/pacman.log")

def get_log():
    with LOG_PATH.open() as fp:
        log_text = fp.read()

    return log_text

def parse_pacman_line(line):
    if len(line) == 0:
        return None

    parsed_line = re.search('^\[([^]]*)\] \[([^]]*)\] (.*)$', line)
    if parsed_line is None:
        return None

    date_str, pacman_indicator, message = parsed_line.groups()

    if pacman_indicator != "PACMAN":
        return None

    try:
        parsed_date = datetime.strptime(date_str, "%Y-%m-%dT%H:%M:%S%z")
    except:
        return None
    return {
        "date": parsed_date,
        "message": message
    }

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
    now = datetime.now(timezone.utc)
    diff = now - t

    return diff.days > 0

if __name__ == "__main__":
    print ( get_diffs ( get_last_system_upgrade ( get_log() ) ) )
