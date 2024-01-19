# Project Setup

No matter what network you are using, the project structure will be the similar: every Move package has a `Move.toml` file that describes the package and its dependencies, and the `sources` folder that contains the source code of the package.

## Initialize the project

> Please refer to [the previous section](./install-sui.md) to learn how to install the CLI for the network you are building on.

To initialize a new project, run the following command:

```bash
$ sui move new my_project
$ cd my_project
```

## Project structure

The resulting folder structure will look like this:

```bash
sources/   # contains the source code of the project
Move.toml  # package manifest
```

The `sources` folder should contain the source code of the project. The `Move.toml` file is a manifest file that describes the project and its dependencies.

## Building a project

To build a project, run the following command:

```bash
$ move build # or `sui move build`
```

## Build directory

The artifacts of the build process are stored in the `build` directory. If you're using a version control system, you should add this directory to the ignore list.

```bash
# .gitignore
build/
```
