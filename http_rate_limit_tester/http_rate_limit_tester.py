import time
import urllib.request

URL = 'http://stackoverflow.com/'

def request_time():
    start_time = time.time()
    urllib.request.urlopen(URL).read()
    end_time = time.time()
    return end_time - start_time

def throttling_test(n):
    """Test if processing more than n requests is throttled."""
    print('Testing ' + URL)
    t = list()
    experiment_start = time.time()
    for i in range(n):
        t.append(request_time())
        print('Request #%d took %.5f ms' % (i+1, t[-1] * 1000.0))
    print('--- Throttling limit crossed ---')

    t.append(request_time())
    print('Request #%d took %.5f ms' % (n+1, t[-1] * 1000.0))
    print(f'''--- Results ---
URL\t{URL}
Limit\tx{n}
Min\t#{t.index(min(t))+1} took {format(min(t) * 1000.0, '.5f')}ms
Max\t#{t.index(max(t))+1} took {format(max(t) * 1000.0, '.5f')}ms
Avg\t{format(sum(t) / len(t) * 1000.0, '.5f')}ms
''')
    
throttling_test(5)
