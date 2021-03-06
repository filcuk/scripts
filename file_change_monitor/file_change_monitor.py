#!/usr/bin/env python

import os, sys, time
from datetime import datetime

def files_to_timestamp(path):
    files = [os.path.join(path, f) for f in os.listdir(path)]
    return dict ([(f, os.path.getmtime(f)) for f in files])

if __name__ == "__main__":

    path_to_watch = sys.argv[1]
    print('Watching: {}..'.format(path_to_watch))

    before = files_to_timestamp(path_to_watch)

    while 1:
        time.sleep (2)
        after = files_to_timestamp(path_to_watch)

        added = [f for f in after.keys() if not f in before.keys()]
        removed = [f for f in before.keys() if not f in after.keys()]
        modified = []

        for f in before.keys():
            if not f in removed:
                if os.path.getmtime(f) != before.get(f):
                    modified.append(f)

        timestamp = datetime.now().strftime('%H:%M:%S')
        if added: print('{} Added: {}'.format(timestamp, ', '.join(added)))
        if removed: print('{} Removed: {}'.format(timestamp, ', '.join(removed)))
        if modified: print('{} Modified: {}'.format(timestamp, ', '.join(modified)))

        before = after