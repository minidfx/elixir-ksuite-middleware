# KdriveBridge

The goal of this project is to provide access to the content of your files saved in kDrive without the KSuite layer by calling the URL:

```
http://localhost:4000/files/<your-kdrive-file-id>
```

## Configuration

| Environment variables | Description                                                                                                                  |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------|
| KDRIVE_ID             | The identifier of your KDrive.                                                                                               |
| KDRIVE_API_TOKEN      | The API token to use the KDrive API.                                                                                         |
| PHX_HOST              | The host the web server. (default: example.com)                                                                              |
| PORT                  | The port for the web server. (default: 4000)                                                                                 |
| SECRET_KEY_BASE       | Secret key used by the [phoenix framework](https://hexdocs.pm/phoenix/deployment.html#handling-of-your-application-secrets). |

```yaml
version: '3'
services:
  kdrive-bridge:
    image: minidfx/kdrive-bridge:v0.3.0
    environment:
      - SECRET_KEY_BASE=<secret>
      - PHX_HOST=<host>
      - PORT=<port>
      - KDRIVE_ID=<id>
      - KDRIVE_API_TOKEN=<token>
    ports:
      - 4000:4000
```

## Running with Docker (recommended way)

With Docker, running the application is a breeze. Simply update the environment variables SECRET_KEY_BASE, PHX_HOST, KDRIVE_ID, and KDRIVE_API_TOKEN. Then, run it to kickstart the application.

```bash
docker-compose up
```

## Security considerations

This application doesn't offer any security layers or authentication. I suggest using a [proxy](https://docs.linuxserver.io/general/swag/) for TLS termination and authentication in front of the container. Make sure to protect this resource by yourself.