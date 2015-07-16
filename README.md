# Mio
Mirror IO test tool in Haskell.

# Principle

Mio is a very simple tool that submits the same I/O trace to both $origin and $mirror
(they are allowed to be either block device or file)
and check if $origin and $mirror are the same state consequently.

This tool helps developers in earlier stage and testers to write trivial tests.
Storage softwares is getting complicated so even such simple test tools helps so much.

```
# miocat $tracefile | mio $origin $mirror
# $?
0
```

Mio focuses on reproducibility and debuggableness.
It reports very kindly if it find failure so developer can fix quickly.

# Author
Akira Hayakawa (ruby.wktk@gmail.com)
