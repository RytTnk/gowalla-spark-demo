from IPython.display import HTML

import random
import string
import json

def chart(chart_def = None, height='400px', width=None):
    unique_id = ''.join(random.choice(string.ascii_uppercase + string.digits) for x in range(15))
    chart_def_json = json.dumps(chart_def)

    if width is None:
        width='100%'
    
    html = '''
<div id="chart_%(unique_id)s" style="width: %(width)s; height: %(height)s; margin: 0 auto">Re-run cell if chart is not shown ...</div>
<script>
    do_chart_%(unique_id)s = function() {
        $('#chart_%(unique_id)s').highcharts(%(chart_def_json)s);
    }
    setTimeout("do_chart_%(unique_id)s()", 100)
</script>
''' % locals()
    return HTML(html)
