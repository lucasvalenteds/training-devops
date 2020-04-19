# Linux

## Cron

| Description | Command |
| :--- | :--- |
| Edit Cron jobs list | `crontab -e` |
| Read the jokes | `tail -f ~/jokes.txt` |

# SystemD

| Description | Command |
| :--- | :--- |
| Reload SystemD | `sudo systemctl daemon-reload` |
| Enable timer | `systemctl --user enable joke.timer` |
| Start timer | `systemctl --user start joke.timer` |
| Check timer status | `systemctl --user status joke.timer` |
