# DataJoint Development Python Docker Image with Dependencies and Tools


## Tree

```bash
├── config --> Common configuration between all images
│   └── jupyter_notebook_config.py --> Jupyter Notebook server config
├── dist --> Available image distributions
│   ├── alpine 
|   │   ├── .env --> Uncommitted environment file
|   │   ├── docker-compose.yml --> Reference compose for build and run
|   │   ├── Dockerfile --> Image build instructions
|   │   └── entrypoint.sh --> Startup script
│   └── ubuntu
|       ├── .dockerignore --> Files to disregard from build context
|       ├── .env --> Uncommitted environment file
|       ├── docker-compose.yml --> Reference compose for build and run
|       ├── Dockerfile --> Image build instructions
|       ├── entrypoint.sh --> Startup script
|       ├── requirements_post.txt --> Custom dependencies to be pre-installed
|       └── requirements.txt --> Custom dependencies to be pre-installed
├── utility --> Common utilities between all images
│   └── startup.go --> Utility that updates permissions as an underprivileged user
├── .gitignore --> Uncommited files
├── .travis.yml --> Travis CI testing instructions
└── README.md --> Repo documentation
```

## Use



## Building


## Features