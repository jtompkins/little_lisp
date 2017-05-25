# little_lisp

A Ruby implementation of Mary Rose Cook's [Little Lisp](https://maryrosecook.com/blog/post/little-lisp-interpreter).

## Installation

```
gem install little_lisp
```

## Usage

```
little_lisp -s {source_file}
```

### Running from source

```
ruby -Ilib ./bin/little_lisp -s ./samples/hello_world.ll
```

## Running Tests

```
bundle exec rake
```
