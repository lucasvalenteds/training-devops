import subprocess
from main import format_processes, persist_processes


def test_format_concat_pid_and_cmd():
    processes = dict()
    processes[123] = ["ps", "aux"]
    processes[1020] = ["ls"]

    lines = format_processes(processes)

    assert lines[0] == "123\t['ps', 'aux']\n"
    assert lines[1] == "1020\t['ls']\n"


def test_persist_creates_text_file():
    processes = list()
    processes.append("8888\t['echo', 'foo', '>>', 'log.dat']\n")

    filename = persist_processes(processes)

    assert filename.endswith(".txt")
    assert open(filename, "r").readlines() == processes

    subprocess.run(["rm", filename])
