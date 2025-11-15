# Dotfiles: My dotfiles management using a git bare repo

Author: **Josh Madrone**  
Date: **Feb 9, 2025 at 12:21:03 PM**  
UUID: **B32E0D26-A5B1-4A26-A19B-B50E8CDA9994**  
Hashtags: **#dotfiles, #git, #sysadmin, #macos, #linux, #bash, #zsh, #shell, #git-bare**

## Table of Contents<!-- omit from toc -->

- [Background](#background)
- [Starting from scratch](#starting-from-scratch)
- [Installing your dotfiles onto a new system (or migrate to this setup)](#installing-your-dotfiles-onto-a-new-system-or-migrate-to-this-setup)
- [Finishing up](#finishing-up)

## Background

> **ℹ️ Disclaimer**  
> The title is slightly hyperbolic, there are other proven solutions to the problem. I do think the technique below is very elegant though.

Recently I read about this amazing technique in an ~[Hacker News thread](https://news.ycombinator.com/item?id=11070797)~ on people's solutions to store their ~[dotfiles](https://en.wikipedia.org/wiki/Dot-file)~. User StreakyCobra ~[showed his elegant setup](https://news.ycombinator.com/item?id=11071754)~ and ... It made so much sense! I am in the process of switching my own system to the same technique. The only pre-requisite is to install ~[Git](https://www.atlassian.com/git)~.

In his words the technique below requires:

> _"No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate you configuration easily on new installation"_.

The technique consists in storing a ~[Git bare repository](http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/)~ in a "side" folder (like `$HOME/.dotfiles`) using a specially crafted alias so that commands are run against that repository and not the usual `.git` local folder, which would interfere with any other Git repositories around.

## Starting from scratch

If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:

```sh
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
dotfiles add origin git@github.com:jmadrone/dotfiles.git
```

- The first line creates a folder `~/.dotfiles` which is a ~[Git bare repository](http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/)~ that will track our files.
- Then we create an alias `dotfiles` which we will use instead of the regular `git` when we want to interact with our configuration repository.
- We set a flag `-- local` to the repository - to hide files we are not explicitly tracking yet. This is so that when you type config status and other commands later, files you are not interested in tracking will not show up as untracked.
- Also you can add the alias definition by hand to your .bashrc or use the the fourth line provided for convenience.

I packaged the above lines into a ~[Gist](https://gist.githubusercontent.com/jmadrone/cd72cfb02e8daf1ec8ceb1f144652372/raw/5c6c79a28c7daa0556f0e145c716cb602cfc280c/dotfiles-init.sh)~ up on GitHub and linked it from a short-url, using [Tinyurl](https://tinyurl.com), using the alias `dotfiles-init`, which makes the shortened URL this: <https://tinyurl.com/dotfiles-init>. So that you can set things up with:

Full length URL version

```sh
curl -Lks https://gist.githubusercontent.com/jmadrone/cd72cfb02e8daf1ec8ceb1f144652372/raw/5c6c79a28c7daa0556f0e145c716cb602cfc280c/dotfiles-init.sh | /bin/bash
```

Shortened URL version

```sh
curl -Lks https://tinyurl.com/dotfiles-init | /bin/bash
```

After you've executed the setup any file within the `$HOME` folder can be versioned with normal commands, replacing `git` with your newly created dotfiles `alias`, like:

```sh
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "Add vimrc"
dotfiles add .bashrc
dotfiles commit -m "Add bashrc"
dotfiles push origin main
```

## Installing your dotfiles onto a new system (or migrate to this setup)

If you already store your configuration/dotfiles in a ~[Git repository](https://github.com/jmadrone/dotfiles.git)~, on a new system you can migrate to this setup with the following steps:

- Prior to the installation make sure you have committed the `alias` to your `.bashrc` or `.zsh`:

  ```sh
  alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  ```

- And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:

  ```sh
  echo ".dotfiles" >> .gitignore
  ```

- Now clone your dotfiles into a ~[bare](http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/)~ repository in a "dot" folder of your $HOME:

  ```sh
  git clone --bare https://github.com/jmadrone/dotfiles.git $HOME/.dotfiles
  ```

- Define the alias in the current shell scope:

  ```sh
  alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  ```

- Checkout the actual content from the bare repository to your $HOME:

  ```sh
  dotfiles checkout
  ```

- The step above might fail with a message like:

  ```sh
  error: The following untracked working tree files would be overwritten by checkout:
     .bashrc
     .gitignore
  Please move or remove them before you can switch branches.

  Aborting
  ```

  This is because your `$HOME` folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:

  ```sh
  mkdir -p .dotfiles-backup && \
  dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
  xargs -I{} mv {} .dotfiles-backup/{}
  ```

- Re-run the check out if you had problems:

  ```sh
  dotfiles checkout
  ```

- Set the flag `showUntrackedFiles to no` on this specific (local) repository:

  ```sh
  dotfiles config --local status.showUntrackedFiles no
  ```

- You're done, from now on you can now type config commands to add and update your dotfiles:

  ```sh
  dotfiles status
  dotfiles add .vimrc
  dotfiles commit -m "Add vimrc"
  dotfiles add .bashrc
  dotfiles commit -m "Add bashrc"
  dotfiles push
  ```

Again as a shortcut not to have to remember all these steps on any new machine you want to setup, you can create a simple script, [store it as GitHub Gist](https://gist.github.com) like I did, [create a short url](https://tinyurl.com) for it and call it like this:

Full URL version

```sh
curl -Lks https://gist.githubusercontent.com/jmadrone/1467743fd50e80ec2f5d1974ad88c904/raw/bbbeaed65204a422c425cd424d110a7936aaad93/dotfiles-install.sh | /bin/bash
```

Shortened URL version (the alias `dotfiles-install` was taken)

```sh
curl -Lks https://tinyurl.com/dotfiles-setup | /bin/bash
```

For completeness this is what I ended up with:

```bash
git clone --bare https://github.com/jmadrone/dotfiles.git $HOME/.dotfiles
function dotfiles (){
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no
```

## Finishing up

Hope you find this useful. I cannot take credit for its creation as many others have come before me, but I have found it very useful in my day to day. Cheers, Josh.
