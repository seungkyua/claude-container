# Image build

```
nerdctl build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  --build-arg USER_NAME=$(id -un) \
  -t claude-container .
```

# Image run
```
nerdctl run -d --name claude-container \
  -v "$(pwd):/workspace" \
  -v "$HOME/.claude:/home/claude/.claude" \
  claude-container
```


# exec container
```
nerdctl exec -it claude-container bash 2>/dev/null
```

# run claude
```
claude --dangerously-skip-permissions
```