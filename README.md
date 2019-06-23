# Google Drive MySQL Dumper

Small script which exports a MySQL database to a file and uploads it to Google Drive.

By default, the script works on a 14 day retention policy. That is, local and remote backups are kept
for up to 14 days, any local backup files the script finds in the backup directory will be gzipped before
the newest backup is exported and uploaded.

## Requirements
Requires the [gdrive](https://github.com/prasmussen/gdrive) command line utility for Google Drive.

## Installation
1. Download the [gdrive](https://github.com/prasmussen/gdrive)  utility from its GitHub page and follow its installation guide.

# find installation file version specifiv to your version
wget -O gdrive "https://drive.google.com/uc?id=1Ej8VgsW5RgK66Btb9p74tSdHMH3p4UNb&export=download"
chmod +x gdrive
sudo mv gdrive /usr/local/bin/

2. Clone this repository
3. Make the `db-dump.sh` script executable, and link it somewhere it can be called from any directory e.g:

	```sh
	$ chmod +x /path/to/db-dump.sh
	$ sudo ln -s /path/to/db-dump.sh /usr/local/bin/db-dump
	```
		
4. Set up your `db-dump.conf` file, either manually by copying `db-dump.conf.dist`, or by typing `db-dump config` at the command line:

	```sh
	$ db-dump config
	Generating config file...
	Enter Database Name: mydatabase    
	Enter Google Drive Folder ID: abc123def456
	Config file generated.
	```
		
5. Run the script

	```sh
	$ db-dump
	Uploading /var/spool/db-dump/mydatabase-2016-11-09_17:09:51.sql
	Uploaded 0BwvPrE-VPdlkb7BhLGVJZUxST1z at 356.8 KB/s, total 683.5 KB
	Done
	```

## Configuration

The following options must be set and do **not** have default values:

| Option | Description |
| ------ | ----------- |
| db_name | Name of the database to export |
| gdrive_folder_id | Google Drive folder ID where files get uploaded |

The following options **do** have default values and can be tweaked as desired:

| Option | Description | Default |
| ------ | ----------- | ------- |
| date_format | Date format for dates appended to export files | `%Y-%m-%d_%H:%M:%S` |
| dump_dir | The local directory where export files will be stored | `/var/spool/db-dump` |
| retention_days | The number of days to retain export files | `14` |
| mysql_opts | Options to pass to `mysqldump` e.g: "-uroot" | (None) |

Options can be changed in the main `db-dump.conf` file or can be overridden on a per user basis by creating
a config file within your home directory: `$HOME/.config/db-dump.conf`

Options can also be changed by passing a config file as the first argument to the script. This allows the script to be
used with different databases and configurations:

```sh
db-dump /path/to/my/db-dump.conf
```

## Automation
The easiest way to automatically run the script over a given interval is to link it into one of the
`/etc/cron.*` directories, e.g:

```sh
sudo ln -s /path/to/db-dump.sh /etc/cron.daily/db-dump
```

The above command will cause the script to be run once every 24 hours.

## License
Released under the [MIT license](LICENSE)
