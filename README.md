# supermileage-cloud

Our backend server functionality hosted on Cedarville hardware at supermileage.cedarville.edu. The backend consists of 3 main parts: a MQTT instance, a Next.js deployment, and a proxy.

## Architecture Overview

### Proxy

THe proxy is to manage the redirection of web traffic coming to the web server either to the pits display or to the MQTT server, depending on the URL path. All cloud web traffic for the supermileage team will come through this proxy, providing a single point of entry which is ideal for security considerations.

### MQTT Server

MQTT is our chosen protocol for managing the connection between the cars and the cloud web server. It will contain 2 topics for every car, one for data and one for configuration transmission. The cars will publish to their topics, and the pits display will subscribe to those topics to get live data streams.

### Pits Display

The Next.js instance that contains the Pits Display. This will most likely be the most resource-intensive and unpredictable portion of the deployment, as we will expect to have the general public to be able to connect to this endpoint and view the website.

### Usage
To deploy this server, clone this repository and follow the instructions in Secrets Onboarding. Once onboarding is complete, run `./scripts/run-with-secrets.sh` to start the container and `docker compose down` to shut down the container.
