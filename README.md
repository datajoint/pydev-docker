# DataJoint Development Python Docker Image with Dependencies and Tools


## Tree

``` s
├── config -------------------------- Common configuration between all images
│   └── jupyter_notebook_config.py -- Jupyter Notebook server config
├── dist ---------------------------- Available image distributions
│   ├── alpine 
|   │   ├── .env -------------------- Uncommitted environment file
|   │   ├── docker-compose.yml ------ Reference compose for build/run
|   │   ├── Dockerfile -------------- Image build instructions
|   │   └── entrypoint.sh ----------- Startup script
│   └── ubuntu
|       ├── .dockerignore ----------- Files to disregard from build context
|       ├── .env -------------------- Uncommitted environment file
|       ├── docker-compose.yml ------ Reference compose for build/run
|       ├── Dockerfile -------------- Image build instructions
|       ├── entrypoint.sh ----------- Startup script
|       ├── requirements_post.txt --- Custom dependencies to be pre-installed
|       └── requirements.txt -------- Custom dependencies to be pre-installed
├── utility ------------------------- Common utilities between all images
│   └── startup.go ------------------ Utility that updates permissions as an underprivileged user
├── .gitignore ---------------------- Uncommited files
├── .travis.yml --------------------- Travis CI testing instructions
└── README.md ----------------------- Repo documentation
```

## Use

To utilize the available containers, a `.env` and the appropriate `docker-compose.yml` is all that is needed. An an example, you may specify the `.env` as follows:

Alpine
``` s
ALPINE_VER=3.10
PY_VER=3.6
UID=1000
GID=1000
```

Ubuntu
``` s
UBUNTU_VER=16.04
PY_VER=3
UID=1000
GID=1000
```

You may start the container with the command `docker-compose up`.

## Building

In order to build, the entire repo is required. See the appropriate `docker-compose.yml` and uncomment the build section. You may build with the command `docker-compose build`.


## Features

* Pre-installed DataJoint dependencies
* Default application user `dja` aka DataJoint Admin
* Git
* Jupyter Notebook server
* GUI routing to Docker host e.g. `matplotlib` figures will display on host
* Alpine Image: lightweight image ideal for Production, Scaling, Unit Testing, and Continuous Integation.
* Ubuntu Image: Complete suite of tools for on-going Development and ad hoc Analysis. 

## Note

To chain commands during startup, one may define the `command` section in `docker-compose.yml` as follows:

``` yaml
command: >
  /bin/sh -c
   "
    pip install --user datajoint;
    pip freeze | grep datajoint;
    jupyter notebook;
   "
```