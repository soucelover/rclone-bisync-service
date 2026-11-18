# rclone-bisync-service

A bash rclone bisynchronisation script installable as a Linux script

## How it works

The script periodically synchronizes two directories using `rclone` in a bidirectional manner, ensuring that changes in either directory are reflected in the other.

The script is installed as a systemd user service, which means it will run in the background and automatically start on boot. Background syncronization time interval is controlled by a `.timer` unit and is configured during the installation process.

After initialization, the synchronized folders can only be removed by using `rclone` commands, such as `rclone delete` or `rclone purge`. Otherwise, `rclone` will either recteate the folder or fail at bidirectional synchronization.

The `--check-access` flag is used to verify that the user has the necessary permissions to access the directories before attempting to synchronize them.

## Setting up

To properly set the script up, follow the following steps.

### Install `rclone`

Install `rclone` program from [the official site](https://rclone.org/install/).

The following script installation may be used for that matter:

```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

### Set up at least one `rclone` remote

Run the following command:

```bash
rclone config
```

Type in 'n' to create a new remote and then follow prompts to set it up.

### Edit the configuration file

Update the script's configuration to use the newly created remote. For that, run command:

```bash
bash ./edit_config.sh
```

In the file, edit `LOCAL_DIR` and `REMOTE_DIR` variables.

### Install the script as a service

Run the following command to install the script as a service:

```bash
bash ./install_script.sh
```

The synchronisation interval can be customized by setting `SYNC_INTERVAL_MINUTES` environment variable before the setup.

```bash
export SYNC_INTERVAL_MINUTES=5
```
