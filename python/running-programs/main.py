import os
from datetime import datetime
from typing import Dict, List

import psutil
import slack


def running_processes() -> Dict[int, List[str]]:
    processes: Dict[int, List[str]] = dict()

    for process in psutil.process_iter(['pid', 'cmdline']):
        processes[process.info['pid']] = process.info['cmdline']

    return processes


def format_processes(processes: Dict[int, List[str]]) -> List[str]:
    lines = list()
    for pid, cmd in processes.items():
        lines.append("{}\t{}\n".format(pid, cmd))

    return lines


def persist_processes(processes: List[str]) -> str:
    filename = "{}.txt".format(datetime.today())

    with open(file=filename, mode="a+") as file:
        file.writelines(processes)
        file.close()

    return filename


def send_to_slack(processes: str):
    client = slack.WebClient(token=os.environ["SLACK_API_TOKEN"])
    client.files_upload(channels=os.environ["SLACK_CHANNEL"], file=processes)


if __name__ == "__main__":
    send_to_slack(persist_processes(format_processes(running_processes())))
