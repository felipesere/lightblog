---
title: When In Rome...
date: 2014-08-11
slug: when-in-rome
---
...do as the romans. This post does not have a technical or design epiphany. Heck, most readers might glance over it and think to themselves "Been there, done that" and just skip to another blog.

For a change, this post is really just for me. I paired with Skim today on a real project and in about 20min I dropped into desperation mode. Design terms where flying, tests where failing, panes where being open-closed-reopend, split and collapsed. And then it was my turn. Thankfully, Skim was very patient and showed me some of his keystrokes and let me err-and-retry often enough to let them sink in.

This post is meant as a reminder for those keystrokes and settings, as I want to learned them and turn them into my MO - *Modus Operandi*

<!-- more -->

# Basic vim usage

Here is a list of thing I want to internalise about using vim:

1.  use `CTRL [` as a replacement for `jj`. It standard vim and will work anywhere.
2.  quickly create new panes using `CTRL-W s` (horizontal) and `CTRL-W v` (vertical)
    Creating splits should happen every time you want to see distant lines, even in the same file!
3.  use `CTRL-W w` to switch to the next pane. Or `CTRL-W <hjkl>` to navigate relatively
4.  Install CommandT rather than CtrlP. Its fuzzy match capability is powerful.
5.  Keep a NERDtree open constantly and use it to create files in-place

# Use Tmux more extensively

Skim has a very neat tmux setup in the virtual machine he uses for his project. Though I like the tmux'ing, I guess my current MacBook would not be fun to use with a couple of VMs running. Here is what I'm thinking of doing (and explaining in a follow-up post):

*   create a session per project
    *   the session would never be closed, only detached and re-attached
*   create a command to quickly re-attach to a session
    *   this eliminates the need to `cd` into a specific folder
    *   multiple tabs in that session provide access to different aspects of that projects
    *   work, commit, test, README, deployment, staging logs...
*   using tmux this way might eliminate the use of running tests in a pipe, as I have limited screen space anyway
*   use the following shortcuts
    *   `CTRL-A [` to initiate scrolling, `q` to exit scrolling
    *   `CTRL-A <jk`> for line scrolling
    *   `CTRL-A U` for page-Up and `CTRL-A D` for page-Down scrolling

# Doing zsh the vim way

Not exactly. The shell apparently inherited more from Emacs than from vim. But a simple trick remains: avoid the arrow keys. Though I was skeptic, it is doable.

*   `CTRL-P` goes to the Previous command, `CTRL-N` goes to the Next command
*   `CTRL-R` <word> searches your command history backwards, keep hitting `CTRL-R` until you find what you need
*   `CTRL-B` to go Back a single char, `CTRL-F` to go Forward a single char
*   `META-B` / `META-F` to go Back and Forward entire words
*   `META-D` will delete the next word right of the cursor

    If you are using Iterm2 you might want to have left alt mapped over to meta.

That is pretty much it. All of the above was what I picked up from a single pairing session. Now I'll jump onto a kata or two to internalise those thing hopefully still remember them by tomorrow.

