# Python

## Projects

| Folder | Description |
| :--- | :--- |
| `env-create-service` | API to set OS environment variables |
| `env-list-service` | API to expose OS environment variables |
| `running-processes` | Send list of OS processes to Slack |

## How to run

| Description | Command |
| :--- | :--- |
| Install dependencies | `make install` |
| Run tests | `make test` |
| Run app | `make run` |

## How to configure

Set environment variables for [Slack API token](https://api.slack.com/custom-integrations/legacy-tokens) and the channel where the file should be sent before run the script.

```
$ export SLACK_API_TOKEN=
$ export SLACK_CHANNEL=
```
