
# DB host (secondary preferred as to avoid impacting primary performance)
HOST=localhost

# DB name
DBNAME=database_name

# Current time
TIME=`/bin/date +%d-%m-%Y-%T`

# Backup directory
DEST=bentarDB_backup

# Tar file of backup directory
TAR=$DEST/$TIME.tar

# Days to keep the backup
DAYSTORETAINBACKUP="7"

# Create backup dir (-p to avoid warning if already exists)
/bin/mkdir -p $DEST

# Log
echo "Backing up $HOST/$DBNAME to grive://$DEST/ on $TIME";

# Dump from mongodb host into backup directory
/usr/bin/mongodump -h $HOST -u username -p password --authenticationDatabase admin  -d $DBNAME -o $DEST
# Create tar of backup directory
/bin/tar cvf $TAR -C $DEST/$DBNAME .

# Remove backup directory
/bin/rm -rf $DEST/$DBNAME

# Delete backups older than retention period
find $DEST -type f -mtime +$DAYSTORETAINBACKUP -exec rm {} +

# Grive sync
grive -s $DEST

# All done
echo "Backup available at Drive $TIME.tar"
