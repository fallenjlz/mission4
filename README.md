# README 

## Dockerfile

This Dockerfile creates a custom Docker image for running an Ethereum client using the official Golang Ethereum (geth) implementation. It includes steps for setting up a genesis block, creating Ethereum accounts, and initializing the Ethereum node with the custom genesis block.

## Base Image

- **ethereum/client-go:stable**: The stable version of the official Golang Ethereum client.

## Features

1. **JSON Tools Installation**: Installs `jq`, a lightweight and flexible command-line JSON processor.

2. Genesis Block Configuration

   :

   - `genesis.json` is copied to the image, serving as the configuration for the genesis block.

3. Account Creation and Pre-funding

   :

   - Two new Ethereum accounts are created using the password provided in `ACCOUNT_PASSWORD`.
   - The genesis file is modified to pre-fund these accounts with Ether.

4. Genesis Block Initialization

   :

   - Initializes the Ethereum node with the custom genesis block.
   - Cleans up unnecessary files after initialization.

   

## Docker-compose

This Docker Compose file sets up a private Ethereum network using Geth (Go Ethereum) clients in a proof-of-authority (PoA) configuration. It includes two Ethereum nodes, a bootnode, monitoring services with Prometheus and Grafana, and container resource monitoring with cAdvisor.

## Services

### 1. geth-bootnode

- **Purpose**: Acts as the initial discovery node for other Ethereum nodes.

- Configuration

  :

  - Custom build from `geth-client-poa` image.
  - Node key, network ID, and IP restrictions are set.
  - Does not participate in network discovery (`--nodiscover`).

### 2. geth-node1

- **Purpose**: Serves as the singer node.

- Configuration

  :

  - Connects to the `geth-bootnode`.
  - Performs mining operations.
  - Etherbase and unlock parameters for mining rewards.

### 3. geth-node2

- **Purpose**: Functions as an member node.

- Configuration

  :

  - Connects to both `geth-bootnode` and `geth-node1`.
  - Similar configuration to `geth-node1` but with different account settings.

### 4. cadvisor

- **Purpose**: Monitors container resource usage.

- Configuration

  :

  - Uses the latest `cadvisor` image.
  - Binds to various host directories for monitoring.

### 5. prometheus

- **Purpose**: Provides monitoring and alerting for Ethereum nodes.

- Configuration

  :

  - Custom configuration and rule files.
  - Depends on `cadvisor` for metrics collection.

### 6. grafana

- **Purpose**: Visualizes monitoring data from Prometheus.

- Configuration

  :

  - Data persistence through a bound volume.
  - Depends on `prometheus` for data source.

## Networks

- **priv-eth-net**: A custom bridge network that allows internal communication between services. It uses a specific subnet (`172.16.254.0/28`) for network isolation.

## Usage

1. **Building the Network**:
   - Run `docker-compose up -d` to start all services.
   - The network initializes with the bootnode, followed by the Ethereum nodes.
2. **Accessing Grafana**:
   - Grafana is available at `http://localhost:3000`.
   - Default login credentials are `admin` for both username and password (unless changed).
3. **Viewing Prometheus Metrics**:
   - Prometheus UI can be accessed at `http://localhost:9090`.
4. **Monitoring with cAdvisor**:
   - Access cAdvisor at `http://localhost:8080`.

## Security Notes

- The `ACCOUNT_PASSWORD` in the build argument for `geth-client-poa` should be securely managed.
- Ensure network security, especially when exposing ports.

## Troubleshooting

- Check container logs if any service fails to start.
- Ensure Docker and Docker Compose are correctly installed and updated.