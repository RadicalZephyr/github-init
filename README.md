Github-Init
===========

Like git init, but use defaults from github

If you put the script file onto your path somewhere, then you can also
make this a git alias like so:

```
git config --global alias.gh-init '!github-init.sh'
```

Now you can run `git gh-init <name>` and you'll shortly have a new
repository, initialized and cloned from Github.


```
usage: github-init.sh [-higl] repo-name [repo-description]
  -h                      Display this help
  -i                      Initialize repo with a README
  -g <ignore template>    Initialize repo with a gitignore file
  -l <license template>   Initialize repo with a license
```

You can also use `github-delete.sh` to delete repositories from github.

```
usage: github-delete.sh repo-name
```
