To first get org-mode work, I need to install Emacs first on my Mac system. There're several versions of Emacs when I write this part (2020): emacsformacsosx, aquamacs, emacs, emacs-plus and emacs-mac from homebrew. I'd like to skip wasting my time comparing the nuances among these versions since I don't believe there're important differences for beginners like me. If there is any, I can simply google and switch to another one, which I don't think will happen recently.

Second, I prefer to stand on other's talents' shoulders to directly get the best out of them. Several configurations are available to quickly make vanilla Emacs into a modern, fancy editor and I finally choose to use [Spacemacs](https://github.com/syl20bnr/spacemacs).


# Install Emacs and Spacemacs

If you don't have Emacs installed on your system, any version I mentioned above is good to have a try. I stick with the installation guide of the Spacemacs:

    brew tap d12frosted/emacs-plus
    brew install emacs-plus
    ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications

The current version of brew has dropped the support of `linkapps` command, so I link the app to the `Applications` folder. Then, if this is NOT a fresh install, please back up your `~/.emacs.d` folder since we will overwrite it for the Spacemacs.

    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

The next step is to install fonts as prefered for the Spacemacs from [here](https://github.com/adobe-fonts/source-code-pro).


# Basic Setup

After the installation is done, we need to run Spacemacs (Emacs) for the first time to generate its default configuration in `~/.spacemacs`. If you don't see any warning or error messages (usually in red), that means you have everything installed correctly.

I set up my Spacemacs in VIM mode and use helm for managing packages.


## config layers

After all modules have been loaded, we can use `SPC f e d` to load the configuration file, which is the only file you're supposed to change for Spacemacs. Let's find `dotspacemacs-configuration-layers` and enable some `layers` we need. 
![configuration layers](//raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/0BooQY.png)

Each time we change the config, we can use `SPC f e R` to check and install layers to make sure what we have is correct.


## user config

Let's scroll down to almost the bottom of the config file to find `user-config` section: 

    defun dotspacemacs/user-config ()

if you have any experience of programming, you can easily tell if a function, which runs after all Spacemacs modules have been loaded. Here we want to add some code to customize it.


### Loading & Storing Paths

I want to store my org files in Dropbox so they will be automatically synced each time I change. This allows me to work seamlessly on different devices. Also, there may some scripts I want to add but not as layers in the Spacemacs, so I need to create a folder to store them and tell the Spacemacs where they are. 

Let's add the following lines as the first two lines to make sure they're defined before using.

    (defvar org-root-folder "~/Dropbox/orgmode/")
    (add-to-list 'load-path "~/.emacs.d/lisp")

**Please manually change the paths to reflect where they are on your computer.**

