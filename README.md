# Easy 0L Miner

This is a simplified setup of a [0L Libra](https://github.com/OLSF/libra) Miner running in a Docker container. 
It's intended to make onboarding and mining as simple as possible, and able to run on any host.

An important thing to understand about the 0L mining process is that you generate proofs which take an amount 
of time to generate. Your proofs are sequential and stored on your hard drive. If you loose your proofs, you 
will have to start from 0 again and won't receive mining rewards(?) for proofs you have already submitted. 
Due to this it's important you don't lose your proofs, so make sure you know where they are when you run the miner.

## Usage

The miner can be configured in two ways. If you are comfortable with your mnemonic being exposed to your docker host, 
you can pass the `MNEM` environment variable and the container will recover your account for you. If you would prefer
to keep your mnemonic secret, you can run the onboarding commands manually and enter your mnemonic into the prompts.

Note that your configuration files and proofs will be stored in a directory mapped to your local filesystem. 
Look out for `./.0L` in the examples below, you can change this or leave it as-is, but make sure you know where it is!

### Generating a wallet

Skip this step if you already have a menmonic you want to use.

Run the following command AND SAVE THE OUTPUT. It will not be stored anywhere yet and you will not be able to recover it without it.

```
docker run -it ghcr.io/tombeynon/easy-0l-miner miner onboard keygen
```

### Running with Docker

Running the miner is a one-liner with the `MNEM` variable. Note the `-v ./.0L` is the directory your config and proofs will be stored in.

```
docker run -v ./.0L:/root/0L -e MNEM="<your mnemonic>" -e NODE_IP=<node IP> -it ghcr.io/tombeynon/easy-0l-miner
```

If your config directory is empty/missing, this process will onboard and generate your first proof before starting the actual miner, which 
can take up to 60 minutes.

#### Onboarding manually with Docker

Skip this if you are happy using the `MNEM` variable.

To onboard manually without the `MNEM` environment variable, run the following commands and enter your mnemonic into the prompt after each step.

```
docker run -v ./.0L:/root/0L -it ghcr.io/tombeynon/easy-0l-miner ol init -u http://<node IP>:8080

docker run -v ./.0L:/root/0L -it ghcr.io/tombeynon/easy-0l-miner onboard user # wait for proof 0 to mine
```

The first step might ask extra questions, they aren't important for a simple miner but can't be avoided. Answers are:

- Enter a (fun) statement to go into your first transaction: **hello world**
- Will you use this host, and this IP address "...", for your node? **yes**
- Will you use the default directory for node data and configs: "/root/.0L/"? **yes**
- (optional) want to link to another tower's last hash? **no**

Note that if you onboard manually, you will have to enter your mnemonic whenever you run the miner (for the time being). 

To start the miner, run the following and enter your mnemonic.

```
docker run -v ./.0L:/root/0L -it ghcr.io/tombeynon/easy-0l-miner 
```

### Running with Docker Compose

Below is a docker-compose using the `MNEM` variable. Create a `docker-compose.yml` file in a directory, 
set the environment variables and run with `docker-compose up`.

```
version: '3.4'

services:
  miner:
    image: ghcr.io/tombeynon/easy-0l-miner:latest
    ulimits:
      nofile: 100000
    environment:
      - NODE_IP=<node IP>
      - MNEM=<your menmonic>
    volumes:
      - ./.0L:/root/.0L
```

#### Onboarding manually with Docker Compose

Skip this if you are happy using the `MNEM` variable.

Remove the environment variables from the docker-compose above and run the following, entering your menemonic after each step.

```
docker-compose run miner ol init -u http://<node IP>:8080
docker-compose run miner onboard user # wait for proof 0 to mine
```

To start the miner, just run the service without any arguments and enter your mnemonic. 
Due to the prompt we can't run it using `docker-compose up`.

```
docker-compose run miner
```

## Configuration options

|Variable|Description|
|--|--|
|NODE_ID|Set to the IP address of the node you want to connect to|
|MNEM|Set to your mnemonic to restore wallet automatically|
|FORCE_INIT|Set to 1 to re-initialize the config directory with NODE_ID|
|FORCE_ONBOARD|Set to 1 to force onboarding with MNEM and mining of Proof 0|

## Disclaimer

This was a learning exercise for me to try out 0L - I don't know what I'm doing. 

Contributions are very welcome! If you have any questions you can find me on the 0L Discord `@tombeynon`.
