dd if=/dev/urandom of=a count=8
dd if=a of=b
cat test0 | runghc Main a b
