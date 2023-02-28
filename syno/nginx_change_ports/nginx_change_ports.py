import os
import shutil
import time

print("Start OK")

NGINX = "/usr/syno/share/nginx"
MUSTACHE = ["DSM.mustache","server.mustache","WWWService.mustache"]
BACKUP_FILES = True # change to false to disable backups
BACKUP_DIR = "/volume1/docker/nginx/backup"
DELETE_OLD_BACKUPS = True # change to true to automatically delete old backups.
KEEP_BACKUP_DAYS = 30
DATE = time.strftime("%Y-%m-%d_%H-%M-%S")
CURRENT_BACKUP_DIR = os.path.join(BACKUP_DIR,DATE)
NEW_HTTP_PORT=79
OLD_HTTP_PORT=80
NEW_HTTPS_PORT=444
OLD_HTTPS_PORT=443

for file in MUSTACHE:
    if BACKUP_FILES:
        os.makedirs(CURRENT_BACKUP_DIR, exist_ok=True)
        shutil.copy(os.path.join(NGINX,file),CURRENT_BACKUP_DIR)
        print("Backup Done")
    data = open(os.path.join(NGINX,file), 'rt').read().replace('listen 80',f'listen {NEW_HTTP_PORT}').replace('listen [::]:80',f'listen [::]:{NEW_HTTP_PORT}').replace('listen 443',f'listen {NEW_HTTPS_PORT}').replace('listen [::]:443', F'listen [::]:{NEW_HTTPS_PORT}')
    open(os.path.join(NGINX,file), 'wt').write(data)
print("Mod Done")

if not DELETE_OLD_BACKUPS:
    for f in os.listdir(BACKUP_DIR):
        f = os.path.join(BACKUP_DIR, f)
        if os.stat(f).st_mtime < time.time() - KEEP_BACKUP_DAYS * 86400:
            if os.path.isdir(f):
                shutil.rmtree(f)

#
# Perform nginx reload if running on DSM 7.X
if open('/etc.defaults/VERSION','r').read().find('majorversion="7"') != -1:
    print("Restart service")
    os.system('systemctl restart nginx')
print("All Done")