# Ksuite-middleware

Project providing a single endpoint to access to many resources from a KSuite environment. Currently the middleware supports only kDrive files and the calendar events.

![](diagram.png)

## Kdrive

```
http://localhost:4000/files/<your-kdrive-file-id>
```

## Calendar

```
http://localhost:4000/calendars/<calendar_id>?from=<iso8601-datetime>&to=<iso8601-datetime>
```

## Configuration

| Environment variables | Description                                                                                                                      |
|-----------------------|----------------------------------------------------------------------------------------------------------------------------------|
| KDRIVE_ID             | The identifier of your KDrive.                                                                                                   |
| KSUITE_API_TOKEN      | The API token to use the KDrive API.                                                                                             |
| PHX_HOST              | The host the web server. (default: example.com)                                                                                  |
| PORT                  | The port for the web server. (default: 4000)                                                                                     |
| SECRET_KEY_BASE       | The secret key used by the [phoenix framework](https://hexdocs.pm/phoenix/deployment.html#handling-of-your-application-secrets). |
| CALDAV_USERNAME       | The username to connect to the CalDAV server.                                                                                    |
| CALDAV_PASSWORD       | The password to connect to the CalDAV server.                                                                                    |
| CALDAV_SERVER         | The server CalDAV, e.g. https://foo.bar.com, https://foo.bar.com/file.php, https://foo.bar.com/caldav, ...                       |
| TIMEZONE              | The timezone used to determine the right date time when the server calDAV returns a daily event in UTC.                          |

```yaml
version: '3'
services:
  ksuite-middleware:
    image: minidfx/ksuite-middleware:v0.6.0
    environment:
      - SECRET_KEY_BASE=<secret>
      - PHX_HOST=<host>
      - PORT=<port>
      - KDRIVE_ID=<id>
      - KSUITE_API_TOKEN=<token>
      - CALDAV_USERNAME=<username>
      - CALDAV_PASSWORD=<password>
      - CALDAV_SERVER=<server>
      - TIMEZONE=<tz>
    ports:
      - 4000:4000
```

## Installation

### Running with [Docker](https://hub.docker.com/repository/docker/minidfx/ksuite-middleware) (recommended way)

With Docker, running the application is a breeze. Simply update the environment variables SECRET_KEY_BASE, PHX_HOST, KDRIVE_ID, and KSUITE_API_TOKEN. Then, run it to kickstart the application.

```bash
docker-compose up
```

### Clone this project and run it

1. Build it

```bash
export MIX_ENV=prod
mix deps.get && mix deps.compile && mix release
```

2. Set the environment variables

3. Run it!

```bash
_build/prod/rel/ksuite_middleware/bin/ksuite_middleware start
```

## Security considerations

This application doesn't offer any security layers or authentication. Use this middleware behind a proxy like [swag](https://docs.linuxserver.io/general/swag/), [traefik](https://traefik.io/traefik) or any equivalent proxy.