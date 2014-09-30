# longjobs: list your long-running jobs

A little something I cooked up for my i3 status bar. At some point I may add notification features using notify-osd.

## General usage

    USAGE:
      longjobs                        # Print a list of running jobs
      longjobs -h                     # Show this message
      longjobs -p name 4567           # Add a pid watch with a name
      longjobs -g nix-build nix       # Add a pgrep watch for 'nix-build' processes
      longjobs -r host prefix         # Add a remote watch
      longjobs -w label command...    # Execute a command, watching with given label
      longjobs -c                     # Clear all watches
      longjobs -o                     # Print with one-line output
      longjobs -a                     # Print raw accumulator output (under the hood stuff)
      longjobs -d 5                   # Run as daemon, refreshing every 5 seconds

    Be sure to have a daemon running to produce the data. The other commands just read
    out the latest finished results. If nobody's cooking, there's nothing to eat.

The normal output is pretty good for general shell usage. The one-line output is good for status bars.

As you can see, longjobs has two styles of watches: pid, and pgrep. A pid watch will look for a process with the given process ID. A pgrep watch will use the 'pgrep' command to count up all the processes that match a pattern (based on process name).

The output tallies up all processes found, and groups them by label. The one-line output omits the '1' for labels where only 1 was found.

## Remote connections

The daemon can watch not only local processes, but other machines as well. It's just a matter of installing longjobs on the other matchine, making sure you can SSH to it without passwords, and customizing the watches on the remote host using normal commands.

This runs certain 'ssh' commands repeatedly. It's fine for local guest VMs, but for truly remote machines, I highly recommend using [multiplexed master connections](http://www.linuxjournal.com/content/speed-multiple-ssh-connections-same-server), so that under the hood, all the new SSH sessions take place over the same long-running TCP connection.

The "prefix" argument allows you to prefix all labels coming from the remote machine, with a single string. For example,

    $ longjobs -r vm1 vm1-

So that when there are labels accumulated on the machine 'vm1', they will show up on my host as:

    $ longjobs
          1 less
          1 vm1-sync_resources

You can easily see that the sync_resources task is running on the 'vm1' host, thanks to the handy prefix.

## tmux integration

Something to be aware of: tmux really does not query external scripts very often. This is configureable, but I figure, just leave it be, enjoy the efficiency, and don't use longjobs for jobs that aren't long.

I prefer to have the output on the right side of my status line. I'm mostly a default guy, so my config looks like this:

    # Set up right side of status bar
    set -g status-right-length 40
    set -g status-right "#[bg=black,fg=red]#(longjobs -o)#[default] \"#22T\" %H:%M %d-%b-%y"

This gives me a little extra room, since I usually use tmux on a screen-wide window anyways, and prints all my `longjobs -o` output on the front of my status-right, in red-on-black text. Everything after that (`\"#22T\" %H:%M %d-%b-%y"`) is the default tmux status-right.

## Using the i3status_prepend script

1. Install longjobs.
2. Make sure that your ~/.i3status.conf has output_format set to "i3bar" in the "general" section.
3. Make sure that your ~/.i3/config has this command for status bar: `status_command i3status | i3status_prepend_longjobs`
4. Restart i3 in place, usually with CTRL-MOD-R, unless you changed the shortcut in your config.

This will prepend your long-running jobs at the start of your i3status bar, in red. This is easy to customize by playing with the i3status_prepend script.
