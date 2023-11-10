# KdriveBridge

The goal of this project is to provide access to the content of your files saved in kDrive. This application doesn't offer any security layers or authentication. I suggest using a [proxy](https://docs.linuxserver.io/general/swag/) for TLS termination and authentication in front of the project.

## Installation

With Docker, running the application is a breeze. Simply update the environment variables SECRET_KEY_BASE, PHX_HOST, KDRIVE_ID, and KDRIVE_API_TOKEN. Then, execute the following command to kickstart the application.

```bash
docker-compose up
```