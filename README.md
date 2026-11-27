# carboncopy

this is my dotfiles repo for all my device(s)

hosts:
- gallium, x1 carbon gen 6 
- bismuth, legion 5

## stow-ing guide
1. cd to hosts/ or common/ first 
2. for scripts
```bash 
stow --dotfiles -t ~ --no-folding scripts
```
3. anything else
```bash 
stow --dotfiles -t ~ mycoolapp
```

