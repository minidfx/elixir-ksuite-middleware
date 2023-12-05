# Ksuite-middleware

Project providing a single endpoint with a single API configuration to access to many resources from a KSuite environment.

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
    image: minidfx/ksuite-middleware:v0.5.0
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

## Running with Docker (recommended way)

With Docker, running the application is a breeze. Simply update the environment variables SECRET_KEY_BASE, PHX_HOST, KDRIVE_ID, and KSUITE_API_TOKEN. Then, run it to kickstart the application.

```bash
docker-compose up
```

## Security considerations

This application doesn't offer any security layers or authentication. I suggest using a [proxy](https://docs.linuxserver.io/general/swag/) for TLS termination and authentication in front of the container. Make sure to protect this resource by yourself.