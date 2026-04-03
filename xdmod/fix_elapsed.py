#!/usr/bin/env python

import sys
import pandas as pd
from datetime import datetime, time, timedelta

def main():
    if len(sys.argv) < 2:
        print("Missing filename(s).", file=sys.stderr)
        sys.exit(1)
    cols = ['jobid', 'jobidraw', 'cluster', 'partition', 'qos', 'account', 'group', 'gid', 'user', 'uid', 'submit', 'eligible', 'start', 'end', 'elapsed', 'exitcode', 'state', 'nnodes', 'ncpus', 'reqcpus', 'reqmem', 'reqtres', 'alloctres', 'timelimit', 'nodelist', 'jobname']
    for filename in sys.argv[1:]:
        df = pd.read_csv(filename, names=cols, sep='|',  on_bad_lines='warn')
        data = []
        for _, row in df.iterrows():
            end_state = row['state']
            if (end_state == 'PREEMPTED' or end_state == 'COMPLETED' or end_state == 'FAILED' or end_state.startswith('CANCELLED')) and row['elapsed'] == '00:00:00':
                print('found zero in ', filename)
                dt = datetime.fromisoformat(row['end'])
                dt = dt + timedelta(seconds=1)
                ts = dt.isoformat()
                row['end'] = ts
                row['elapsed'] = '00:00:01'
            data.append(row)
        df = pd.DataFrame(data)
        df.to_csv(filename, header=False, sep='|', index=False)

if __name__ == "__main__":
    main()
