### Description
Allow dwl to execute commands from autostart array in your config.h file. And when you exit dwl all processes from autostart array will be killed.

Note: Commands from array are executed using execvp(). So if you need to execute shell command you need to prefix it with "sh", "-c" (change sh to any shell you like).

### Download
- [git branch](https://codeberg.org/sevz/dwl/src/branch/autostart)
- [autostart-wlroots-next-f4249db.patch](https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/autostart/autostart-wlroots-next-f4249db.patch)
- [autostart-0.8.patch](https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/autostart/autostart-0.8.patch)

### Authors
- [fauxmight](https://codeberg.org/fauxmight)
- [sevz](https://codeberg.org/sevz)
- [Rayan Nakib](https://nakibrayan2.pages.dev/)
- [NFVblog](https://github.com/nf02)
