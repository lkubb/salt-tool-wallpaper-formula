.. _readme:

Wallpapers Formula
==================

Manages wallpapers in the user environment.

.. contents:: **Table of Contents**
   :depth: 1

Usage
-----
Applying ``tool_wallpapers`` will make sure will make sure the wallpaper is configured as specified. Works on MacOS currently, Windows and Linux to come.

It syncs the pictures from a repo. See `Dotfiles`_.

Configuration
-------------

This formula
~~~~~~~~~~~~
The general configuration structure is in line with all other formulae from the `tool` suite, for details see :ref:`toolsuite`. An example pillar is provided, see :ref:`pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in :ref:`map.jinja`.

User-specific
^^^^^^^^^^^^^
The following shows an example of ``tool_wallpapers`` per-user configuration. If provided by pillar, namespace it to ``tool_global:users`` and/or ``tool_wallpapers:users``. For the ``parameters`` YAML file variant, it needs to be nested under a ``values`` parent key. The YAML files are expected to be found in

1. ``salt://tool_wallpapers/parameters/<grain>/<value>.yaml`` or
2. ``salt://tool_global/parameters/<grain>/<value>.yaml``.

.. code-block:: yaml

  user:

      # Force the usage of XDG directories for this user.
    xdg: true

      # Sync this user's wallpapers from a dotfiles repo.
      # The available paths and their priority can be found in the
      # rendered `config/sync.sls` file (currently, @TODO docs).
      # Overview in descending priority:
      # salt://dotconfig/<minion_id>/<user>/wallpapers
      # salt://dotconfig/<minion_id>/wallpapers
      # salt://dotconfig/<os_family>/<user>/wallpapers
      # salt://dotconfig/<os_family>/wallpapers
      # salt://dotconfig/default/<user>/wallpapers
      # salt://dotconfig/default/wallpapers
      # salt://dotdata/<minion_id>/<user>/wallpapers
      # salt://dotdata/<minion_id>/wallpapers
      # salt://dotdata/<os_family>/<user>/wallpapers
      # salt://dotdata/<os_family>/wallpapers
      # salt://dotdata/default/<user>/wallpapers
      # salt://dotdata/default/wallpapers
    dotconfig:              # can be bool or mapping
      file_mode: '0600'     # default: keep destination or salt umask (new)
      dir_mode: '0700'      # default: 0700
      clean: false          # delete files in target. default: false

      # Persist environment variables used by this formula for this
      # user to this file (will be appended to a file relative to $HOME)
    persistenv: '.config/zsh/zshenv'

      # Add runcom hooks specific to this formula to this file
      # for this user (will be appended to a file relative to $HOME)
    rchook: '.config/zsh/zshrc'

      # This user's configuration for this formula. Will be overridden by
      # user-specific configuration in `tool_wallpapers:users`.
      # Set this to `false` to disable configuration for this user.
    wallpapers:
        # This is the filename of the default wallpaper for this user.
        # In the future, I want to add more possibilities (resolution-dependent,
        # monitor-specific).
      default: rather_sick_wallpaper.png

Formula-specific
^^^^^^^^^^^^^^^^

.. code-block:: yaml

  tool_wallpapers:

      # Default formula configuration for all users.
    defaults:
      default: default value for all users

Dotfiles
~~~~~~~~
``tool_wallpapers.config.sync`` will recursively apply templates from

* ``salt://dotconfig/<minion_id>/<user>/wallpapers``
* ``salt://dotconfig/<minion_id>/wallpapers``
* ``salt://dotconfig/<os_family>/<user>/wallpapers``
* ``salt://dotconfig/<os_family>/wallpapers``
* ``salt://dotconfig/default/<user>/wallpapers``
* ``salt://dotconfig/default/wallpapers``
* ``salt://dotdata/<minion_id>/<user>/wallpapers``
* ``salt://dotdata/<minion_id>/wallpapers``
* ``salt://dotdata/<os_family>/<user>/wallpapers``
* ``salt://dotdata/<os_family>/wallpapers``
* ``salt://dotdata/default/<user>/wallpapers``
* ``salt://dotdata/default/wallpapers``

to the user's config dir for every user that has it enabled (see ``user.dotconfig``). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).

The URL list above is in descending priority. This means user-specific configuration from wider scopes will be overridden by more system-specific general configuration.


Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_wallpapers``
~~~~~~~~~~~~~~~~~~~



``tool_wallpapers.config``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Syncs wallpapers by

* recursively syncing from a dotfiles repo


``tool_wallpapers.apply``
~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_wallpapers.apply.Darwin``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_wallpapers.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_wallpapers.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes custom wallpapers.



Development
-----------

Contributing to this repo
~~~~~~~~~~~~~~~~~~~~~~~~~

Commit messages
^^^^^^^^^^^^^^^

Commit message formatting is significant.

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``.

.. code-block:: console

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Todo
----
* implement with os api
* add desktop-specific config (rather than all) (see reference)
* add Linux
* add Windows

References
----------
* https://github.com/gregneagle/psumac2017/blob/master/05_AppKit_NSWorkspace/06_desktop_picture.py
* https://developer.apple.com/documentation/appkit/nsworkspace
