---
title: Better process for zsh virtualenvwrapper plugin
date: 2019-9-29
tags: [[[[python, zsh, shell, virtualenv, plugin]]]]
---
# Better process for zsh virtualenvwrapper plugin


Virtualenvwrapper is one of the must-have scripts for building a Python development environment. With the power of zsh oh-my-zsh plugin framework, we can automate some processes such as activate & deactivate.

But the build-in virtualenvwrapper fails to work sometimes what it should be. I decided to fix it by myself after googling for existed solutions.

### virtualenvwrapper plugin analyze & optimize

The existed virtualenvwrapper plugin is quite useful in most of the time, but it would *malfunction* occasionally. So I want to break it down in this section to find proper ways to improve it.

As it is a plugin for zsh environment, the code is quite straightforward.

The first part is used to check system variables and scripts have been installed or not. We don't have to dig into much about how this part works.

```bash
virtualenvwrapper='virtualenvwrapper.sh'

if (( $+commands[$virtualenvwrapper] )); then
  function {
    setopt local_options
    unsetopt equals
    source ${${virtualenvwrapper}:c}
  }
elif [[ -f "/etc/bash_completion.d/virtualenvwrapper" ]]; then
  function {
    setopt local_options
    unsetopt equals
    virtualenvwrapper="/etc/bash_completion.d/virtualenvwrapper"
    source "/etc/bash_completion.d/virtualenvwrapper"
  }
else
  print "zsh virtualenvwrapper plugin: Cannot find ${virtualenvwrapper}.\n"\
        "Please install with \`pip install virtualenvwrapper\`" >&2
  return
fi
if ! type workon &>/dev/null; then
  print "zsh virtualenvwrapper plugin: shell function 'workon' not defined.\n"\
        "Please check ${virtualenvwrapper}" >&2
  return
fi

if [[ "$WORKON_HOME" == "" ]]; then
  print "\$WORKON_HOME is not defined so ZSH plugin virtualenvwrapper will not work" >&2
  return
fi
```

The logical part is in the second part of the plugin code, which contains two parts. The first part is the core while second part simply attaches **workon_cwd** function from first part onto chpwd hook. So we only have to heed to the **workon_cwd** function.

The original code is shown below.

```bash
function workon_cwd {
  if [ ! $WORKON_CWD ]; then
    WORKON_CWD=1
    # Check if this is a Git repo
    # Get absolute path, resolving symlinks
    PROJECT_ROOT="${PWD:A}"
    while [[ "$PROJECT_ROOT" != "/" && ! -e "$PROJECT_ROOT/.venv" ]]; do
      PROJECT_ROOT="${PROJECT_ROOT:h}"
    done
    if [[ "$PROJECT_ROOT" == "/" ]]; then
      PROJECT_ROOT="."
    fi
    # Check for virtualenv name override
    if [[ -f "$PROJECT_ROOT/.venv" ]]; then
      ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
    elif [[ -f "$PROJECT_ROOT/.venv/bin/activate" ]];then
      ENV_NAME="$PROJECT_ROOT/.venv"
    elif [[ "$PROJECT_ROOT" != "." ]]; then
      ENV_NAME="${PROJECT_ROOT:t}"
    else
      ENV_NAME=""
    fi
    if [[ "$ENV_NAME" != "" ]]; then
      # Activate the environment only if it is not already active
      if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
        if [[ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]]; then
          workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"
        elif [[ -e "$ENV_NAME/bin/activate" ]]; then
          source $ENV_NAME/bin/activate && export CD_VIRTUAL_ENV="$ENV_NAME"
        fi
      fi
    elif [[ -n $CD_VIRTUAL_ENV && -n $VIRTUAL_ENV ]]; then
      # We've just left the repo, deactivate the environment
      # Note: this only happens if the virtualenv was activated automatically
      deactivate && unset CD_VIRTUAL_ENV
    fi
    unset PROJECT_ROOT
    unset WORKON_CWD
  fi
}
```

From line 6 to 12, it checks the project root folder with the criteria is whether there is a .venv in the folder. If not, the PROJECT_ROOT variable is . to represent the current folder.

From line 13 to 22, it checks whether there is a .venv file to overwrite virtualenv name from PROJECT*ROOT folder to parent folder recursively. The issue here is that variable ENV*NAME will be set to an empty string if the .venv file could not be found. Then in line 23, the ENV_NAME check will fail because of this, and the plugin fails to activate virtualenv.

The .venv is used to determine whether the folder has virtualenv instead of overwriting the virtualenv name. So we could change the code to set ENV_NAME to current folder name when the .venv file is not found.

```bash
# Check for virtualenv name override
if [[ -f "$PROJECT_ROOT/.venv" ]]; then
  ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
elif [[ -f "$PROJECT_ROOT/.venv/bin/activate" ]];then
  ENV_NAME="$PROJECT_ROOT/.venv"
elif [[ "$PROJECT_ROOT" != "." ]]; then
  ENV_NAME="${PROJECT_ROOT:t}"
else
  FOLDER_NAME=`pwd`
  ENV_NAME=`basename "$FOLDER_NAME"`
fi
```

Here we seem have set everything correct. But when we have sub-folders in the virtualenv root folder, checking ENV_NAME would fail and then deactivate the environment because the sub-folder name doesn't match any virtualenv name. The new logical would illustrate as below.

![flow](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/flow.png)

The code with above logic is shown below.

```bash
# Activate the environment only if it is not already active
if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
  if [[ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]]; then
    workon "$ENV_NAME" && export CD_VIRTUAL_ENV=`pwd`
  elif [[ -e "$ENV_NAME/bin/activate" ]]; then
    source $ENV_NAME/bin/activate && export CD_VIRTUAL_ENV=`pwd`
  elif [[ `pwd` != "$CD_VIRTUAL_ENV"* ]]; then
    # We've just left the repo, deactivate the environment
    # Note: this only happens if the virtualenv was activated automatically
    deactivate && unset CD_VIRTUAL_ENV
  fi
fi
```

Here we can say the new optimized virtualenvwrapper plugin for zsh has finished. It now can automatically activate & deactivate the environment when entering and leaving. The full file can be download from [here](http://kenmlai.me/wp-content/uploads/2015/07/virtualenvwrapper.plugin.zsh_.zip).
