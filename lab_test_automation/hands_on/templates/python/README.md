# Python Template - Test Automation Lab

## Description

This directory represents the standard for a real world project structure.

Make sure you terminal is in the root directory of this project so you see the src/ and test/ directories.

```
.
└── hands_on
    └── templates
        └── python
            ├── src
            └── test
```

## Running with Python

### Requirements

- Python3

Run all tests with the following command:

**Command**

```sh
python3 -m unittest discover
```

## Running with Docker

### Requirements

- Docker

Make sure Docker is running.

```
docker --version
```

Run all tests with the following command:

```
docker build -t my-lift . && docker run --rm -it my-lift -m unittest discover
```
