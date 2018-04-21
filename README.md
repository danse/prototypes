
### installation

#### progressive prototypes

the `external` directory is ignored in `.gitignore`. this way it's
possible to keep other repositories there, i can run a static web
server in `prototypes` and that will also serve progressive software
in the external repos

#### emacs prototypes

```
;; https://www.emacswiki.org/emacs/LoadPath
(add-to-list 'load-path "~/prototypes/")
```
