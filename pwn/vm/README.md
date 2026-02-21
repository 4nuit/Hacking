## Doc

## Userspace

- https://docs.kernel.org/userspace-api/landlock.html
- https://popovicu.com/posts/linux-vm-without-vm-software-user-mode

## Browser Exploit

- https://github.com/danbev/learning-v8
- https://github.com/two-heart/v8-design-docs
- https://www.offensiveweb.com/docs/others/browser-exploit/
- https://gist.github.com/jcreedcmu/4f6e6d4a649405a9c86bb076905696af
- https://medium.com/swlh/my-take-on-chrome-sandbox-escape-exploit-chain-dbf5a616eec5
- https://medium.com/@INTfinitySG/miscellaneous-series-2-a-script-kiddie-diary-in-v8-exploit-research-part-1-5b0bab211f5a

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
