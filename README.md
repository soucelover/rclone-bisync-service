# rclone-bisync-service

A bash rclone bisynchronisation script installable as a Linux script

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
sh ./edit_config.sh
```

In the file, edit `LOCAL_DIR` and `REMOTE_DIR` variables.

### Install the script as a service

Run the following command to install the script as a service:

```bash
sh ./install_script.sh
```

The synchronisation interval can be customized by setting `SYNC_INTERVAL_MINUTES` environment variable before the setup.

```bash
export SYNC_INTERVAL_MINUTES=5
```
