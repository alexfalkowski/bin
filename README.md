# bin

A place for common executables.

## Rationale

After some considerable amount of time one starts to repeat themselves around projects (maybe it is just me). Rather than keep duplicating the efforts, we should standardize them.

## Directories

We will break these executables into higher level categories. These will be as follows:

| Folder  | Description                                                         |
|---------|---------------------------------------------------------------------|
| Quality | Anything related to style, performance, security, reliability, etc. |
| Build   | Any tool to manage and organize builds.                             |

## Usage

Best to use this repository as a [Submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

### Circle CI

As Circle CI does not seem to support submodules, so we need to do some [work](https://circleci.com/docs/configuration-reference/#checkout).
