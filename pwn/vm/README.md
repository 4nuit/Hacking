## Doc

- https://popovicu.com/posts/linux-vm-without-vm-software-user-mode
- https://gist.github.com/jcreedcmu/4f6e6d4a649405a9c86bb076905696af

```js
VM sandbox  ───────┐
                   │
          (getter) │      ⬇
                   ▼
Host JS ---------- process.mainModule
                         │
                         ├──> "fs" → r/w files
                         ├──> "os" → system info
                         └──> "child_process" → RCE
```
