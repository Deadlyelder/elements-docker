# elements-docker

Docker image that runs the elements sidechain in container for easy scaling.

## Requirements

* Docker engine : 18+
* Docker-compose : 3.5+

## Usage

### Build

`docker-compose -p element up -d`

This should build and run the container, will take around 20-30 mins.

### Status check

`docker-compose -p element up ps`

### Stop

`docker-compose -p element rm -f`

## Configuration

The configuration file `elements.conf` contains the parameters for the run. Currently its set to run on the `liquidv1` chain but one can set it for `elementsregtest` to test it locally. The file `elements_example.conf` in the repo provides different conf files from the [tutorial of elements](https://github.com/ElementsProject/elements/blob/master/contrib/assets_tutorial/elements1.conf).

## Scaling

It is possible to spawn multiple nodes easily using the flag `node=n` where `n` is the number of nodes to spawn.

`docker-compose -p element scale node=4`
