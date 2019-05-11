# bashtap

Simple tests for bash scripts. Uses [Test Anything Protocol](http://testanything.org/)(`TAP`).

## Synopsis

To use the script, download it to a folder and include it in your test script.

`./test.sh`

```sh
#!/usr/bin/env bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${PWD}/bashtap.bash"

plan

# Begin test block

spec "echo outputs arguments"

expect << EOT
echo hello world
EOT

to_output << EOT
hello world
EOT

# End test block

finish
```

```sh
$ ./test.sh
1..1
ok 1 echo hello world
```

## Usage

Include this library in your project, you can use git submodules for that.

```
$ cd my-project
$ mkdir deps
$ git submodule add https://github.com/san650/bashtap deps/bashtap
```

Then include the library in your test script `./test.sh`

```sh
#!/usr/bin/env bash

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${PWD}/deps/bashtap/bashtap.bash"

spec "echo outputs arguments"

expect <<< 'echo hello world'
to_output <<< 'hello world'

finish
```

Make your test file executable and run it

```sh
$ chmod +x test.sh
$ ./test.sh
1..1
ok 1 echo outputs arguments
```

## API

| Function | Arguments | Description |
| -------- | --------- | ----------- |
| `plan`   | None | Prints TAP header |
| `spec`   | $1:String | Defines a new name |
| `expect` | File Descriptor or a heredoc block | Script to execute |
| `to_output` | File Descriptor or a heredoc block | Expected output from the script defined in `expect` |
| `finish` | None | Exit the program with an error code if a test failed |

## License

`bashtap` is licensed under the MIT license.

See [LICENSE](./LICENSE) for the full license text.
